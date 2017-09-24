# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: Table Entity Class
# author: Yaochenxu
# date: 2016/10/09
###################################
import logging
import DBTransaction

from flask import Flask

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.Entity.Employments')

# extensions
db = DBTransaction.session_open()


class Employment(db.Model):
    __tablename__ = 'employments'

    enterprise_id = db.Column(db.String(10), primary_key=True, nullable=False)
    employee_id = db.Column(db.String(10), primary_key=True, nullable=False)
    duty_id = db.Column(db.String(10))
    section_id = db.Column(db.String(10))
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    emp_type = db.Column(db.String(20))
    monthly_salary = db.Column(db.Numeric(10, 0))
    monthly_fee = db.Column(db.Numeric(10, 0))
    ensurance_id = db.Column(db.String(10))
    exclusive_id = db.Column(db.String(10))
    payroll_id = db.Column(db.String(10))
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(100), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(100), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
