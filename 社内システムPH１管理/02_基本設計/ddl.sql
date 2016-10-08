CREATE OR REPLACE TABLE users (
  user_id varchar(10) NOT NULL
  employee_id varchar(10) NOT NULL UNIQUE KEY
  name varchar(20) NOT NULL UNIQUE KEY
  pwd varchar(256) NOT NULL
  auth_id varchar(10) NOT NULL UNIQUE KEY
  last_login_at datetime NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`user_id`)
);

CREATE OR REPLACE TABLE authority (
  authority_id varchar(10) NOT NULL
  name varchar(20) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`authority_id`)
);

CREATE OR REPLACE TABLE employees (
  employee_id varchar(10) NOT NULL
  name_in_law varchar(20) NOT NULL
  name_cn varchar(20) NOT NULL
  name_en varchar(20) NOT NULL
  name_jp varchar(20) NOT NULL
  name_kana varchar(20) NOT NULL
  resident_spot_id varchar(10) NOT NULL
  mobile varchar(11) NOT NULL
  mobile_cn varchar(11)
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`employee_id`)
);

CREATE OR REPLACE TABLE departments (
  department_id varchar(10) NOT NULL
  name varchar(100) NOT NULL
  chief_employee_id varchar(10) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`department_id`)
);

CREATE OR REPLACE TABLE sections (
  section_id varchar(10) NOT NULL
  department_id varchar(10) NOT NULL
  name varchar(100) NOT NULL
  chief_employee_id varchar(10) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`section_id`)
);

CREATE OR REPLACE TABLE dispatches (
  dispatch_id varchar(10) NOT NULL
  employee_id varchar(10) NOT NULL UNIQUE KEY
  customer_id varchar(10) NOT NULL
  site_id tinyint(10) NOT NULL
  start_date date NOT NULL UNIQUE KEY
  end_date date NOT NULL UNIQUE KEY
  fixed_monthly_hours int(3)
  report_day int(2) NOT NULL
  work_start_time char(4) NOT NULL
  work_end_time char(4) NOT NULL
  day_break_start_time char(4) NOT NULL
  day_break_minutes int(3) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`dispatch_id`)
);

CREATE OR REPLACE TABLE attendances (
  dispatch_id varchar(10) NOT NULL
  date date NOT NULL
  employee_id varchar(10) NOT NULL
  start_time datetime NOT NULL
  report_start_time datetime NOT NULL
  start_longitude decimal NOT NULL
  start_latitude decimal NOT NULL
  end_time datetime NOT NULL
  report_end_time datetime NOT NULL
  end_longitude decimal NOT NULL
  end_latitude decimal NOT NULL
  exclusive_minutes int NOT NULL
  total_minutes int NOT NULL
  vacation_id varchar(10)
  modification_log varchar(4000)
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`dispatch_id`, `date`)
);

CREATE OR REPLACE TABLE attendance_supervision (
  dispatch_id varchar(10) NOT NULL
  month date NOT NULL
  status_id varchar(10) NOT NULL
  remark varchar(200)
  report_path varchar(200)
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`dispatch_id`, `month`)
);

CREATE OR REPLACE TABLE customers (
  id varchar(10) NOT NULL
  spot_id varchar(10) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`id`)
);

CREATE OR REPLACE TABLE sites (
  id varchar(10) NOT NULL
  spot_id varchar(10) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`id`)
);

CREATE OR REPLACE TABLE spots (
  spot_id varchar(10) NOT NULL
  type_id varchar(10) NOT NULL
  name varchar(100) NOT NULL
  name_kana varchar(200) NOT NULL
  district_id varchar(10) NOT NULL
  addr_detail varchar(200) NOT NULL
  post_code varchar(7) NOT NULL
  tel varchar(10)
  start_longitude decimal NOT NULL
  start_latitude decimal NOT NULL
  end_longitude decimal NOT NULL
  end_latitude decimal NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`spot_id`)
);

CREATE OR REPLACE TABLE prefectures (
  prefecture_id varchar(10) NOT NULL
  name varchar(100) NOT NULL
  name_kana varchar(200) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`prefecture_id`)
);

