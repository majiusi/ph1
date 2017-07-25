# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: ユーザ勤務一覧情報取得
# author: HanBing, WuHan
# date: 2016/11/16
###################################

import logging

from flask import Flask, request, session, jsonify
from sqlalchemy import extract

# initialization
app = Flask(__name__)
app.debug = True
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.GetAttendanceList')


def get_attendance_list():
    from Entity import Users, Attendances, Attendance_supervision, Sections, Status
    logger.info('get_attendance_list() start.')
    try:
        search_year = request.json.get('search_year')
        search_month = request.json.get('search_month')

        # 月の全日リストの取得
        month_days_list = GetMonthList.get_month_days(search_year, search_month)
        # 月間出勤情報リスト
        monthly_work_time_list = []
        # 出力の空リスト作成
        for day in month_days_list:
            # 出力編集
            result_dict = {'work_date': day,
                           'which_day': Jholiday.get_which_day(datetime.datetime.strptime(day, "%Y-%m-%d")),
                           'report_start_time': '',
                           'report_end_time': '',
                           'report_exclusive_minutes': '',
                           'report_total_minutes': ''
                           }

            # 月間出勤情報リストに追加
            monthly_work_time_list.append(result_dict)

        # 社員ID、パラメータの年月により、当月の勤務情報を取得
        attendances = Attendances.Attendance()
        attendances = attendances.query.filter(
            Attendances.Attendance.enterprise_id == g.user.enterprise_id,
            Attendances.Attendance.employee_id == g.user.employee_id,
            extract('year', Attendances.Attendance.date) == search_year,
            extract('month', Attendances.Attendance.date) == search_month).all()

        # 出勤日合計、出勤時間合計
        total_days = len(attendances)
        total_hours = 0

        # 月間出勤情報リスト設定（出勤データがある日のみ）
        for element in attendances:
            # NULL対策
            report_start_time = 0
            report_end_time = 0
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

            # 日付によりインデクスを作成し、出勤データがある日を月リストに設定
            index = int(element.date.strftime('%d')) - 1
            monthly_work_time_list[index]['report_start_time'] = report_start_time
            monthly_work_time_list[index]['report_end_time'] = report_end_time
            monthly_work_time_list[index]['report_exclusive_minutes'] = report_exclusive_minutes
            monthly_work_time_list[index]['report_total_minutes'] = report_total_minutes

            # 出勤時間合計
            total_hours = total_hours + report_total_minutes

        logger.info('get_attendance_info_by_year_month() end.')
        return (jsonify(
            {'result_code': 0,
             'total_days': total_days,
             'total_hours': total_hours,
             'monthly_work_time_list': monthly_work_time_list}))
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -1})

        search_year = request.json.get('search_year')
        search_month = request.json.get('search_month')
        search_name = request.json.get('search_name')
        search_section = request.json.get('search_section')
        search_status = request.json.get('search_status')

        users = Users.User()
        users.clear_query_cache()
        users = users.query.filter().all()
        total_hours = 0
        total_section_id = 0
        total_status_id = 0
        # total_status_name = ''
        # total_section_name = ''
        # total_users_name = ''
        # 月間出勤情報status = 0リスト
        monthly_work_time_list = []
        for element_user in users:
            total_users_name = element_user.name
            # 社員ID、パラメータの年月により、当月の勤務情報を取得
            attendances = Attendances.Attendance()
            attendances.clear_query_cache()
            attendances = session.query(Attendances).\
                join(Attendance_supervision, Attendances.Attendance.dispatch_id ==
                     Attendance_supervision.AttendanceSupervision.dispatch_id).filter(
                Attendances.Attendance.enterprise_id == element_user.enterprise_id,
                Attendances.Attendance.employee_id == element_user.employee_id,
                extract('year', Attendances.Attendance.date) == search_year,
                extract('month', Attendances.Attendance.date) == search_month).all()

            # 出勤日合計、出勤時間合計、ステータスID、課ID
            total_days = len(attendances)
            # 月間出勤情報リスト取得
            for element in attendances:
                # NULL対策
                report_total_minutes = 0
                if element.total_minutes is not None:
                    report_total_minutes = element.total_minutes
                # 出勤時間合計
                total_hours = total_hours + report_total_minutes
                
                # 課ID
                # total_section_id = element.section_id
                # ステータスID
                # total_status_id = element.status_id
            sections = Sections.Sections.sections()
            sections.clear_query_cache()
            sections = sections.query.filter(
                Sections.Sections.enterprise_id == element_user.enterprise_id,
                Sections.Sections.section_id == total_section_id).first()
            total_section_name = sections.name
            status = Status.Status.status()
            status.clear_query_cache()
            status = status.query.filter(
                Status.Status.status.enterprise_id == element_user.enterprise_id,
                Status.Status.status.status_id == total_status_id).first()
            total_status_name = status.name
            # 出力編集
            result_dict = {'total_days': total_days,
                           'total_hours': total_hours,
                           'total_status_name': total_status_name,
                           'total_section_name': total_section_name,
                           'total_users_name': total_users_name
                           }
            # 管理員一覧画面情報リストに追加
            monthly_work_time_list.append(result_dict)
        logger.info('get_attendance_list() end.')
        return (jsonify(
            {'result_code': 0,
             'monthly_work_time_list': monthly_work_time_list}))
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -1})
