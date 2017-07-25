# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: ユーザリスト取得
# author: WuHan
# date: 2017/07/07
###################################
import logging
import datetime

from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.GetUserList')


def get_user_list():
    from Entity import DBTransaction, Users, Attendances, Employees, Employments, Sections, Authority, Dispatches
    from Utility import GetMonthList

    logger.info('get_user_list() start.')
    try:
        # 検索条件
        search_employee_id = request.json.get('search_employee_id')
        search_year = request.json.get('search_year')
        search_month = request.json.get('search_month')
        search_section = request.json.get('search_section')
        search_status = request.json.get('search_status')

        # ユーザ情報取得
        users = Users.User()
        if search_employee_id is not None:
            users = users.query.filter_by(enterprise_id=g.user.enterprise_id, employee_id=search_employee_id).first()
        else:
            users = users.query.filter_by(enterprise_id=g.user.enterprise_id).all()

        if users is None:
            raise Exception("ユーザが取得できません。")

        employees = Employees.Employee()
        employments = Employments.Employment()
        sections = Sections.Section()
        dispatches = Dispatches.Dispatch()
        attendances = Attendances.Attendance()

        total_minutes_in_month = 0
        for user in users:
            # 社員情報取得
            employee = employees.query.filter_by(enterprise_id=g.user.enterprise_id, employee_id=user.employee_id).first()
            if employee is None:
                raise Exception("社員情報が取得できません。")

            # 雇用情報取得
            employment = employments.query.filter_by(enterprise_id=g.user.enterprise_id, employee_id=user.employee_id).first()
            if employment is None:
                raise Exception("雇用情報が取得できません。")

            # 課情報取得
            section = sections.query.filter_by(enterprise_id=g.user.enterprise_id, section_id=employment.section_id).first()
            if section is None:
                raise Exception("課情報が取得できません。")

            # 派遣情報取得
            dispatch = dispatches.query.filter_by(enterprise_id=g.user.enterprise_id, employee_id=user.employee_id).first()
            if dispatch is None:
                raise Exception("派遣情報が取得できません。")

            # 勤務情報取得
            days_in_month = GetMonthList.get_month_days(search_year, search_month)
            for day in days_in_month:
                attendance = attendances.query.filter_by(enterprise_id=g.user.enterprise_id, employee_id=user.employee_id,date=day).first()
                if attendance is not None:
                    total_minutes_in_month += attendance.total_minutes

            user_dict = {'employee_id': user.employee_id,
                         'user_name': user.name,
                         'name': employee.name_in_law,
                         'section_id': section.section_id,
                         'section_name': section.name,
                         'report_ym': search_year + search_month,
                         'total_minutes_in_month': total_minutes_in_month
                         }

        logger.info('get_user_list() end.')
        return (jsonify(
            {'result_code': 0,
             'employees': user_dict
             }))

    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -1, 'user_name': user.name})
    finally:
        DBTransaction.session_close()
