# _*_ coding: utf-8 _*_
#!/usr/bin/env python
###################################
#description: 月間勤務情報取得
#author: Yaochenxu
#date: 2016/10/16
###################################
import logging, datetime
from Utility import Jholiday
from Entity import Attendances, Employees, Dispatches
from sqlalchemy import extract
from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.GetAttendanceInfo')

def get_attendance_info_by_year_month():

    logger.info('get_attendance_info_by_year_month() start.')
    try:
        search_year = request.json.get('search_year')
        search_month = request.json.get('search_month')
        
        # 社員ID、パラメータの年月により、当月の勤務情報を取得
        attendances = Attendances.Attendance()
        attendances.clear_query_cache()
        attendances = attendances.query.filter(
            Attendances.Attendance.enterprise_id==g.user.enterprise_id,
            Attendances.Attendance.employee_id==g.user.employee_id,
            extract('year',Attendances.Attendance.date)==search_year,
            extract('month',Attendances.Attendance.date)==search_month).all()
        
        # 出勤日合計、出勤時間合計
        total_days = len(attendances)
        total_hours = 0
        # 月間出勤情報リスト
        monthly_work_time_list = []

        # 月間出勤情報リスト取得
        for element in attendances:
            # NULL対策
            report_start_time = ''
            report_end_time = ''
            report_exclusive_minutes = 0
            report_total_minutes = 0

            if element.report_start_time is not None:
                report_start_time = element.report_start_time.strftime('%H:%M:%S')
            if element.report_end_time is not None:
                report_end_time = element.report_end_time.strftime('%H:%M:%S')
            if element.exclusive_minutes is not None:
                report_exclusive_minutes = element.exclusive_minutes
            if element.total_minutes is not None:
                report_total_minutes = element.total_minutes

            # 出力編集
            result_dict = {'work_date':element.date.strftime('%Y-%m-%d'),
            'which_day':Jholiday.get_which_day(element.date),
            'report_start_time':report_start_time,
            'report_end_time':report_end_time,
            'report_exclusive_minutes':report_exclusive_minutes,
            'report_total_minutes':report_total_minutes
            }
            
            # 出勤時間合計
            total_hours = total_hours + report_total_minutes
            # 月間出勤情報リストに追加
            monthly_work_time_list.append(result_dict)        

        logger.info('get_attendance_info_by_year_month() end.')
        return (jsonify(
            {'result_code':0 ,
            'total_days': total_days,
            'total_hours':total_hours,
            'monthly_work_time_list':monthly_work_time_list}))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 }))






