-- --------------------------------------------------------
-- 主机:                           127.0.0.1
-- 服务器版本:                        10.1.18-MariaDB - mariadb.org binary distribution
-- 服务器操作系统:                      Win64
-- HeidiSQL 版本:                  9.3.0.5121
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 正在导出表  maiasoft.attendances 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `attendances` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendances` ENABLE KEYS */;

-- 正在导出表  maiasoft.attendance_supervision 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `attendance_supervision` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_supervision` ENABLE KEYS */;

-- 正在导出表  maiasoft.authority 的数据：~3 rows (大约)
/*!40000 ALTER TABLE `authority` DISABLE KEYS */;
INSERT INTO `authority` (`enterprise_id`, `authority_id`, `name`, `valid`, `create_by`, `create_at`, `update_by`, `update_at`, `update_cnt`) VALUES
	('ENT0000001', 'AUT0000001', 'ユーザー', 1, 'go', '2016-11-26 11:11:29', 'go', '2016-11-26 11:11:29', 1),
	('ENT0000001', 'AUT0000002', '管理員', 1, 'go', '2016-11-26 11:12:21', 'go', '2016-11-26 11:12:21', 1),
	('ENT0000001', 'AUT0000003', 'システム管理員', 1, 'go', '2016-11-26 11:12:55', 'go', '2016-11-26 11:12:55', 1);
/*!40000 ALTER TABLE `authority` ENABLE KEYS */;

-- 正在导出表  maiasoft.banks 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `banks` DISABLE KEYS */;
/*!40000 ALTER TABLE `banks` ENABLE KEYS */;

-- 正在导出表  maiasoft.bonus_penalty 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `bonus_penalty` DISABLE KEYS */;
/*!40000 ALTER TABLE `bonus_penalty` ENABLE KEYS */;

-- 正在导出表  maiasoft.branches 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;

-- 正在导出表  maiasoft.codes 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `codes` ENABLE KEYS */;

-- 正在导出表  maiasoft.customers 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;

-- 正在导出表  maiasoft.departments 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;

-- 正在导出表  maiasoft.dispatches 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `dispatches` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispatches` ENABLE KEYS */;

-- 正在导出表  maiasoft.districts 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `districts` DISABLE KEYS */;
/*!40000 ALTER TABLE `districts` ENABLE KEYS */;

-- 正在导出表  maiasoft.duties 的数据：~7 rows (大约)
/*!40000 ALTER TABLE `duties` DISABLE KEYS */;
INSERT INTO `duties` (`enterprise_id`, `duty_id`, `name`, `valid`, `create_by`, `create_at`, `update_by`, `update_at`, `update_cnt`) VALUES
	('ENT0000001', 'DUT0000101', '社長', 1, 'go', '2016-11-27 01:55:03', 'go', '2016-11-27 01:55:03', 1),
	('ENT0000001', 'DUT0000102', '本部長', 1, 'go', '2016-11-27 01:55:03', 'go', '2016-11-27 01:55:03', 1),
	('ENT0000001', 'DUT0000103', '部長', 1, 'go', '2016-11-27 01:55:03', 'go', '2016-11-27 01:55:03', 1),
	('ENT0000001', 'DUT0000104', '課長', 1, 'go', '2016-11-27 01:55:03', 'go', '2016-11-27 01:55:03', 1),
	('ENT0000001', 'DUT0000201', '人事', 1, 'go', '2016-11-27 01:55:03', 'go', '2016-11-27 01:55:03', 1),
	('ENT0000001', 'DUT0000202', '営業', 1, 'go', '2016-11-27 01:55:03', 'go', '2016-11-27 01:55:03', 1),
	('ENT0000001', 'DUT0000203', '事務', 1, 'go', '2016-11-27 01:55:03', 'go', '2016-11-27 01:55:03', 1);
/*!40000 ALTER TABLE `duties` ENABLE KEYS */;

-- 正在导出表  maiasoft.employees 的数据：~5 rows (大约)
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` (`enterprise_id`, `employee_id`, `name_in_law`, `name_cn`, `name_en`, `name_jp`, `name_kana`, `resident_spot_id`, `mobile`, `mobile_cn`, `valid`, `create_by`, `create_at`, `update_by`, `update_at`, `update_cnt`) VALUES
	('ENT0000001', 'EMP0000001', '王　山鷹', '王　山鹰', 'WANG  SHANGYING', '王　山鷹', 'オウ　サンヨウ', 'SPT0000301', '08012345678', NULL, 1, 'go', '2016-11-27 10:31:41', 'go', '2016-11-27 10:31:41', 1),
	('ENT0000001', 'EMP0000002', 'ウラハン', '乌日罕', 'WURIHAN  XXX', 'ウラハン', 'ウラハン', 'SPT0000302', '08012345678', NULL, 1, 'go', '2016-11-27 10:31:41', 'go', '2016-11-27 10:31:41', 1),
	('ENT0000001', 'EMP0000003', '閻　妍', '阎　妍', 'YAN YAN', '閻　妍', 'エン　エン', 'SPT0000303', '08012345678', NULL, 1, 'go', '2016-11-27 10:31:41', 'go', '2016-11-27 10:31:41', 1),
	('ENT0000001', 'EMP0000004', '呉　翰', '吴　翰', 'WU HAN', '呉　翰', 'ゴ　カン', 'SPT0000304', '08012345678', NULL, 1, 'go', '2016-11-27 10:31:41', 'go', '2016-11-27 10:31:41', 1),
	('ENT0000001', 'EMP0000005', '韓　氷', '韩　冰', 'HAN BING', '韓　氷', 'カン　ヒョウ', 'SPT0000305', '08012345678', NULL, 1, 'go', '2016-11-27 10:31:41', 'go', '2016-11-27 10:31:41', 1);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;

