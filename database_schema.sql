-- Smart School LMS - Database Schema
-- Reconstructed from application models
-- Run this on a fresh MySQL database named: ssnodb

SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------------------
-- GROUP 1: Independent / lookup tables
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(100) NOT NULL,
  `short_code` varchar(10) NOT NULL,
  `is_rtl` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `languages` (`id`, `language`, `short_code`, `is_rtl`) VALUES (1, 'English', 'en', 0);

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `sessions` (`id`, `session`, `is_active`) VALUES (1, '2024-25', 1);

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `roles` (`id`, `name`, `is_active`) VALUES
(1, 'Admin', 1),
(2, 'Teacher', 1),
(3, 'Accountant', 1),
(4, 'Librarian', 1),
(5, 'Receptionist', 1);

CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `classes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `department` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `department_name` varchar(150) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_designation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `designation` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `feecategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `feetype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `feecategory_id` int(11) DEFAULT NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `feecategory_id` (`feecategory_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `leave_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `attendence_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `key_value` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `attendence_type` (`id`, `type`, `key_value`, `is_active`) VALUES
(1, 'Present', 'present', 1),
(2, 'Absent', 'absent', 1),
(3, 'Late', 'late', 1),
(4, 'Half Day', 'half_day', 1);

CREATE TABLE IF NOT EXISTS `staff_attendance_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `key_value` varchar(50) DEFAULT NULL,
  `is_active` varchar(10) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `staff_attendance_type` (`id`, `type`, `key_value`, `is_active`) VALUES
(1, 'Present', 'present', '1'),
(2, 'Absent', 'absent', '1'),
(3, 'Late', 'late', '1'),
(4, 'Half Day', 'half_day', '1');

CREATE TABLE IF NOT EXISTS `expense_head` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exp_category` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `income_head` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `income_category` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `complaint_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `source` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `enquiry_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `reference` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reference` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `room_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_type` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `filetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filetype` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `permission_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `short_code` varchar(100) NOT NULL,
  `system` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `student` tinyint(1) NOT NULL DEFAULT 0,
  `parent` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `disable_reason` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `visitors_purpose` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purpose` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `transport_route` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_title` varchar(150) NOT NULL,
  `fare` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_no` varchar(50) NOT NULL,
  `vehicle_model` varchar(100) DEFAULT NULL,
  `driver_name` varchar(100) DEFAULT NULL,
  `driver_contact` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `school_houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_name` varchar(100) NOT NULL,
  `is_active` varchar(10) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `hostel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostel_name` varchar(150) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `item_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_category` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `item_store` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_store` varchar(100) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `item_supplier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_supplier` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `lang_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `fee_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject_id` int(11) DEFAULT NULL,
  `question` text NOT NULL,
  `opt_a` text DEFAULT NULL,
  `opt_b` text DEFAULT NULL,
  `opt_c` text DEFAULT NULL,
  `opt_d` text DEFAULT NULL,
  `opt_e` text DEFAULT NULL,
  `correct` varchar(10) DEFAULT NULL,
  `question_type` varchar(50) DEFAULT NULL,
  `level` varchar(50) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `class_section_id` int(11) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subject_id` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------
