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
logger = logging.getLogger('MaiaService.Entity.Dispatches')

# extensions
db = DBTransaction.session_open()


class Dispatch(db.Model):
    __tablename__ = 'dispatches'

    enterprise_id = db.Column(db.String(10), primary_key=True, nullable=False)
    dispatch_id = db.Column(db.String(10), primary_key=True)
    employee_id = db.Column(db.String(10), nullable=False, unique=True)
    site_id = db.Column(db.Integer, nullable=False)
    start_date = db.Column(db.Date, nullable=False, unique=True)
    end_date = db.Column(db.Date, nullable=False, unique=True)
    fixed_monthly_hours = db.Column(db.Integer)
    report_day = db.Column(db.Integer, nullable=True)
    work_start_time = db.Column(db.String(5), nullable=False)
    work_end_time = db.Column(db.String(5), nullable=False)
    day_break_start_time = db.Column(db.String(5), nullable=True)
    day_break_minutes = db.Column(db.Integer, nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(100), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(100), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
