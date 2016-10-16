# _*_ coding: utf-8 _*_
#!/usr/bin/env python
###################################
#description: 社員＆勤務基本情報取得
#author: Yaochenxu
#date: 2016/10/16
###################################
import logging, datetime
from Entity import Attendances, Employees, Dispatches
from sqlalchemy import extract
from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.InsertAttendanceInfo')

def put_attendance_info():

    logger.info('put_attendance_info() start.')
    try:
        # 派遣情報取得
        dispatch = Dispatches.Dispatch()
        dispatch.clear_query_cache()
        dispatch = dispatch.query.filter_by(
            employee_id=g.user.employee_id,end_date=None).first()
        # 派遣ID
        dispatch_id = dispatch.dispatch_id

        # 出勤情報設定
        attendances = Attendances.Attendance()
        attendances.dispatch_id = dispatch_id
        attendances.employee_id = g.user.employee_id
        attendances.date = datetime.datetime.now()
        attendances.start_time = datetime.datetime.now()
        attendances.start_longitude = request.json.get('start_longitude')
        attendances.start_latitude = request.json.get('start_latitude')
        attendances.start_spot_name = request.json.get('start_spot_name')
        attendances.create_by = g.user.employee_id
        attendances.create_at = datetime.datetime.now()
        attendances.update_by = g.user.employee_id
        attendances.update_at = datetime.datetime.now()

        Attendances.Attendance.save_attendances(attendances)

        logger.info('put_attendance_info() end.')
        return (jsonify({'result_code':0 }))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 }))