CREATE OR REPLACE TABLE districts (
  district_id varchar(10) NOT NULL
  prefecture_id varchar(10) NOT NULL
  name varchar(100) NOT NULL
  name_kana varchar(200) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`district_id`)
);

CREATE OR REPLACE TABLE vacations (
  vacation_id varchar(10) NOT NULL
  name varchar(20) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`vacation_id`)
);

CREATE OR REPLACE TABLE modifications (
  modification_id varchar(10) NOT NULL
  name varchar(20) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`modification_id`)
);

CREATE OR REPLACE TABLE status (
  status_id varchar(10) NOT NULL
  name varchar(20) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`status_id`)
);

CREATE OR REPLACE TABLE codes (
  code_id varchar(10) NOT NULL
  type varchar(20) NOT NULL
  code varchar(20) NOT NULL
  name varchar(100) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`code_id`)
);

CREATE OR REPLACE TABLE holidays (
  date date NOT NULL
  no int(2) NOT NULL
  type_id varchar(10) NOT NULL
  name varchar(20) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`date`, `no`)
);

CREATE OR REPLACE TABLE employments (
  employment_id varchar(10) NOT NULL
  employee_id varchar(10) NOT NULL
  section_id varchar(10)
  start_date date NOT NULL
  end_date date NOT NULL
  type_id varchar(10) NOT NULL
  monthly_salary decimal NOT NULL
  monthly_fee decimal(10)
  bonus_id varchar(10)
  penalty_id varchar(10)
  ensurance_id varchar(10) NOT NULL
  exclusive_id varchar(10)
  payroll_id varchar(10) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`employment_id`)
);

CREATE OR REPLACE TABLE bonus_penalty (
  bonus_penalty_id varchar(10) NOT NULL
  type tinyint(1) NOT NULL
  name varchar(100) NOT NULL
  start_date date NOT NULL
  end_date date NOT NULL
  amount decimal NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`bonus_penalty_id`)
);

CREATE OR REPLACE TABLE exclusives (
  exclusive_id varchar(10) NOT NULL
  name varchar(100) NOT NULL
  start_date date NOT NULL
  end_date date NOT NULL
  amount decimal NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`exclusive_id`)
);

CREATE OR REPLACE TABLE ensurance (
  ensurance_id varchar(10) NOT NULL
  name varchar(100) NOT NULL
  start_date date NOT NULL
  end_date date NOT NULL
  amount decimal NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`ensurance_id`)
);

CREATE OR REPLACE TABLE payroll (
  payroll_id varchar(10) NOT NULL
  branch_id varchar(10) NOT NULL
  card_no varchar(30) NOT NULL
  card_sign varchar(20) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`payroll_id`)
);

CREATE OR REPLACE TABLE branches (
  branch_id varchar(10) NOT NULL
  bank_id varchar(10) NOT NULL
  name varchar(100) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`branch_id`)
);

CREATE OR REPLACE TABLE banks (
  bank_id varchar(10) NOT NULL
  name varchar(100) NOT NULL
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`bank_id`)
);

CREATE OR REPLACE TABLE notifications (
  notification_id varchar(10) NOT NULL
  title varchar(50) NOT NULL
  content varchar(1000) NOT NULL
  start_date date
  end_date date
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`notification_id`)
);

CREATE OR REPLACE TABLE votes (
  vote_id varchar(10) NOT NULL
  title varchar(50) NOT NULL
  content varchar(1000) NOT NULL
  options varchar(1000) NOT NULL
  start_date date
  end_date date
  vote_start_date date
  vote_end_date date
  valid tinyint(1) NOT NULL DEFAULT 1
  create_by varchar(10) NOT NULL
  create_at datetime NOT NULL DEFAULT now()
  update_by varchar(10) NOT NULL
  update_at datetime NOT NULL DEFAULT now()
  update_cnt int(5) NOT NULL DEFAULT 1
  PRIMARY KEY(`vote_id`)
);

