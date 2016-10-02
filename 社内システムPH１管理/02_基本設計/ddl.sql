CREATE OR REPLACE TABLE users ( /* ユーザー */
  user_id varchar(10) NOT NULL COMMENT 'ユーザーID',
  employee_id varchar(10) NOT NULL UNIQUE KEY COMMENT '社員ID',
  name varchar(20) NOT NULL UNIQUE KEY COMMENT 'ユーザー名',
  pwd varchar(256) NOT NULL COMMENT 'パスワード',
  auth_id varchar(10) NOT NULL UNIQUE KEY COMMENT '権限ID',
  last_login_at datetime NOT NULL COMMENT '最後登録時間',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`user_id`)
);

CREATE OR REPLACE TABLE authority ( /* 権限 */
  authority_id varchar(10) NOT NULL COMMENT '権限ID',
  name varchar(20) NOT NULL COMMENT '名称',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`authority_id`)
);

CREATE OR REPLACE TABLE employees ( /* 社員 */
  employee_id varchar(10) NOT NULL COMMENT '社員ID',
  name_in_law varchar(20) NOT NULL COMMENT '常用名',
  name_cn varchar(20) NOT NULL COMMENT '中国語名',
  name_en varchar(20) NOT NULL COMMENT '英語名',
  name_jp varchar(20) NOT NULL COMMENT '日本語名',
  name_kana varchar(20) NOT NULL COMMENT 'カナ名',
  resident_spot_id varchar(10) NOT NULL COMMENT '住所ID',
  mobile varchar(11) NOT NULL COMMENT '携帯番号',
  mobile_cn varchar(11) COMMENT '携帯番号（中国）',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`employee_id`)
);

CREATE OR REPLACE TABLE departments ( /* 部 */
  department_id varchar(10) NOT NULL COMMENT '部ID',
  name varchar(100) NOT NULL COMMENT '名称',
  chief_employee_id varchar(10) NOT NULL COMMENT '部長ID',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`department_id`)
);

CREATE OR REPLACE TABLE sections ( /* 課 */
  section_id varchar(10) NOT NULL COMMENT '課ID',
  department_id varchar(10) NOT NULL COMMENT '部ID',
  name varchar(100) NOT NULL COMMENT '名称',
  chief_employee_id varchar(10) NOT NULL COMMENT '課長ID',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`section_id`)
);

CREATE OR REPLACE TABLE dispatches ( /* 派遣 */
  dispatch_id varchar(10) NOT NULL COMMENT '派遣ID',
  employee_id varchar(10) NOT NULL UNIQUE KEY COMMENT '社員ID',
  customer_id varchar(10) NOT NULL COMMENT '顧客ID',
  site_id tinyint(10) NOT NULL COMMENT '現場ID',
  start_date date NOT NULL UNIQUE KEY COMMENT '派遣開始日',
  end_date date NOT NULL UNIQUE KEY COMMENT '派遣終了日',
  fixed_monthly_hours int(3) COMMENT '固定勤務時間',
  report_day int(2) NOT NULL COMMENT '勤務提出日',
  work_start_time char(4) NOT NULL COMMENT '出勤時間',
  work_end_time char(4) NOT NULL COMMENT '退勤時間',
  day_break_start_time char(4) NOT NULL COMMENT '昼休憩開始時間',
  day_break_minutes int(3) NOT NULL COMMENT '昼休憩分数',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`dispatch_id`)
);

CREATE OR REPLACE TABLE attendances ( /* 勤務 */
  dispatch_id varchar(10) NOT NULL COMMENT '派遣ID',
  date date NOT NULL COMMENT '日付',
  employee_id varchar(10) NOT NULL COMMENT '社員ID',
  start_time datetime NOT NULL COMMENT '出勤時間',
  report_start_time datetime NOT NULL COMMENT 'レポート出勤時間',
  start_longitude decimal NOT NULL COMMENT '出勤経度',
  start_latitude decimal NOT NULL COMMENT '出勤緯度',
  end_time datetime NOT NULL COMMENT '退勤時間',
  report_end_time datetime NOT NULL COMMENT 'レポート退勤時間',
  end_longitude decimal NOT NULL COMMENT '退勤経度',
  end_latitude decimal NOT NULL COMMENT '退勤緯度',
  exclusive_minutes int NOT NULL COMMENT '控除分数',
  total_minutes int NOT NULL COMMENT '合計分数',
  vacation_id varchar(10) COMMENT '休憩ID',
  modification_log varchar(4000) COMMENT '修正履歴',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`dispatch_id`, `date`)
);

