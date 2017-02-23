# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: 管理員一覧画面情報取得
# author: HanBing
# date: 2016/11/16
###################################

import logging

from flask import Flask, request, session, jsonify
from sqlalchemy import extract

# initialization
app = Flask(__name__)
app.debug = True
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.GetUserListInfo')


def get_user_list_info_by_section_month_state():
    from Entity import Users, Attendances, Attendance_supervision, Sections, Status
    logger.info('get_user_list_info_by_section_month_states() start.')
    try:
        search_year = request.json.get('enterprise_id')
        search_month = request.json.get('employee_id')
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
        logger.info('get_user_list_info_by_section_month_states() end.')
        return (jsonify(
            {'result_code': 0,
             'monthly_work_time_list': monthly_work_time_list}))
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -1})
