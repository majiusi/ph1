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
logger = logging.getLogger('MaiaService.Entity.Authority')

# extensions
db = SQLAlchemy(app)

class Authority(db.Model):
    __tablename__ = 'authority'

    enterprise_id = db.Column(db.String(10), primary_key=True, nullable=False)
    authority_id = db.Column(db.String(10), primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))

    def add_authority(new_authority):
        try:
            logger.info('add_authority() start.')
            db.session.add(new_authority)
            db.session.commit()
            logger.info('add_authority() end.')
        except Exception, e:
            db.session.rollback()
            raise e