CREATE OR REPLACE TABLE attendance_supervision ( /* 勤務承認 */
  dispatch_id varchar(10) NOT NULL COMMENT '派遣ID',
  month date NOT NULL COMMENT '月',
  status_id varchar(10) NOT NULL COMMENT 'ステータスID',
  remark varchar(200) COMMENT '備考',
  report_path varchar(200) COMMENT '勤務表パス',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`dispatch_id`, `month`)
);

CREATE OR REPLACE TABLE customers ( /* 顧客 */
  id varchar(10) NOT NULL COMMENT 'ID',
  spot_id varchar(10) NOT NULL COMMENT 'スポットID',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`id`)
);

CREATE OR REPLACE TABLE sites ( /* 現場 */
  id varchar(10) NOT NULL COMMENT 'ID',
  spot_id varchar(10) NOT NULL COMMENT 'スポットID',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`id`)
);

CREATE OR REPLACE TABLE spots ( /* スポット */
  spot_id varchar(10) NOT NULL COMMENT 'スポットID',
  type_id varchar(10) NOT NULL COMMENT '種類ID',
  name varchar(100) NOT NULL COMMENT '名称',
  name_kana varchar(200) NOT NULL COMMENT 'カナ名称',
  district_id varchar(10) NOT NULL COMMENT '区ID',
  addr_detail varchar(200) NOT NULL COMMENT '住所詳細',
  post_code varchar(7) NOT NULL COMMENT '郵便番号',
  tel varchar(10) COMMENT '電話',
  start_longitude decimal NOT NULL COMMENT '開始経度',
  start_latitude decimal NOT NULL COMMENT '開始緯度',
  end_longitude decimal NOT NULL COMMENT '終了経度',
  end_latitude decimal NOT NULL COMMENT '終了緯度',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`spot_id`)
);

CREATE OR REPLACE TABLE prefectures ( /* 県 */
  prefecture_id varchar(10) NOT NULL COMMENT '県ID',
  name varchar(100) NOT NULL COMMENT '名称',
  name_kana varchar(200) NOT NULL COMMENT 'カナ名称',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`prefecture_id`)
);

CREATE OR REPLACE TABLE districts ( /* 区 */
  district_id varchar(10) NOT NULL COMMENT '区ID',
  prefecture_id varchar(10) NOT NULL COMMENT '県ID',
  name varchar(100) NOT NULL COMMENT '名称',
  name_kana varchar(200) NOT NULL COMMENT 'カナ名称',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`district_id`)
);

CREATE OR REPLACE TABLE vacations ( /* 休憩 */
  vacation_id varchar(10) NOT NULL COMMENT '休憩ID',
  name varchar(20) NOT NULL COMMENT '名称',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`vacation_id`)
);

CREATE OR REPLACE TABLE modifications ( /* 修正 */
  modification_id varchar(10) NOT NULL COMMENT '修正ID',
  name varchar(20) NOT NULL COMMENT '名称',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`modification_id`)
);

CREATE OR REPLACE TABLE status ( /* ステータス */
  status_id varchar(10) NOT NULL COMMENT 'ステータスID',
  name varchar(20) NOT NULL COMMENT '名称',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`status_id`)
);

CREATE OR REPLACE TABLE codes ( /* コード */
  code_id varchar(10) NOT NULL COMMENT 'コードID',
  type varchar(20) NOT NULL COMMENT '種類',
  code varchar(20) NOT NULL COMMENT '値',
  name varchar(100) NOT NULL COMMENT '名',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`code_id`)
);

CREATE OR REPLACE TABLE holidays ( /* 祝日 */
  date date NOT NULL COMMENT '日付',
  no int(2) NOT NULL COMMENT '枝番',
  type_id varchar(10) NOT NULL COMMENT '種類ID',
  name varchar(20) NOT NULL COMMENT '名称',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`date`, `no`)
);

