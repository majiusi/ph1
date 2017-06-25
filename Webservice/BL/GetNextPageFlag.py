# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: 画面表示フラグ取得
# author: Yaochenxu
# date: 2016/10/10
###################################
import datetime
import logging

from flask import Flask, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.GetNextPageFlag')


def get_next_page_flag():
    from Entity import DBTransaction, Attendances
    logger.info('get_next_page_flag() start.')

    try:
        # 社員ID、当日の日付により、勤務情報を取得
        attendances = Attendances.Attendance()
        attendances = attendances.query.filter_by(enterprise_id=g.user.enterprise_id,
                                                  employee_id=g.user.employee_id, date=datetime.date.today()).first()

        # 次画面のフラグを算出
        if attendances is None:
            page_flag = 1
            result_code = 0
        elif attendances.start_time is not None and attendances.end_time is None:
            page_flag = 2
            result_code = 0
        elif attendances.end_time is not None and attendances.report_end_time is None:
            page_flag = 3
            result_code = 0
        elif attendances.end_time is not None and attendances.report_end_time is not None:
            page_flag = 4
            result_code = 0
        else:
            page_flag = -1
            result_code = -1

        logger.info('get_next_page_flag() end.')
        return jsonify({'result_code': result_code, 'page_flag': page_flag})
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9, 'page_flag': -1})
    finally:
        DBTransaction.session_close()
