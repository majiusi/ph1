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
logger = logging.getLogger('MaiaService.Entity.Status')

# extensions
db = SQLAlchemy(app)


class Status(db.Model):
    __tablename__ = 'status'

    enterprise_id = db.Column(db.String(10), primary_key=True, nullable=False)
    status_id = db.Column(db.String(10), primary_key=True, nullable=False)
    name = db.Column(db.String(20), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
