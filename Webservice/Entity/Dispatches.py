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
logger = logging.getLogger('MaiaService.Entity.Dispatches')

# extensions
db = SQLAlchemy(app)

class Dispatch(db.Model):
    __tablename__ = 'dispatches'

    dispatch_id = db.Column(db.String(10), primary_key=True)
    employee_id = db.Column(db.String(10), nullable=False, unique=True)
    customer_id = db.Column(db.String(10), nullable=False)
    site_id = db.Column(db.Integer, nullable=False)
    start_date = db.Column(db.Date, nullable=False, unique=True)
    end_date = db.Column(db.Date, nullable=False, unique=True)
    fixed_monthly_hours = db.Column(Integer)
    report_day = db.Column(db.Integer, nullable=False)
    work_start_time = db.Column(db.String(5), nullable=False)
    work_end_time = db.Column(db.String(5), nullable=False)
    day_break_start_time = db.Column(db.String(5), nullable=False)
    day_break_minutes = db.Column(db.Integer, nullable=False)
    valid = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))
    create_by = db.Column(db.String(10), nullable=False)
    create_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_by = db.Column(db.String(10), nullable=False)
    update_at = db.Column(db.DateTime, nullable=False, server_default=db.text("CURRENT_TIMESTAMP"))
    update_cnt = db.Column(db.Integer, nullable=False, server_default=db.text("'1'"))

    def add_dispatches(new_dispatches):
        try:
            logger.info('add_dispatches() start.')
            db.session.add(new_dispatches)
            db.session.commit()
            logger.info('add_dispatches() end.')
        except Exception, e:
            db.session.rollback()
            raise e
    
    def clear_query_cache(self):
        db.session.commit()
