# _*_ coding: utf-8 _*_
#!/usr/bin/env python
###################################
#description: Table Entity Class
#author: Yaochenxu
#date: 2016/10/09
###################################
import MySQLdb
import logging, datetime
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Column, Date, DateTime, Integer, Numeric, String, text
from sqlalchemy import extract
# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.Entity.Attendances')

# extensions
db = SQLAlchemy(app)

class Attendance(db.Model):
    __tablename__ = 'attendances'

    dispatch_id = db.Column(db.String(10), primary_key=True, nullable=False)
    date = db.Column(db.Date, primary_key=True, nullable=False)
    employee_id = db.Column(db.String(10), nullable=False)
    start_time = db.Column(db.DateTime, nullable=False)
    report_start_time = db.Column(db.DateTime)
    start_longitude = db.Column(db.Numeric(10, 0), nullable=False)
    start_latitude = db.Column(db.Numeric(10, 0), nullable=False)
    start_spot_name = db.Column(db.String(100), nullable=False)
    end_time = db.Column(db.DateTime)
    report_end_time = db.Column(db.DateTime)
    end_longitude = db.Column(db.Numeric(10, 0))
    end_latitude = db.Column(db.Numeric(10, 0))
    end_spot_name = db.Column(db.String(100))
    exclusive_minutes = db.Column(db.Integer)
    total_minutes = db.Column(db.Integer)
    vacation_id = db.Column(db.String(10))
    modification_log = db.Column(db.String(4000))
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))

    def save_attendances(new_attendances):
        logger.info('save_attendances() start.')
        db.session.add(new_attendances)
        db.session.commit()
        logger.info('save_attendances() end.')
    
    def clear_query_cache(self):
        db.session.commit()


