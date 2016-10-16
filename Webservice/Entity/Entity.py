# _*_ coding: utf-8 _*_
#!/usr/bin/env python
###################################
#description: Table Entity Class
#author: Yaochenxu
#date: 2016/10/09
###################################
import MySQLdb
import logging
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Column, Date, DateTime, Integer, Numeric, String, text

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.DB.Entity')

# extensions
db = SQLAlchemy(app)

class AttendanceSupervision(db.Model):
    __tablename__ = 'attendance_supervision'

    dispatch_id = db.Column(db.String(10), primary_key=True, nullable=False)
    month = db.Column(Db.date, primary_key=True, nullable=False)
    status_id = db.Column(db.String(10), nullable=False)
    remark = db.Column(db.String(200))
    report_path = db.Column(db.String(200))
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Attendance(db.Model):
    __tablename__ = 'attendances'

    dispatch_id = db.Column(db.String(10), primary_key=True, nullable=False)
    date = db.Column(Db.date, primary_key=True, nullable=False)
    employee_id = db.Column(db.String(10), nullable=False)
    start_time = db.Column(db.DateTime, nullable=False)
    report_start_time = db.Column(db.DateTime, nullable=False)
    start_longitude = db.Column(db.Numeric(10, 0), nullable=False)
    start_latitude = db.Column(db.Numeric(10, 0), nullable=False)
    start_spot_name = db.Column(db.String(100), nullable=False)
    end_time = db.Column(db.DateTime, nullable=False)
    report_end_time = db.Column(db.DateTime, nullable=False)
    end_longitude = db.Column(db.Numeric(10, 0), nullable=False)
    end_latitude = db.Column(db.Numeric(10, 0), nullable=False)
    end_spot_name = db.Column(db.String(100), nullable=False)
    exclusive_minutes = db.Column(db.Integer, nullable=False)
    total_minutes = db.Column(db.Integer, nullable=False)
    vacation_id = db.Column(db.String(10))
    modification_log = db.Column(db.String(4000))
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Authority(db.Model):
    __tablename__ = 'authority'

    authority_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Bank(db.Model):
    __tablename__ = 'banks'

    bank_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class BonusPenalty(db.Model):
    __tablename__ = 'bonus_penalty'

    bonus_penalty_id = db.Column(db.String(10), primary_key=True)
    type = db.Column(db.Integer, nullable=False)
    name = db.Column(db.String(100), nullable=False)
    start_date = db.Column(Db.date, nullable=False)
    end_date = db.Column(Db.date, nullable=False)
    amount = db.Column(db.Numeric(10, 0), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Branch(db.Model):
    __tablename__ = 'branches'

    branch_id = db.Column(db.String(10), primary_key=True)
    bank_id = db.Column(db.String(10), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Code(db.Model):
    __tablename__ = 'codes'

    code_id = db.Column(db.String(10), primary_key=True)
    type = db.Column(db.String(20), nullable=False)
    code = db.Column(db.String(20), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Customer(db.Model):
    __tablename__ = 'customers'

    id = db.Column(db.String(10), primary_key=True)
    spot_id = db.Column(db.String(10), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Department(db.Model):
    __tablename__ = 'departments'

    department_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    chief_employee_id = db.Column(db.String(10), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Dispatch(db.Model):
    __tablename__ = 'dispatches'

    dispatch_id = db.Column(db.String(10), primary_key=True)
    employee_id = db.Column(db.String(10), nullable=False, unique=True)
    customer_id = db.Column(db.String(10), nullable=False)
    site_id = db.Column(db.Integer, nullable=False)
    start_date = db.Column(Db.date, nullable=False, unique=True)
    end_date = db.Column(Db.date, nullable=False, unique=True)
    fixed_monthly_hours = db.Column(Integer)
    report_day = db.Column(db.Integer, nullable=False)
    work_start_time = db.Column(db.String(4), nullable=False)
    work_end_time = db.Column(db.String(4), nullable=False)
    day_break_start_time = db.Column(db.String(4), nullable=False)
    day_break_minutes = db.Column(db.Integer, nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class District(db.Model):
    __tablename__ = 'districts'

    district_id = db.Column(db.String(10), primary_key=True)
    prefecture_id = db.Column(db.String(10), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    name_kana = db.Column(db.String(200), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Employee(db.Model):
    __tablename__ = 'employees'

    employee_id = db.Column(db.String(10), primary_key=True)
    name_in_law = db.Column(db.String(20), nullable=False)
    name_cn = db.Column(db.String(20), nullable=False)
    name_en = db.Column(db.String(20), nullable=False)
    name_jp = db.Column(db.String(20), nullable=False)
    name_kana = db.Column(db.String(20), nullable=False)
    resident_spot_id = db.Column(db.String(10), nullable=False)
    mobile = db.Column(db.String(11), nullable=False)
    mobile_cn = db.Column(db.String(11))
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Employment(db.Model):
    __tablename__ = 'employments'

    employment_id = db.Column(db.String(10), primary_key=True)
    employee_id = db.Column(db.String(10), nullable=False)
    section_id = db.Column(db.String(10))
    start_date = db.Column(Db.date, nullable=False)
    end_date = db.Column(Db.date, nullable=False)
    type_id = db.Column(db.String(10), nullable=False)
    monthly_salary = db.Column(db.Numeric(10, 0), nullable=False)
    monthly_fee = db.Column(db.Numeric(10, 0))
    bonus_id = db.Column(db.String(10))
    penalty_id = db.Column(db.String(10))
    ensurance_id = db.Column(db.String(10), nullable=False)
    exclusive_id = db.Column(db.String(10))
    payroll_id = db.Column(db.String(10), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Ensurance(db.Model):
    __tablename__ = 'ensurance'

    ensurance_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    start_date = db.Column(Db.date, nullable=False)
    end_date = db.Column(Db.date, nullable=False)
    amount = db.Column(db.Numeric(10, 0), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Exclusive(db.Model):
    __tablename__ = 'exclusives'

    exclusive_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    start_date = db.Column(Db.date, nullable=False)
    end_date = db.Column(Db.date, nullable=False)
    amount = db.Column(db.Numeric(10, 0), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Holiday(db.Model):
    __tablename__ = 'holidays'

    date = db.Column(Db.date, primary_key=True, nullable=False)
    no = db.Column(db.Integer, primary_key=True, nullable=False)
    type_id = db.Column(db.String(10), nullable=False)
    name = db.Column(db.String(20), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Modification(db.Model):
    __tablename__ = 'modifications'

    modification_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Notification(db.Model):
    __tablename__ = 'notifications'

    notification_id = db.Column(db.String(10), primary_key=True)
    title = db.Column(db.String(50), nullable=False)
    content = db.Column(db.String(1000), nullable=False)
    start_date = db.Column(Date)
    end_date = db.Column(Date)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Payroll(db.Model):
    __tablename__ = 'payroll'

    payroll_id = db.Column(db.String(10), primary_key=True)
    branch_id = db.Column(db.String(10), nullable=False)
    card_no = db.Column(db.String(30), nullable=False)
    card_sign = db.Column(db.String(20), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Prefecture(db.Model):
    __tablename__ = 'prefectures'

    prefecture_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    name_kana = db.Column(db.String(200), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Section(db.Model):
    __tablename__ = 'sections'

    section_id = db.Column(db.String(10), primary_key=True)
    department_id = db.Column(db.String(10), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    chief_employee_id = db.Column(db.String(10), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Site(db.Model):
    __tablename__ = 'sites'

    id = db.Column(db.String(10), primary_key=True)
    spot_id = db.Column(db.String(10), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Spot(db.Model):
    __tablename__ = 'spots'

    spot_id = db.Column(db.String(10), primary_key=True)
    type_id = db.Column(db.String(10), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    name_kana = db.Column(db.String(200), nullable=False)
    district_id = db.Column(db.String(10), nullable=False)
    addr_detail = db.Column(db.String(200), nullable=False)
    post_code = db.Column(db.String(7), nullable=False)
    tel = db.Column(db.String(10))
    start_longitude = db.Column(db.Numeric(10, 0), nullable=False)
    start_latitude = db.Column(db.Numeric(10, 0), nullable=False)
    end_longitude = db.Column(db.Numeric(10, 0), nullable=False)
    end_latitude = db.Column(db.Numeric(10, 0), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Statu(db.Model):
    __tablename__ = 'status'

    status_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class User(db.Model):
    __tablename__ = 'users'

    user_id = db.Column(db.String(10), primary_key=True)
    employee_id = db.Column(db.String(10), nullable=False, unique=True)
    name = db.Column(db.String(20), nullable=False, unique=True)
    pwd = db.Column(db.String(256), nullable=False)
    auth_id = db.Column(db.String(10), nullable=False, unique=True)
    last_login_at = db.Column(db.DateTime, nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Vacation(db.Model):
    __tablename__ = 'vacations'

    vacation_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))


class Vote(db.Model):
    __tablename__ = 'votes'

    vote_id = db.Column(db.String(10), primary_key=True)
    title = db.Column(db.String(50), nullable=False)
    content = db.Column(db.String(1000), nullable=False)
    options = db.Column(db.String(1000), nullable=False)
    start_date = db.Column(Date)
    end_date = db.Column(Date)
    vote_start_date = db.Column(Date)
    vote_end_date = db.Column(Date)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))

