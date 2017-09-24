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
logger = logging.getLogger('MaiaService.Entity.Authority')

# extensions
db = DBTransaction.session_open()


class Authority(db.Model):
    __tablename__ = 'authority'

    enterprise_id = db.Column(db.String(10), primary_key=True, nullable=False)
    authority_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(100), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(100), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
