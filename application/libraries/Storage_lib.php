<?php
/**
 * Storage_lib — transparent local/R2 file storage wrapper.
 *
 * If R2_ENDPOINT, R2_ACCESS_KEY, R2_SECRET_KEY are set in the environment
 * all uploads go to Cloudflare R2.  Otherwise the library falls back to the
 * local ./uploads directory so local development needs no cloud credentials.
 *
 * Usage in a controller:
 *
 *   // 1. Let CI3's Upload library validate and write the temp file as usual.
 *   $this->load->library('upload', ['upload_path' => '/tmp/ci_upload', ...]);
 *   $this->upload->do_upload('photo');
 *   $info = $this->upload->data();
 *
 *   // 2. Hand off to Storage_lib — returns a public URL or false.
 *   $url = $this->storage_lib->from_ci_upload($info, 'students/' . $info['file_name']);
 *   if ($url === false) { ... handle error ... }
 *
 *   // 3. Save $url in the database instead of a bare filename.
 *
 * Retrieving stored files:
 *   echo $this->storage_lib->url('students/photo.jpg');
 *
 * Deleting:
 *   $this->storage_lib->delete('students/photo.jpg');
 */

defined('BASEPATH') OR exit('No direct script access allowed');

use Aws\S3\S3Client;
use Aws\Exception\AwsException;

class Storage_lib
{
    /** @var S3Client|null */
    private $s3 = null;

    private $bucket   = '';
    private $base_url = '';
    private $local    = true;

    public function __construct()
    {
        $endpoint   = getenv('R2_ENDPOINT');   // https://<acct>.r2.cloudflarestorage.com
        $access_key = getenv('R2_ACCESS_KEY');
        $secret_key = getenv('R2_SECRET_KEY');
        $bucket     = getenv('R2_BUCKET')     ?: 'lms-uploads';
        $public_url = getenv('R2_PUBLIC_URL') ?: ''; // your R2 custom domain or pub URL

        if ($endpoint && $access_key && $secret_key) {
            $this->s3 = new S3Client([
                'version'                 => 'latest',
                'region'                  => 'auto',
                'endpoint'                => $endpoint,
                'use_path_style_endpoint' => true,
                'credentials'             => [
                    'key'    => $access_key,
                    'secret' => $secret_key,
                ],
            ]);
            $this->bucket   = $bucket;
            $this->base_url = rtrim($public_url, '/');
            $this->local    = false;
        }
        // else: fall through to local-disk mode; $this->local stays true
    }

    // ── Public API ─────────────────────────────────────────────────────────────

    /**
     * Upload any local file to storage.
     *
     * @param  string $source_path  Absolute path to the file on disk.
     * @param  string $dest_key     Destination key, e.g. "students/abc.jpg".
     * @return string|false         Public URL on success, false on failure.
     */
    public function upload(string $source_path, string $dest_key)
    {
        if ($this->local) {
            return $this->local_copy($source_path, $dest_key);
        }

        try {
            $this->s3->putObject([
                'Bucket'      => $this->bucket,
                'Key'         => $dest_key,
                'SourceFile'  => $source_path,
                'ContentType' => $this->mime($source_path),
            ]);
            return $this->url($dest_key);
        } catch (AwsException $e) {
            log_message('error', 'Storage_lib::upload R2 error: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Convenience method: call this right after CI3's upload->do_upload().
     * It reads the temp file CI3 wrote, pushes to R2 (or local), then
     * removes the temp file when running in R2 mode.
     *
     * @param  array  $ci_data   The array returned by $this->upload->data().
     * @param  string $dest_key  Storage key for the file.
     * @return string|false
     */
    public function from_ci_upload(array $ci_data, string $dest_key)
    {
        $source = $ci_data['full_path'];
        $url    = $this->upload($source, $dest_key);

        // Remove local temp copy only when it was successfully sent to R2
        if (!$this->local && $url !== false && file_exists($source)) {
            @unlink($source);
        }

        return $url;
    }

    /**
     * Return the public URL for a stored key.
     * Works in both local and R2 modes.
     */
    public function url(string $key): string
    {
        if ($this->local) {
            return base_url('uploads/' . ltrim($key, '/'));
        }
        return $this->base_url . '/' . ltrim($key, '/');
    }

    /**
     * Delete a stored file.
     */
    public function delete(string $key): bool
    {
        if ($this->local) {
            $path = FCPATH . 'uploads/' . ltrim($key, '/');
            return !file_exists($path) || @unlink($path);
        }

        try {
            $this->s3->deleteObject([
                'Bucket' => $this->bucket,
                'Key'    => $key,
            ]);
            return true;
        } catch (AwsException $e) {
            log_message('error', 'Storage_lib::delete R2 error: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Whether the library is using cloud storage (true) or local disk (false).
     * Useful in controllers that need to know where files actually live.
     */
    public function is_cloud(): bool
    {
        return !$this->local;
    }

    // ── Internals ──────────────────────────────────────────────────────────────

    private function local_copy(string $source, string $key): string|false
    {
        $dest = FCPATH . 'uploads/' . ltrim($key, '/');
        $dir  = dirname($dest);

        if (!is_dir($dir) && !mkdir($dir, 0755, true)) {
            log_message('error', 'Storage_lib: could not create directory ' . $dir);
            return false;
        }

        if (!copy($source, $dest)) {
            log_message('error', 'Storage_lib: copy failed ' . $source . ' → ' . $dest);
            return false;
        }

        return $this->url($key);
    }

    private function mime(string $path): string
    {
        if (function_exists('mime_content_type')) {
            $m = mime_content_type($path);
            if ($m) return $m;
        }
        $ext = strtolower(pathinfo($path, PATHINFO_EXTENSION));
        $map = [
            'jpg'  => 'image/jpeg', 'jpeg' => 'image/jpeg',
            'png'  => 'image/png',  'gif'  => 'image/gif',
            'pdf'  => 'application/pdf',
            'zip'  => 'application/zip',
            'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        ];
        return $map[$ext] ?? 'application/octet-stream';
    }
}
