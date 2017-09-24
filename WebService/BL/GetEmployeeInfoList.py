# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: 社員情報リスト取得
# author: Yaochenxu
# date: 2017/09/21
###################################
import logging

from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.GetEmployeeInfoList')


def get_employee_info_list():
    from Entity import DBTransaction
    logger.info('get_employee_info_list() start.')
    try:

        # 社員ID、パラメータの年月により、当月の勤務情報を取得
        db_session = DBTransaction.session_open()
        enterprise_id = g.user.enterprise_id
        user_info_list = []

        #user_info_list = db_session.session.execute("select enterprise_id, employee_id  from users where employee_id = '{employeeId}'".format(**vars())).fetchall()
        user_info_results = db_session.session.execute(
            " SELECT"
            "    users.enterprise_id as users_enterprise_id,"
            "    users.employee_id as users_employee_id,"
            "    users.name as users_login_name,"
            "    users.auth_id as users_auth_id,"
            "    users.last_login_at as users_last_login_at,"
            "    users.valid as users_valid,"
            "    employees.name_jp as employees_name_jp,"
            "    employees.resident_addr as employees_resident_addr,"
            "    employees.mail_addr as employees_mail_addr,"
            "    employees.mobile as employees_mobile,"
            "    date_format(employments.start_date, '%Y-%c-%d') as employments_start_date,"
            "    date_format(employments.end_date, '%Y-%c-%d') as employments_end_date,"
            "    employments.emp_type as employments_emp_type,"
            "    employments.department_id as employments_department_id,"
            "    employments.section_id as employments_section_id,"
            "    date_format(dispatches.start_date, '%Y-%c-%d') as dispatches_start_date,"
            "    date_format(dispatches.end_date, '%Y-%c-%d') as dispatches_end_date,"
            "    dispatches.work_start_time as dispatches_work_start_time,"
            "    dispatches.work_end_time as dispatches_work_end_time,"
            "    dispatches.day_break_minutes as dispatches_except_minutes"
            " FROM users "
            " JOIN employees ON "
            "      users.enterprise_id = employees.enterprise_id AND users.employee_id = employees.employee_id"
            " JOIN employments ON "
            "      users.enterprise_id = employments.enterprise_id AND users.employee_id = employments.employee_id"
            " JOIN dispatches ON "
            "      users.enterprise_id = dispatches.enterprise_id AND users.employee_id = dispatches.employee_id"
            " WHERE users.enterprise_id = '{enterprise_id}'".format(**vars()))
        for rows in user_info_results:
            user_info_list.append(dict(rows))
            #print rows["users_employee_id"]
            #print user_info_list

        logger.info('get_employee_info_list() end.')
        return (jsonify(
            {'result_code': 0,
             'user_info_list': user_info_list}))
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9})
    finally:
        DBTransaction.session_close()