-- GROUP 2: Tables with basic FK dependencies
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vehicle_routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `route_id` (`route_id`),
  KEY `vehicle_id` (`vehicle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `hostel_rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostel_id` int(11) NOT NULL,
  `room_type_id` int(11) DEFAULT NULL,
  `room_no` varchar(50) NOT NULL,
  `number_of_bed` int(11) NOT NULL DEFAULT 1,
  `cost_per_bed` decimal(10,2) NOT NULL DEFAULT 0.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `hostel_id` (`hostel_id`),
  KEY `room_type_id` (`room_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `class_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `father_name` varchar(100) DEFAULT NULL,
  `mother_name` varchar(100) DEFAULT NULL,
  `employee_id` varchar(50) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `marital_status` varchar(30) DEFAULT NULL,
  `date_of_joining` date DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `emergency_contact` varchar(20) DEFAULT NULL,
  `contact_no` varchar(20) DEFAULT NULL,
  `qualification` text DEFAULT NULL,
  `work_experience` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `epf_no` varchar(50) DEFAULT NULL,
  `basic_salary` decimal(10,2) DEFAULT NULL,
  `contract_type` varchar(50) DEFAULT NULL,
  `work_shift` varchar(50) DEFAULT NULL,
  `work_location` varchar(100) DEFAULT NULL,
  `designation` int(11) DEFAULT NULL,
  `department` int(11) DEFAULT NULL,
  `lang_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `image` varchar(255) DEFAULT NULL,
  `current_address` text DEFAULT NULL,
  `permanent_address` text DEFAULT NULL,
  `local_address` text DEFAULT NULL,
  `user_type` varchar(50) DEFAULT NULL,
  `verification_code` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `resume` varchar(255) DEFAULT NULL,
  `joining_letter` varchar(255) DEFAULT NULL,
  `resignation_letter` varchar(255) DEFAULT NULL,
  `other_document_name` varchar(255) DEFAULT NULL,
  `other_document_file` varchar(255) DEFAULT NULL,
  `disable_at` datetime DEFAULT NULL,
  `account_details` text DEFAULT NULL,
  `social_media` text DEFAULT NULL,
  `bank_account_no` varchar(50) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `ifsc_code` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `designation` (`designation`),
  KEY `department` (`department`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admission_no` varchar(50) DEFAULT NULL,
  `roll_no` varchar(50) DEFAULT NULL,
  `admission_date` date DEFAULT NULL,
  `firstname` varchar(100) NOT NULL,
  `middlename` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `mobileno` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(20) DEFAULT NULL,
  `religion` varchar(50) DEFAULT NULL,
  `cast` varchar(50) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `blood_group` varchar(10) DEFAULT NULL,
  `current_address` text DEFAULT NULL,
  `permanent_address` text DEFAULT NULL,
  `previous_school` varchar(255) DEFAULT NULL,
  `guardian_is` varchar(30) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `adhar_no` varchar(30) DEFAULT NULL,
  `samagra_id` varchar(30) DEFAULT NULL,
  `bank_account_no` varchar(50) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `ifsc_code` varchar(30) DEFAULT NULL,
  `guardian_name` varchar(150) DEFAULT NULL,
  `guardian_relation` varchar(50) DEFAULT NULL,
  `guardian_phone` varchar(20) DEFAULT NULL,
  `guardian_email` varchar(150) DEFAULT NULL,
  `guardian_address` text DEFAULT NULL,
  `guardian_occupation` varchar(100) DEFAULT NULL,
  `guardian_pic` varchar(255) DEFAULT NULL,
  `father_name` varchar(150) DEFAULT NULL,
  `father_phone` varchar(20) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `father_pic` varchar(255) DEFAULT NULL,
  `mother_name` varchar(150) DEFAULT NULL,
  `mother_phone` varchar(20) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `mother_pic` varchar(255) DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `measurement_date` date DEFAULT NULL,
  `school_house_id` int(11) DEFAULT NULL,
  `vehroute_id` int(11) DEFAULT NULL,
  `hostel_room_id` int(11) DEFAULT NULL,
  `rte` varchar(10) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `is_active` varchar(10) NOT NULL DEFAULT '1',
  `dis_reason` varchar(255) DEFAULT NULL,
  `dis_note` text DEFAULT NULL,
  `app_key` varchar(255) DEFAULT NULL,
  `parent_app_key` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `disable_at` datetime DEFAULT NULL,
  `national_identification_no` varchar(50) DEFAULT NULL,
  `local_identification_no` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `school_house_id` (`school_house_id`),
  KEY `vehroute_id` (`vehroute_id`),
  KEY `hostel_room_id` (`hostel_room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `username` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `lang_id` int(11) DEFAULT NULL,
  `childs` text DEFAULT NULL,
  `verification_code` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `lang_id` (`lang_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `subject_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `session_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `permission_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `short_code` varchar(100) NOT NULL,
  `perm_group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `perm_group_id` (`perm_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `roles_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `perm_cat_id` int(11) NOT NULL,
  `can_view` tinyint(1) NOT NULL DEFAULT 0,
  `can_add` tinyint(1) NOT NULL DEFAULT 0,
  `can_edit` tinyint(1) NOT NULL DEFAULT 0,
  `can_delete` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `perm_cat_id` (`perm_cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `role_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `permission_student` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `student` tinyint(1) NOT NULL DEFAULT 0,
  `parent` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_name` varchar(150) NOT NULL,
  `item_category_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `item_category_id` (`item_category_id`),
  KEY `supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `lang_pharses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key_id` int(11) NOT NULL,
  `lang_id` int(11) NOT NULL,
  `pharses` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `key_id` (`key_id`),
  KEY `lang_id` (`lang_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `fee_session_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fee_groups_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fee_groups_id` (`fee_groups_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `exams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `exam_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `exam_type` varchar(250) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  `is_active` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `onlineexam` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) NOT NULL,
  `exam` varchar(150) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `attempt` int(11) NOT NULL DEFAULT 1,
  `exam_from` datetime DEFAULT NULL,
  `exam_to` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `passing_percentage` decimal(5,2) DEFAULT NULL,
  `publish_result` tinyint(1) NOT NULL DEFAULT 0,
  `is_rank_generated` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `email_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `host` varchar(150) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `username` varchar(150) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `sender_name` varchar(100) DEFAULT NULL,
  `sender_email` varchar(150) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `sms_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `payment_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_type` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `notification_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `fees_discounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `fees_reminder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `message` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_marks` decimal(10,2) NOT NULL,
  `to_marks` decimal(10,2) NOT NULL,
  `grade` varchar(10) NOT NULL,
  `grade_point` decimal(5,2) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `template_admitcards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `template_marksheets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `id_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_id_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `certificates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `categories_front` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `front_cms_menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `menu_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `front_cms_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `front_cms_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `front_cms_programs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `front_cms_media_gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `dispatch_receive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `from_title` varchar(255) DEFAULT NULL,
  `to_title` varchar(255) DEFAULT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `note` text DEFAULT NULL,
  `date` date DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `general_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `print_headerfooter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_type` varchar(50) NOT NULL,
  `header_image` varchar(255) DEFAULT NULL,
  `footer_content` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `custom_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `belong_to` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_edit_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `question_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `option` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `question_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `option_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  KEY `option_id` (`option_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------
-- GROUP 3: Tables depending on staff/students/sessions
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `sch_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lang_id` int(11) DEFAULT NULL,
  `languages` varchar(255) DEFAULT NULL,
  `class_teacher` varchar(10) DEFAULT NULL,
  `is_rtl` tinyint(1) NOT NULL DEFAULT 0,
  `cron_secret_key` varchar(100) DEFAULT NULL,
  `timezone` varchar(100) DEFAULT 'Asia/Kolkata',
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `biometric` tinyint(1) NOT NULL DEFAULT 0,
  `biometric_device` varchar(100) DEFAULT NULL,
  `time_format` varchar(10) DEFAULT '24',
  `phone` varchar(20) DEFAULT NULL,
  `attendence_type` varchar(20) DEFAULT 'daily',
  `address` text DEFAULT NULL,
  `dise_code` varchar(50) DEFAULT NULL,
  `date_format` varchar(20) DEFAULT 'd-m-Y',
  `currency` varchar(20) DEFAULT 'INR',
  `currency_symbol` varchar(10) DEFAULT '₹',
  `currency_place` varchar(10) DEFAULT 'before',
  `start_month` varchar(10) DEFAULT '04',
  `start_week` varchar(10) DEFAULT 'Monday',
  `session_id` int(11) DEFAULT NULL,
  `fee_due_days` int(11) DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `theme` varchar(50) DEFAULT 'blue',
  `online_admission` tinyint(1) NOT NULL DEFAULT 0,
  `is_duplicate_fees_invoice` tinyint(1) NOT NULL DEFAULT 0,
  `is_student_house` tinyint(1) NOT NULL DEFAULT 0,
  `is_blood_group` tinyint(1) NOT NULL DEFAULT 0,
  `admin_logo` varchar(255) DEFAULT NULL,
  `admin_small_logo` varchar(255) DEFAULT NULL,
  `mobile_api_url` varchar(255) DEFAULT NULL,
  `app_primary_color_code` varchar(20) DEFAULT NULL,
  `app_secondary_color_code` varchar(20) DEFAULT NULL,
  `app_logo` varchar(255) DEFAULT NULL,
  `student_profile_edit` tinyint(1) NOT NULL DEFAULT 0,
  `adm_prefix` varchar(20) DEFAULT NULL,
  `adm_start_from` int(11) DEFAULT 1,
  `adm_no_digit` int(11) DEFAULT 5,
  `adm_update_status` tinyint(1) NOT NULL DEFAULT 0,
  `adm_auto_insert` tinyint(1) NOT NULL DEFAULT 0,
  `staffid_prefix` varchar(20) DEFAULT NULL,
  `staffid_start_from` int(11) DEFAULT 1,
  `staffid_auto_insert` tinyint(1) NOT NULL DEFAULT 0,
  `staffid_no_digit` int(11) DEFAULT 5,
  `staffid_update_status` tinyint(1) NOT NULL DEFAULT 0,
  `roll_no` tinyint(1) NOT NULL DEFAULT 1,
  `lastname` tinyint(1) NOT NULL DEFAULT 1,
  `middlename` tinyint(1) NOT NULL DEFAULT 1,
  `category` tinyint(1) NOT NULL DEFAULT 1,
  `cast` tinyint(1) NOT NULL DEFAULT 1,
  `religion` tinyint(1) NOT NULL DEFAULT 1,
  `mobile_no` tinyint(1) NOT NULL DEFAULT 1,
  `student_email` tinyint(1) NOT NULL DEFAULT 1,
  `admission_date` tinyint(1) NOT NULL DEFAULT 1,
  `student_photo` tinyint(1) NOT NULL DEFAULT 1,
  `student_height` tinyint(1) NOT NULL DEFAULT 1,
  `student_weight` tinyint(1) NOT NULL DEFAULT 1,
  `measurement_date` tinyint(1) NOT NULL DEFAULT 1,
  `father_name` tinyint(1) NOT NULL DEFAULT 1,
  `father_phone` tinyint(1) NOT NULL DEFAULT 1,
  `father_occupation` tinyint(1) NOT NULL DEFAULT 1,
  `father_pic` tinyint(1) NOT NULL DEFAULT 1,
  `mother_name` tinyint(1) NOT NULL DEFAULT 1,
  `mother_phone` tinyint(1) NOT NULL DEFAULT 1,
  `mother_occupation` tinyint(1) NOT NULL DEFAULT 1,
  `mother_pic` tinyint(1) NOT NULL DEFAULT 1,
  `guardian_phone` tinyint(1) NOT NULL DEFAULT 1,
  `guardian_name` tinyint(1) NOT NULL DEFAULT 1,
  `guardian_relation` tinyint(1) NOT NULL DEFAULT 1,
  `guardian_email` tinyint(1) NOT NULL DEFAULT 1,
  `guardian_pic` tinyint(1) NOT NULL DEFAULT 1,
  `guardian_occupation` tinyint(1) NOT NULL DEFAULT 1,
  `guardian_address` tinyint(1) NOT NULL DEFAULT 1,
  `current_address` tinyint(1) NOT NULL DEFAULT 1,
  `permanent_address` tinyint(1) NOT NULL DEFAULT 1,
  `route_list` tinyint(1) NOT NULL DEFAULT 1,
  `hostel_id` tinyint(1) NOT NULL DEFAULT 1,
  `bank_account_no` tinyint(1) NOT NULL DEFAULT 1,
  `bank_name` tinyint(1) NOT NULL DEFAULT 1,
  `ifsc_code` tinyint(1) NOT NULL DEFAULT 1,
  `national_identification_no` tinyint(1) NOT NULL DEFAULT 1,
  `local_identification_no` tinyint(1) NOT NULL DEFAULT 1,
  `rte` tinyint(1) NOT NULL DEFAULT 1,
  `previous_school_details` tinyint(1) NOT NULL DEFAULT 1,
  `student_note` tinyint(1) NOT NULL DEFAULT 1,
  `upload_documents` tinyint(1) NOT NULL DEFAULT 1,
  `staff_designation` tinyint(1) NOT NULL DEFAULT 1,
  `staff_department` tinyint(1) NOT NULL DEFAULT 1,
  `staff_last_name` tinyint(1) NOT NULL DEFAULT 1,
  `staff_father_name` tinyint(1) NOT NULL DEFAULT 1,
  `staff_mother_name` tinyint(1) NOT NULL DEFAULT 1,
  `staff_date_of_joining` tinyint(1) NOT NULL DEFAULT 1,
  `staff_phone` tinyint(1) NOT NULL DEFAULT 1,
  `staff_emergency_contact` tinyint(1) NOT NULL DEFAULT 1,
  `staff_marital_status` tinyint(1) NOT NULL DEFAULT 1,
  `staff_photo` tinyint(1) NOT NULL DEFAULT 1,
  `staff_current_address` tinyint(1) NOT NULL DEFAULT 1,
  `staff_permanent_address` tinyint(1) NOT NULL DEFAULT 1,
  `staff_qualification` tinyint(1) NOT NULL DEFAULT 1,
  `staff_work_experience` tinyint(1) NOT NULL DEFAULT 1,
  `staff_note` tinyint(1) NOT NULL DEFAULT 1,
  `staff_epf_no` tinyint(1) NOT NULL DEFAULT 1,
  `staff_basic_salary` tinyint(1) NOT NULL DEFAULT 1,
  `staff_contract_type` tinyint(1) NOT NULL DEFAULT 1,
  `staff_work_shift` tinyint(1) NOT NULL DEFAULT 1,
  `staff_work_location` tinyint(1) NOT NULL DEFAULT 1,
  `staff_leaves` tinyint(1) NOT NULL DEFAULT 1,
  `staff_account_details` tinyint(1) NOT NULL DEFAULT 1,
  `staff_social_media` tinyint(1) NOT NULL DEFAULT 1,
  `staff_upload_documents` tinyint(1) NOT NULL DEFAULT 1,
  `my_question` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `sch_settings` (`id`, `name`, `email`, `session_id`, `lang_id`, `currency`, `currency_symbol`, `date_format`, `time_format`, `timezone`, `theme`) VALUES
(1, 'Smart School', 'admin@smartschool.com', 1, 1, 'USD', '$', 'd-m-Y', '12', 'UTC', 'blue');

CREATE TABLE IF NOT EXISTS `student_session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `is_alumni` tinyint(1) NOT NULL DEFAULT 0,
  `transport_fees` decimal(10,2) DEFAULT NULL,
  `fees_discount` decimal(10,2) DEFAULT NULL,
  `default_login` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `class_teacher` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  KEY `staff_id` (`staff_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `teacher_subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_section_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `class_section_id` (`class_section_id`),
  KEY `teacher_id` (`teacher_id`),
  KEY `subject_id` (`subject_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `subject_group_subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject_group_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `subject_group_id` (`subject_group_id`),
  KEY `subject_id` (`subject_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `subject_group_class_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_section_id` int(11) NOT NULL,
  `subject_group_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `class_section_id` (`class_section_id`),
  KEY `subject_group_id` (`subject_group_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `subject_timetable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `subject_group_id` int(11) DEFAULT NULL,
  `subject_group_subject_id` int(11) DEFAULT NULL,
  `day` varchar(20) DEFAULT NULL,
  `time_from` time DEFAULT NULL,
  `time_to` time DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `room_no` varchar(50) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  KEY `staff_id` (`staff_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `userlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(150) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `ipaddress` varchar(50) DEFAULT NULL,
  `login_datetime` datetime DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `class_section_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_attendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `staff_attendance_type_id` int(11) DEFAULT NULL,
  `remark` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `staff_attendance_type_id` (`staff_attendance_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_leave_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `leave_days` int(11) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `date` date DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `reason` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `leave_type_id` (`leave_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_leave_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `leave_type_id` int(11) NOT NULL,
  `alloted_leave` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `leave_type_id` (`leave_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_payslip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `net_salary` decimal(10,2) DEFAULT NULL,
  `total_allowance` decimal(10,2) DEFAULT NULL,
  `total_deduction` decimal(10,2) DEFAULT NULL,
  `basic` decimal(10,2) DEFAULT NULL,
  `tax` decimal(10,2) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `payslip_allowance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payslip_id` int(11) NOT NULL,
  `allowance_type` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `cal_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payslip_id` (`payslip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_payroll` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `cal_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_rating` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `rate` decimal(3,1) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_attendences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `attendence_type_id` int(11) DEFAULT NULL,
  `remark` text DEFAULT NULL,
  `biometric_attendence` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `attendence_type_id` (`attendence_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_subject_attendances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) NOT NULL,
  `subject_timetable_id` int(11) NOT NULL,
  `attendence_type_id` int(11) DEFAULT NULL,
  `date` date NOT NULL,
  `remark` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `subject_timetable_id` (`subject_timetable_id`),
  KEY `attendence_type_id` (`attendence_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_applyleave` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `reason` text DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_doc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_sibling` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `sibling_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_timeline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `timeline_date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `staff_timeline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `timeline_date` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `alumni_students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `alumni_session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `alumni_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `date` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `feemasters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) DEFAULT NULL,
  `feetype_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `session_id` int(11) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `feetype_id` (`feetype_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_fees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) NOT NULL,
  `feemaster_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `amount_discount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `amount_fine` decimal(10,2) NOT NULL DEFAULT 0.00,
  `payment_mode` varchar(50) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `feemaster_id` (`feemaster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `fee_groups_feetype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fee_groups_id` int(11) NOT NULL,
  `feetype_id` int(11) NOT NULL,
  `fee_session_group_id` int(11) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `fine_percentage` decimal(5,2) DEFAULT NULL,
  `fine_amount` decimal(10,2) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fee_groups_id` (`fee_groups_id`),
  KEY `feetype_id` (`feetype_id`),
  KEY `fee_session_group_id` (`fee_session_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `fee_class_section_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fee_session_group_id` int(11) NOT NULL,
  `class_section_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fee_session_group_id` (`fee_session_group_id`),
  KEY `class_section_id` (`class_section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_fees_master` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) NOT NULL,
  `fee_session_group_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `fee_session_group_id` (`fee_session_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_fees_deposite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_fees_master_id` int(11) NOT NULL,
  `fee_groups_feetype_id` int(11) DEFAULT NULL,
  `amount_detail` text DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `payment_mode` varchar(50) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_fees_master_id` (`student_fees_master_id`),
  KEY `fee_groups_feetype_id` (`fee_groups_feetype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_fees_discounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) NOT NULL,
  `fees_discount_id` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `payment_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `fees_discount_id` (`fees_discount_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_transport_fees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `amount_fine` decimal(10,2) DEFAULT NULL,
  `amount_discount` decimal(10,2) DEFAULT NULL,
  `payment_mode` varchar(50) DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `student_subject_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) NOT NULL,
  `subject_group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `subject_group_id` (`subject_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `exam_schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exam_id` int(11) NOT NULL,
  `teacher_subject_id` int(11) DEFAULT NULL,
  `date_of_exam` date DEFAULT NULL,
  `start_to` time DEFAULT NULL,
  `end_from` time DEFAULT NULL,
  `room_no` varchar(50) DEFAULT NULL,
  `full_marks` decimal(10,2) DEFAULT NULL,
  `passing_marks` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exam_id` (`exam_id`),
  KEY `teacher_subject_id` (`teacher_subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `exam_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exam_schedule_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `get_marks` decimal(10,2) DEFAULT NULL,
  `attendence` tinyint(1) DEFAULT NULL,
  `note` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exam_schedule_id` (`exam_schedule_id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `exam_group_class_batch_exams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam` varchar(250) DEFAULT NULL,
  `session_id` int NOT NULL,
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `exam_group_id` int DEFAULT NULL,
  `is_publish` int DEFAULT 0,
  `is_active` int DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exam_group_id` (`exam_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `exam_group_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `is_active` int DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exam_group_id` (`exam_group_id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `exam_group_class_batch_exam_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_class_batch_exam_id` int NOT NULL,
  `student_id` int NOT NULL,
  `student_session_id` int NOT NULL,
  `roll_no` int NOT NULL DEFAULT 0,
  `is_active` int DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exam_group_class_batch_exam_id` (`exam_group_class_batch_exam_id`),
  KEY `student_id` (`student_id`),
  KEY `student_session_id` (`student_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `exam_group_class_batch_exam_subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exam_group_class_batch_exam_id` int(11) NOT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `max_marks` decimal(10,2) DEFAULT NULL,
  `min_marks` decimal(10,2) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `exam_group_class_batch_exam_id` (`exam_group_class_batch_exam_id`),
  KEY `subject_id` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `exam_group_exam_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exam_group_id` int(11) NOT NULL,
  `student_session_id` int(11) NOT NULL,
  `marks_obtained` decimal(10,2) DEFAULT NULL,
  `is_pass` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exam_group_id` (`exam_group_id`),
  KEY `student_session_id` (`student_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `onlineexam_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `onlineexam_id` int(11) NOT NULL,
  `marks` decimal(10,2) DEFAULT NULL,
  `neg_marks` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  KEY `onlineexam_id` (`onlineexam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `onlineexam_students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) NOT NULL,
  `onlineexam_id` int(11) NOT NULL,
  `rank` int(11) DEFAULT NULL,
  `is_attempted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `onlineexam_id` (`onlineexam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `onlineexam_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `onlineexam_student_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `onlineexam_student_id` (`onlineexam_student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `onlineexam_student_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `onlineexam_question_id` int(11) NOT NULL,
  `onlineexam_student_id` int(11) NOT NULL,
  `marks` decimal(10,2) DEFAULT NULL,
  `select_option` varchar(10) DEFAULT NULL,
  `remark` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `onlineexam_question_id` (`onlineexam_question_id`),
  KEY `onlineexam_student_id` (`onlineexam_student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `online_admissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admission_no` varchar(50) DEFAULT NULL,
  `roll_no` varchar(50) DEFAULT NULL,
  `admission_date` date DEFAULT NULL,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `mobileno` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `religion` varchar(50) DEFAULT NULL,
  `cast` varchar(50) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `current_address` text DEFAULT NULL,
  `previous_school` varchar(255) DEFAULT NULL,
  `guardian_is` varchar(30) DEFAULT NULL,
  `permanent_address` text DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `adhar_no` varchar(30) DEFAULT NULL,
  `samagra_id` varchar(30) DEFAULT NULL,
  `bank_account_no` varchar(50) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `ifsc_code` varchar(30) DEFAULT NULL,
  `guardian_name` varchar(150) DEFAULT NULL,
  `father_pic` varchar(255) DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `measurement_date` date DEFAULT NULL,
  `mother_pic` varchar(255) DEFAULT NULL,
  `guardian_pic` varchar(255) DEFAULT NULL,
  `guardian_relation` varchar(50) DEFAULT NULL,
  `guardian_phone` varchar(20) DEFAULT NULL,
  `guardian_address` text DEFAULT NULL,
  `is_enroll` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `document` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `father_name` varchar(150) DEFAULT NULL,
  `father_phone` varchar(20) DEFAULT NULL,
  `blood_group` varchar(10) DEFAULT NULL,
  `school_house_id` int(11) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `mother_name` varchar(150) DEFAULT NULL,
  `mother_phone` varchar(20) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `guardian_occupation` varchar(100) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `rte` varchar(10) DEFAULT NULL,
  `guardian_email` varchar(150) DEFAULT NULL,
  `vehroute_id` int(11) DEFAULT NULL,
  `hostel_room_id` int(11) DEFAULT NULL,
  `class_section_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `homework` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `subject_group_subject_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `submission_date` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  `evaluation_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  KEY `subject_id` (`subject_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `homework_evaluation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `homework_id` int(11) NOT NULL,
  `student_session_id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `marks_obtained` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `homework_id` (`homework_id`),
  KEY `student_session_id` (`student_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `submit_assignment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `homework_id` int(11) NOT NULL,
  `student_session_id` int(11) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `document` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `homework_id` (`homework_id`),
  KEY `student_session_id` (`student_session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `lesson` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject_group_subject_id` int(11) DEFAULT NULL,
  `subject_group_class_sections_id` int(11) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `topic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lesson_id` int(11) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `complete_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lesson_id` (`lesson_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `subject_syllabus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject_group_subject_id` int(11) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `time_from` time DEFAULT NULL,
  `time_to` time DEFAULT NULL,
  `date` date DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_for` int(11) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  `topic_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subject_id` (`subject_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `send_notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `publish_date` date DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `message` text DEFAULT NULL,
  `visible_staff` tinyint(1) NOT NULL DEFAULT 0,
  `visible_student` tinyint(1) NOT NULL DEFAULT 0,
  `visible_parent` tinyint(1) NOT NULL DEFAULT 0,
  `created_id` int(11) DEFAULT NULL,
  `publish_exam_notification` tinyint(1) NOT NULL DEFAULT 0,
  `publish_result_notification` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `notification_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `send_notification_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `send_notification_id` (`send_notification_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `read_notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notification_id` (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` text DEFAULT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `chat_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `socket_id` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'offline',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `chat_connections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user1_id` int(11) NOT NULL,
  `user2_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `chat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `connection_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `message` text DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `connection_id` (`connection_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author` varchar(150) DEFAULT NULL,
  `isbn` varchar(50) DEFAULT NULL,
  `publisher` varchar(150) DEFAULT NULL,
  `rack_no` varchar(50) DEFAULT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `price` decimal(10,2) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subject_id` (`subject_id`),
  KEY `class_id` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `libarary_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `library_card_no` varchar(50) DEFAULT NULL,
  `member_type` varchar(30) NOT NULL,
  `member_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `book_issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `issue_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `return_status` tinyint(1) NOT NULL DEFAULT 0,
  `note` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `book_id` (`book_id`),
  KEY `member_id` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `expense_head_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `expense_head_id` (`expense_head_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `income` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `income_head_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `income_head_id` (`income_head_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `complaint` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `complaint_type_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `date` date DEFAULT NULL,
  `action_taken` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `complaint_type_id` (`complaint_type_id`),
  KEY `source_id` (`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `enquiry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `enquiry_type_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  `reference` varchar(150) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `last_follow_up` date DEFAULT NULL,
  `next_follow_up` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `enquiry_type_id` (`enquiry_type_id`),
  KEY `source_id` (`source_id`),
  KEY `class_id` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `follow_up` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `enquiry_id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  `next_follow_up` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `enquiry_id` (`enquiry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `item_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `item_issue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `issue_to` int(11) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `is_returned` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `issue_to` (`issue_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `visitors_book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `purpose_id` int(11) DEFAULT NULL,
  `meeting_with` varchar(150) DEFAULT NULL,
  `id_card_no` varchar(50) DEFAULT NULL,
  `number_of_person` int(11) DEFAULT 1,
  `note` text DEFAULT NULL,
  `in_date` date DEFAULT NULL,
  `in_time` time DEFAULT NULL,
  `out_time` time DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `purpose_id` (`purpose_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `front_cms_menu_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `menu_id` int(11) NOT NULL,
  `page_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `menu_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `menu_id` (`menu_id`),
  KEY `page_id` (`page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `front_cms_page_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL,
  `content` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `page_id` (`page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `front_cms_program_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `program_id` int(11) NOT NULL,
  `image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `program_id` (`program_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `content_for` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) NOT NULL,
  `class_section_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `content_id` (`content_id`),
  KEY `class_section_id` (`class_section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `custom_field_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `custom_field_id` int(11) NOT NULL,
  `belong_table_id` int(11) NOT NULL,
  `field_value` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `custom_field_id` (`custom_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `timetables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `captcha` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `captcha_time` int(11) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `word` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

SET FOREIGN_KEY_CHECKS = 1;
