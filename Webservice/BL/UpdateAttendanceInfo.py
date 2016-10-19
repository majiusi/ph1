# _*_ coding: utf-8 _*_
#!/usr/bin/env python
###################################
#description: 社員＆勤務基本情報取得
#author: Yaochenxu
#date: 2016/10/19
###################################
import logging, datetime
from Entity import Attendances, Employees, Dispatches
from sqlalchemy import extract
from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.UpdateAttendanceInfo')

def modify_attendance_info():

    logger.info('modify_attendance_info() start.')
    try:
        # 社員ID、システム日付により、当日の勤務情報を取得
        attendances = Attendances.Attendance()
        attendances.clear_query_cache()
        attendances = attendances.query.filter_by(
            employee_id=g.user.employee_id,date=datetime.date.today()).first()

        # 出勤情報更新
        attendances.end_time = datetime.datetime.now()
        attendances.end_longitude = request.json.get('end_longitude')
        attendances.end_latitude = request.json.get('end_latitude')
        attendances.end_spot_name = request.json.get('end_spot_name')
        attendances.update_by = g.user.employee_id
        attendances.update_at = datetime.datetime.now()
        attendances.update_cnt = attendances.update_cnt + 1

        attendances.update_attendances()

        logger.info('modify_attendance_info() end.')
        return (jsonify({'result_code':0 }))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 }))