CREATE OR REPLACE TABLE employments ( /* 雇用 */
  employment_id varchar(10) NOT NULL COMMENT '雇用ID',
  employee_id varchar(10) NOT NULL COMMENT '社員ID',
  section_id varchar(10) COMMENT '課ID',
  start_date date NOT NULL COMMENT '開始日',
  end_date date NOT NULL COMMENT '終了日',
  type_id varchar(10) NOT NULL COMMENT '種類ID',
  monthly_salary decimal NOT NULL COMMENT '月給',
  monthly_fee decimal(10) COMMENT '月額',
  bonus_id varchar(10) COMMENT '賞ID',
  penalty_id varchar(10) COMMENT '罰ID',
  ensurance_id varchar(10) NOT NULL COMMENT '保険ID',
  exclusive_id varchar(10) COMMENT '控除ID',
  payroll_id varchar(10) NOT NULL COMMENT '支払ID',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`employment_id`)
);

CREATE OR REPLACE TABLE bonus_penalty ( /* 賞罰 */
  bonus_penalty_id varchar(10) NOT NULL COMMENT '賞罰ID',
  type tinyint(1) NOT NULL COMMENT '種類',
  name varchar(100) NOT NULL COMMENT '名称',
  start_date date NOT NULL COMMENT '開始日',
  end_date date NOT NULL COMMENT '終了日',
  amount decimal NOT NULL COMMENT '額',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`bonus_penalty_id`)
);

CREATE OR REPLACE TABLE exclusives ( /* 控除 */
  exclusive_id varchar(10) NOT NULL COMMENT '控除ID',
  name varchar(100) NOT NULL COMMENT '名称',
  start_date date NOT NULL COMMENT '開始日',
  end_date date NOT NULL COMMENT '終了日',
  amount decimal NOT NULL COMMENT '額',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`exclusive_id`)
);

CREATE OR REPLACE TABLE ensurance ( /* 保険 */
  ensurance_id varchar(10) NOT NULL COMMENT '保険ID',
  name varchar(100) NOT NULL COMMENT '名称',
  start_date date NOT NULL COMMENT '開始日',
  end_date date NOT NULL COMMENT '終了日',
  amount decimal NOT NULL COMMENT '額',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`ensurance_id`)
);

CREATE OR REPLACE TABLE payroll ( /* 支払 */
  payroll_id varchar(10) NOT NULL COMMENT '支払ID',
  branch_id varchar(10) NOT NULL COMMENT '支店ID',
  card_no varchar(30) NOT NULL COMMENT 'カード番号',
  card_sign varchar(20) NOT NULL COMMENT 'カード名義',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`payroll_id`)
);

CREATE OR REPLACE TABLE branches ( /* 支店 */
  branch_id varchar(10) NOT NULL COMMENT '支店ID',
  bank_id varchar(10) NOT NULL COMMENT '銀行ID',
  name varchar(100) NOT NULL COMMENT '名称',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`branch_id`)
);

CREATE OR REPLACE TABLE banks ( /* 銀行 */
  bank_id varchar(10) NOT NULL COMMENT '銀行ID',
  name varchar(100) NOT NULL COMMENT '名称',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`bank_id`)
);

CREATE OR REPLACE TABLE notifications ( /* 通知 */
  notification_id varchar(10) NOT NULL COMMENT '通知ID',
  title varchar(50) NOT NULL COMMENT 'タイトル',
  content varchar(1000) NOT NULL COMMENT '中身',
  start_date date COMMENT '開始日',
  end_date date COMMENT '終了日',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`notification_id`)
);

CREATE OR REPLACE TABLE votes ( /* 投票 */
  vote_id varchar(10) NOT NULL COMMENT '投票ID',
  title varchar(50) NOT NULL COMMENT 'タイトル',
  content varchar(1000) NOT NULL COMMENT '中身',
  options varchar(1000) NOT NULL COMMENT '選択肢',
  start_date date COMMENT '開始日',
  end_date date COMMENT '終了日',
  vote_start_date date COMMENT '投票開始日',
  vote_end_date date COMMENT '投票終了日',
  valid tinyint(1) NOT NULL DEFAULT 1 COMMENT '有効',
  create_by varchar(10) NOT NULL COMMENT '登録者',
  create_at datetime NOT NULL DEFAULT now() COMMENT '登録時間',
  update_by varchar(10) NOT NULL COMMENT '更新者',
  update_at datetime NOT NULL DEFAULT now() COMMENT '更新時間',
  update_cnt int(5) NOT NULL DEFAULT 1 COMMENT '更新回数',
  PRIMARY KEY(`vote_id`)
);