-- 正在导出表  maiasoft.employments 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `employments` DISABLE KEYS */;
/*!40000 ALTER TABLE `employments` ENABLE KEYS */;

-- 正在导出表  maiasoft.ensurance 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `ensurance` DISABLE KEYS */;
/*!40000 ALTER TABLE `ensurance` ENABLE KEYS */;

-- 正在导出表  maiasoft.exclusives 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `exclusives` DISABLE KEYS */;
/*!40000 ALTER TABLE `exclusives` ENABLE KEYS */;

-- 正在导出表  maiasoft.holidays 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `holidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `holidays` ENABLE KEYS */;

-- 正在导出表  maiasoft.modifications 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `modifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `modifications` ENABLE KEYS */;

-- 正在导出表  maiasoft.notifications 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;

-- 正在导出表  maiasoft.payroll 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `payroll` DISABLE KEYS */;
/*!40000 ALTER TABLE `payroll` ENABLE KEYS */;

-- 正在导出表  maiasoft.prefectures 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `prefectures` DISABLE KEYS */;
/*!40000 ALTER TABLE `prefectures` ENABLE KEYS */;

-- 正在导出表  maiasoft.sections 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;

-- 正在导出表  maiasoft.sites 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;

-- 正在导出表  maiasoft.spots 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `spots` DISABLE KEYS */;
/*!40000 ALTER TABLE `spots` ENABLE KEYS */;

-- 正在导出表  maiasoft.status 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
/*!40000 ALTER TABLE `status` ENABLE KEYS */;

-- 正在导出表  maiasoft.users 的数据：~5 rows (大约)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`enterprise_id`, `employee_id`, `name`, `pwd`, `auth_id`, `last_login_at`, `valid`, `create_by`, `create_at`, `update_by`, `update_at`, `update_cnt`) VALUES
	('ENT0000001', 'EMP0000001', '王　山鷹', 'e5f6d6aab0ee3f65995f17688c5687eca1c73e5b3a0a651b31f45a15be5116b7', 'AUT0000003', '2016-11-27 10:48:08', 1, 'go', '2016-11-27 10:48:12', 'go', '2016-11-27 10:48:12', 1),
	('ENT0000001', 'EMP0000002', 'ウラハン', 'e5f6d6aab0ee3f65995f17688c5687eca1c73e5b3a0a651b31f45a15be5116b7', 'AUT0000003', '2016-11-27 10:48:08', 1, 'go', '2016-11-27 10:48:12', 'go', '2016-11-27 10:48:12', 1),
	('ENT0000001', 'EMP0000003', '閻　妍', 'e5f6d6aab0ee3f65995f17688c5687eca1c73e5b3a0a651b31f45a15be5116b7', 'AUT0000003', '2016-11-27 10:55:14', 1, 'go', '2016-11-27 10:55:22', 'go', '2016-11-27 10:55:22', 1),
	('ENT0000001', 'EMP0000004', '呉　翰', 'e5f6d6aab0ee3f65995f17688c5687eca1c73e5b3a0a651b31f45a15be5116b7', 'AUT0000002', '2016-11-27 10:48:08', 1, 'go', '2016-11-27 10:48:12', 'go', '2016-11-27 10:48:12', 1),
	('ENT0000001', 'EMP0000005', '韓　氷', 'e5f6d6aab0ee3f65995f17688c5687eca1c73e5b3a0a651b31f45a15be5116b7', 'AUT0000001', '2016-11-27 10:48:08', 1, 'go', '2016-11-27 10:48:12', 'go', '2016-11-27 10:48:12', 1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- 正在导出表  maiasoft.vacations 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `vacations` DISABLE KEYS */;
/*!40000 ALTER TABLE `vacations` ENABLE KEYS */;

-- 正在导出表  maiasoft.votes 的数据：~0 rows (大约)
/*!40000 ALTER TABLE `votes` DISABLE KEYS */;
/*!40000 ALTER TABLE `votes` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
