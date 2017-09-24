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
logger = logging.getLogger('MaiaService.Entity.Attendances')

# extensions
db = DBTransaction.session_open()


class Attendance(db.Model):
    __tablename__ = 'attendances'

    enterprise_id = db.Column(db.String(10), primary_key=True, nullable=False)
    dispatch_id = db.Column(db.String(10), primary_key=True, nullable=False)
    date = db.Column(db.Date, primary_key=True, nullable=False)
    employee_id = db.Column(db.String(10), nullable=False)
    start_time = db.Column(db.DateTime, nullable=False)
    report_start_time = db.Column(db.DateTime)
    start_longitude = db.Column(db.Numeric(10, 7), nullable=False)
    start_latitude = db.Column(db.Numeric(10, 7), nullable=False)
    start_spot_name = db.Column(db.String(100), nullable=False)
    end_time = db.Column(db.DateTime)
    report_end_time = db.Column(db.DateTime)
    end_longitude = db.Column(db.Numeric(10, 7))
    end_latitude = db.Column(db.Numeric(10, 7))
    end_spot_name = db.Column(db.String(100))
    exclusive_minutes = db.Column(db.Integer)
    total_minutes = db.Column(db.Integer)
    vacation_id = db.Column(db.String(10))
    modification_log = db.Column(db.String(4000))
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(100), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(100), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
