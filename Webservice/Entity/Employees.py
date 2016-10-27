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
logger = logging.getLogger('MaiaService.Entity.Employees')

# extensions
db = SQLAlchemy(app)

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

    def add_employees(new_employees):
        try:
            logger.info('add_employees() start.')
            db.session.add(new_employees)
            db.session.commit()
            logger.info('add_employees() end.')
        except Exception, e:
            db.session.rollback()
            raise e

    def clear_query_cache(self):
        db.session.commit()