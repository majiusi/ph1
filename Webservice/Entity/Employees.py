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
logger = logging.getLogger('MaiaService.Entity.Employees')

# extensions
db = DBTransaction.session_open()


class Employee(db.Model):
    __tablename__ = 'employees'

    enterprise_id = db.Column(db.String(10), primary_key=True, nullable=False)
    employee_id = db.Column(db.String(10), primary_key=True, nullable=False)
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
