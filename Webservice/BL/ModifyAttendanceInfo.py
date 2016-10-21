# _*_ coding: utf-8 _*_
#!/usr/bin/env python
###################################
#description: 勤務情報編集用クラス    
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
logger = logging.getLogger('MaiaService.BL.ModifyAttendanceInfo')

###################################
#-description: パンチ開始情報submit
#-author: Yaochenxu
#-date: 2016/10/16
###################################
def insert_attendance_work_start_info():

    logger.info('insert_attendance_work_start_info() start.')
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
        attendances.clear_query_cache()

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

        Attendances.Attendance.add_attendances(attendances)

        logger.info('insert_attendance_work_start_info() end.')
        return (jsonify({'result_code':0 }))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 }))

###################################
#-description: パンチ終了情報submit
#-author: Yaochenxu
#-date: 2016/10/19
###################################
def update_attendance_work_end_info():

    logger.info('update_attendance_work_end_info() start.')
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

        logger.info('update_attendance_work_end_info() end.')
        return (jsonify({'result_code':0 }))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 }))

###################################
#-description: レポート出勤情報submit
#-author: Yaochenxu
#-date: 2016/10/21
###################################
def update_attendance_report_info():

    logger.info('update_attendance_report_info() start.')
    try:
        # 社員ID、システム日付により、当日の勤務情報を取得
        attendances = Attendances.Attendance()
        attendances.clear_query_cache()
        attendances = attendances.query.filter_by(
            employee_id=g.user.employee_id,date=datetime.date.today()).first()
        logger.info(request)
        # 出勤時間の前に年月日を付け
        date_string = datetime.datetime.now().strftime("%Y-%m-%d ")
        logger.info(date_string)
        report_start_time = date_string + request.json.get('report_start_time')
        logger.info(report_start_time)
        report_end_time = date_string + request.json.get('report_end_time')
        logger.info(report_end_time)
        # 出勤情報更新
        attendances.report_start_time = datetime.datetime.strptime(report_start_time, "%Y-%m-%d %H:%M:%S")
        attendances.report_end_time = datetime.datetime.strptime(report_end_time, "%Y-%m-%d %H:%M:%S")
        attendances.exclusive_minutes = request.json.get('report_exclusive_minutes')
        attendances.total_minutes = request.json.get('report_total_minutes')
        attendances.update_by = g.user.employee_id
        attendances.update_at = datetime.datetime.now()
        attendances.update_cnt = attendances.update_cnt + 1

        attendances.update_attendances()

        logger.info('update_attendance_report_info() end.')
        return (jsonify({'result_code':0 }))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 }))
