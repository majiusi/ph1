# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: Table Entity Class
# author: Hanbing
# date: 2016/10/09
###################################
import logging

from flask import Flask
from flask_sqlalchemy import SQLAlchemy

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.Entity.Employments')

# extensions
db = SQLAlchemy(app)


class Employments(db.Model):
    __tablename__ = 'employments'

    enterprise_id = db.Column(db.String(10), primary_key=True, nullable=False)
    employee_id = db.Column(db.String(10), primary_key=True, nullable=False)
    duty_id = db.Column(db.String(10), nullable=False)
    section_id = db.Column(db.String(10), nullable=False)
    start_date = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    end_date = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    type_id = db.Column(db.String(10), nullable=False)
    monthly_salary = db.Column(db.Numeric(10, 7), nullable=False)
    monthly_fee = db.Column(db.Numeric(10, 7), nullable=False)
    bonus_id = db.Column(db.String(10), nullable=False)
    penalty_id = db.Column(db.String(10), nullable=False)
    ensurance_id = db.Column(db.String(10), nullable=False)
    exclusive_id = db.Column(db.String(10), nullable=False)
    payroll_id = db.Column(db.String(10), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
