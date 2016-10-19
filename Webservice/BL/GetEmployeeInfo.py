# _*_ coding: utf-8 _*_
#!/usr/bin/env python
###################################
#description: 社員＆勤務基本情報取得
#author: Yaochenxu
#date: 2016/10/15
###################################
import logging, datetime
from Entity import Attendances, Employees, Dispatches
from sqlalchemy import extract
from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.GetEmployeeInfo')

def get_employee_info():

    logger.info('get_employee_info() start.')
    try:
        # 社員ID、システム日付により、当日の勤務情報を取得
        attendances = Attendances.Attendance()
        attendances.clear_query_cache()
        attendances = attendances.query.filter_by(
            employee_id=g.user.employee_id,date=datetime.date.today()).first()

        # 出勤時間、退勤時間の取得
        start_time = attendances.start_time.strftime('%H:%M:%S')
        end_time = ''
        if attendances.end_time is not None:
            end_time = attendances.end_time.strftime('%H:%M:%S')

        # 派遣情報取得
        dispatch = Dispatches.Dispatch()
        dispatch.clear_query_cache()
        dispatch = dispatch.query.filter_by(
            employee_id=g.user.employee_id,end_date=None).first()

        # ディフォルト出勤時間、退勤時間、控除分数
        default_work_start_time = dispatch.work_start_time
        default_work_end_time = dispatch.work_end_time
        default_except_minutes = dispatch.day_break_minutes

        # 社員情報取得
        employee = Employees.Employee()
        employee.clear_query_cache()
        employee = employee.query.filter_by(employee_id=g.user.employee_id).first()

        # 日本語名
        name_jp = employee.name_jp
        # 権限ID  
        auth_id = g.user.auth_id

        logger.info('get_employee_info() end.')
        return (jsonify(
            {'result_code':0 ,
            'name_jp': name_jp,
            'auth_id':auth_id,
            'default_work_start_time':default_work_start_time,
            'default_work_end_time':default_work_end_time,
            'default_except_minutes':default_except_minutes,
            'start_time':start_time,
            'end_time':end_time}))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 }))


