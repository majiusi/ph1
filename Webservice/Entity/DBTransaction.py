# -*- coding: utf-8 -*-
#!/usr/bin/env python
###################################
#description: db session class
#author: Yaochenxu
#date: 2016/11/19
###################################
#import MySQLdb
import logging
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.Entity.DBSession')

class DBSession:
    # extensions
    db_instance = SQLAlchemy(app)

def session_open():
    logger.info('DBSession open.')
    return DBSession.db_instance

def add_table_object(new_user):
    try:
        logger.info('save_user() start.')
        DBSession.db_instance.session.add(new_user)
        logger.info('save_user() end.')
    except Exception, e:
        DBSession.db_instance.session.rollback()
        raise e


def session_commit():
    try:
        logger.info('session_commit() start.')
        DBSession.db_instance.session.commit()
        logger.info('session_commit() end.')
    except Exception, e:
        DBSession.db_instance.session.rollback()
        raise e
      
def session_close():
    try:
        logger.info('DBSession close.')
        DBSession.db_instance.session.close()
    except Exception, e:
        DBSession.db_instance.session.rollback()
        raise e


