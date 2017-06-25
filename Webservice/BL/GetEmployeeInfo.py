# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: 社員＆勤務基本情報取得
# author: Yaochenxu
# date: 2016/10/15
###################################
import datetime
import logging

from flask import Flask, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.GetEmployeeInfo')


def get_employee_info():
    from Entity import DBTransaction, Attendances, Employees, Dispatches
    logger.info('get_employee_info() start.')
    try:
        # 社員ID、システム日付により、当日の勤務情報を取得
        attendances = Attendances.Attendance()
        attendances = attendances.query.filter_by(enterprise_id=g.user.enterprise_id,
                                                  employee_id=g.user.employee_id, date=datetime.date.today()).first()

        # 出勤時間、退勤時間
        # レポート用当日出勤時間、当日退勤時間、当日控除時間、当日合計時間
        start_time = ''
        end_time = ''
        report_start_time = ''
        report_end_time = ''
        report_exclusive_minutes = ''
        report_total_minutes = ''
        if attendances is not None:
            if attendances.start_time is not None:
                start_time = attendances.start_time.strftime('%H:%M:%S')
            if attendances.end_time is not None:
                end_time = attendances.end_time.strftime('%H:%M:%S')
            if attendances.report_start_time is not None:
                report_start_time = attendances.report_start_time.strftime('%H:%M:%S')
            if attendances.report_end_time is not None:
                report_end_time = attendances.report_end_time.strftime('%H:%M:%S')
            if attendances.exclusive_minutes is not None:
                report_exclusive_minutes = attendances.exclusive_minutes
            if attendances.total_minutes is not None:
                report_total_minutes = attendances.total_minutes

        # 派遣情報取得
        dispatch = Dispatches.Dispatch()
        dispatch = dispatch.query.filter_by(enterprise_id=g.user.enterprise_id,
                                            employee_id=g.user.employee_id, end_date=None).first()
        # ディフォルト出勤時間、退勤時間、控除分数
        default_work_start_time = ''
        default_work_end_time = ''
        default_except_minutes = ''
        if dispatch is not None:
            default_work_start_time = dispatch.work_start_time
            default_work_end_time = dispatch.work_end_time
            default_except_minutes = dispatch.day_break_minutes

        # 社員情報取得
        employee = Employees.Employee()
        employee = employee.query.filter_by(enterprise_id=g.user.enterprise_id,
                                            employee_id=g.user.employee_id).first()

        # 日本語名、権限ID
        name_jp = ''
        auth_id = ''
        if employee is not None:
            name_jp = employee.name_jp
            auth_id = g.user.auth_id

        logger.info('get_employee_info() end.')
        return (jsonify(
            {'result_code': 0,
             'name_jp': name_jp,
             'auth_id': auth_id,
             'default_work_start_time': default_work_start_time,
             'default_work_end_time': default_work_end_time,
             'default_except_minutes': default_except_minutes,
             'start_time': start_time,
             'end_time': end_time,
             'report_start_time': report_start_time,
             'report_end_time': report_end_time,
             'report_exclusive_minutes': report_exclusive_minutes,
             'report_total_minutes': report_total_minutes
             }))
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9})
    finally:
        DBTransaction.session_close()
