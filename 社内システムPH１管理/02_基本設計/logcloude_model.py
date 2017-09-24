# coding: utf-8
from sqlalchemy import Column, Date, DateTime, Integer, Numeric, String, text
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
metadata = Base.metadata


class AttendanceSupervision(Base):
    __tablename__ = 'attendance_supervision'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    dispatch_id = Column(String(10), primary_key=True, nullable=False)
    month = Column(Date, primary_key=True, nullable=False)
    status_id = Column(String(10), nullable=False)
    remark = Column(String(200))
    report_path = Column(String(200))
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Attendance(Base):
    __tablename__ = 'attendances'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    dispatch_id = Column(String(10), primary_key=True, nullable=False)
    date = Column(Date, primary_key=True, nullable=False)
    employee_id = Column(String(10), nullable=False)
    start_time = Column(DateTime, nullable=False)
    report_start_time = Column(DateTime)
    start_longitude = Column(Numeric(10, 7), nullable=False)
    start_latitude = Column(Numeric(10, 7), nullable=False)
    start_spot_name = Column(String(100), nullable=False)
    end_time = Column(DateTime)
    report_end_time = Column(DateTime)
    end_longitude = Column(Numeric(10, 7))
    end_latitude = Column(Numeric(10, 7))
    end_spot_name = Column(String(100))
    exclusive_minutes = Column(Integer)
    total_minutes = Column(Integer)
    vacation_id = Column(String(10))
    modification_log = Column(String(4000))
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(100), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(100), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Authority(Base):
    __tablename__ = 'authority'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    authority_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(20), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(100), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Bank(Base):
    __tablename__ = 'banks'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    bank_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(100), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class BonusPenalty(Base):
    __tablename__ = 'bonus_penalty'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    bonus_penalty_id = Column(String(10), primary_key=True, nullable=False)
    type = Column(Integer, nullable=False)
    name = Column(String(100), nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    amount = Column(Numeric(10, 0), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Branch(Base):
    __tablename__ = 'branches'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    branch_id = Column(String(10), primary_key=True, nullable=False)
    bank_id = Column(String(10), nullable=False)
    name = Column(String(100), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Code(Base):
    __tablename__ = 'codes'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    code_id = Column(String(10), primary_key=True, nullable=False)
    type = Column(String(20), nullable=False)
    code = Column(String(20), nullable=False)
    name = Column(String(100), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Customer(Base):
    __tablename__ = 'customers'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    customer_id = Column(String(10), primary_key=True, nullable=False)
    spot_id = Column(String(10), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Department(Base):
    __tablename__ = 'departments'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    department_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(100), nullable=False)
    chief_employee_id = Column(String(10), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Dispatch(Base):
    __tablename__ = 'dispatches'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    dispatch_id = Column(String(10), primary_key=True, nullable=False)
    employee_id = Column(String(10), nullable=False, unique=True)
    site_id = Column(Integer, nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date)
    fixed_monthly_hours = Column(Integer)
    report_day = Column(Integer)
    work_start_time = Column(String(5), nullable=False)
    work_end_time = Column(String(5), nullable=False)
    day_break_start_time = Column(String(5))
    day_break_minutes = Column(Integer, nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(100), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(100), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class District(Base):
    __tablename__ = 'districts'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    district_id = Column(String(10), primary_key=True, nullable=False)
    prefecture_id = Column(String(10), nullable=False)
    name = Column(String(100), nullable=False)
    name_kana = Column(String(200), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Employee(Base):
    __tablename__ = 'employees'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    employee_id = Column(String(10), primary_key=True, nullable=False)
    name_in_law = Column(String(20))
    name_cn = Column(String(20))
    name_en = Column(String(20))
    name_jp = Column(String(20), nullable=False)
    name_kana = Column(String(20))
    resident_addr = Column(String(10))
    mobile = Column(String(13))
    mobile_cn = Column(String(13))
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(100), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(100), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))
    mail_addr = Column(String(255), nullable=False)


class Employment(Base):
    __tablename__ = 'employments'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    employee_id = Column(String(10), primary_key=True, nullable=False)
    duty_id = Column(String(10))
    section_id = Column(String(10))
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    emp_type = Column(String(20))
    monthly_salary = Column(Numeric(10, 0), nullable=False)
    monthly_fee = Column(Numeric(10, 0))
    ensurance_id = Column(String(10))
    exclusive_id = Column(String(10))
    payroll_id = Column(String(10))
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(100), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(100), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))
    department_id = Column(String(10))


class Ensurance(Base):
    __tablename__ = 'ensurance'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    ensurance_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(100), nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    amount = Column(Numeric(10, 0), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Exclusive(Base):
    __tablename__ = 'exclusives'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    exclusive_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(100), nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    amount = Column(Numeric(10, 0), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Holiday(Base):
    __tablename__ = 'holidays'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    date = Column(Date, primary_key=True, nullable=False)
    no = Column(Integer, primary_key=True, nullable=False)
    type_id = Column(String(10), nullable=False)
    name = Column(String(20), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Modification(Base):
    __tablename__ = 'modifications'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    modification_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(20), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Notification(Base):
    __tablename__ = 'notifications'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    notification_id = Column(String(10), primary_key=True, nullable=False)
    title = Column(String(50), nullable=False)
    content = Column(String(1000), nullable=False)
    start_date = Column(Date)
    end_date = Column(Date)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Payroll(Base):
    __tablename__ = 'payroll'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    payroll_id = Column(String(10), primary_key=True, nullable=False)
    branch_id = Column(String(10), nullable=False)
    card_no = Column(String(30), nullable=False)
    card_sign = Column(String(20), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Prefecture(Base):
    __tablename__ = 'prefectures'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    prefecture_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(100), nullable=False)
    name_kana = Column(String(200), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Section(Base):
    __tablename__ = 'sections'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    section_id = Column(String(10), primary_key=True, nullable=False)
    department_id = Column(String(10), nullable=False)
    name = Column(String(100), nullable=False)
    chief_employee_id = Column(String(10), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Site(Base):
    __tablename__ = 'sites'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    site_id = Column(String(10), primary_key=True, nullable=False)
    spot_id = Column(String(10), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Spot(Base):
    __tablename__ = 'spots'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    spot_id = Column(String(10), primary_key=True, nullable=False)
    type_id = Column(String(10), nullable=False)
    name = Column(String(100), nullable=False)
    name_kana = Column(String(200), nullable=False)
    district_id = Column(String(10), nullable=False)
    addr_detail = Column(String(200), nullable=False)
    post_code = Column(String(7), nullable=False)
    tel = Column(String(10))
    start_longitude = Column(Numeric(10, 0), nullable=False)
    start_latitude = Column(Numeric(10, 0), nullable=False)
    end_longitude = Column(Numeric(10, 0), nullable=False)
    end_latitude = Column(Numeric(10, 0), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Statu(Base):
    __tablename__ = 'status'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    status_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(20), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class User(Base):
    __tablename__ = 'users'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    employee_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(100), nullable=False, unique=True)
    pwd = Column(String(256), nullable=False)
    auth_id = Column(String(10), nullable=False)
    last_login_at = Column(DateTime, nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(100), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(100), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Vacation(Base):
    __tablename__ = 'vacations'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    vacation_id = Column(String(10), primary_key=True, nullable=False)
    name = Column(String(20), nullable=False)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))


class Vote(Base):
    __tablename__ = 'votes'

    enterprise_id = Column(String(10), primary_key=True, nullable=False)
    vote_id = Column(String(10), primary_key=True, nullable=False)
    title = Column(String(50), nullable=False)
    content = Column(String(1000), nullable=False)
    options = Column(String(1000), nullable=False)
    start_date = Column(Date)
    end_date = Column(Date)
    vote_start_date = Column(Date)
    vote_end_date = Column(Date)
    valid = Column(Integer, nullable=False, server_default=text("'1'"))
    create_by = Column(String(10), nullable=False)
    create_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_by = Column(String(10), nullable=False)
    update_at = Column(DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP"))
    update_cnt = Column(Integer, nullable=False, server_default=text("'1'"))
