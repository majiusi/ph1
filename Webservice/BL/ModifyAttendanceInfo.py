# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: 勤務情報編集用クラス
# author: Yaochenxu
# date: 2016/10/16
###################################
import datetime
import logging

from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.ModifyAttendanceInfo')


###################################
# -description: パンチ開始情報submit
# -author: Yaochenxu
# -date: 2016/10/16
###################################
def insert_attendance_work_start_info():
    from Entity import DBTransaction, Attendances, Dispatches
    logger.info('insert_attendance_work_start_info() start.')

    try:
        # 派遣情報取得
        dispatch = Dispatches.Dispatch()
        dispatch = dispatch.query.filter_by(
            enterprise_id=g.user.enterprise_id,
            employee_id=g.user.employee_id, end_date=None).first()

        # 派遣ID
        dispatch_id = dispatch.dispatch_id

        # 出勤情報編集
        attendances = Attendances.Attendance()

        attendances.dispatch_id = dispatch_id
        attendances.enterprise_id = g.user.enterprise_id
        attendances.employee_id = g.user.employee_id
        attendances.date = datetime.datetime.now().strftime("%Y-%m-%d ")
        attendances.start_time = datetime.datetime.now()
        attendances.start_longitude = request.json.get('start_longitude')
        attendances.start_latitude = request.json.get('start_latitude')
        attendances.start_spot_name = request.json.get('start_spot_name')
        attendances.create_by = g.user.name
        attendances.create_at = datetime.datetime.now()
        attendances.update_by = g.user.name
        attendances.update_at = datetime.datetime.now()

        # 出勤情報のコミット
        DBTransaction.add_table_object(attendances)
        DBTransaction.session_commit()

        logger.info('insert_attendance_work_start_info() end.')
        return jsonify({'result_code': 0})
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9})
    finally:
        DBTransaction.session_close()


###################################
# -description: パンチ終了情報submit
# -author: Yaochenxu
# -date: 2016/10/19
###################################
def update_attendance_work_end_info():
    from Entity import DBTransaction, Attendances
    logger.info('update_attendance_work_end_info() start.')

    try:
        # 社員ID、システム日付により、当日の勤務情報を取得
        attendances = Attendances.Attendance()
        attendances = attendances.query.filter_by(
            enterprise_id=g.user.enterprise_id,
            employee_id=g.user.employee_id, date=datetime.date.today()).first()

        # 出勤情報更新
        attendances.end_time = datetime.datetime.now()
        attendances.end_longitude = request.json.get('end_longitude')
        attendances.end_latitude = request.json.get('end_latitude')
        attendances.end_spot_name = request.json.get('end_spot_name')
        attendances.update_by = g.user.name
        attendances.update_at = datetime.datetime.now()
        attendances.update_cnt += 1

        DBTransaction.session_commit()

        logger.info('update_attendance_work_end_info() end.')
        return jsonify({'result_code': 0})
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9})
    finally:
        DBTransaction.session_close()


###################################
# -description: レポート出勤情報submit
# -author: Yaochenxu
# -date: 2016/10/21
###################################
def update_attendance_report_info():
    from Entity import DBTransaction, Attendances
    logger.info('update_attendance_report_info() start.')
    try:
        # 社員ID、システム日付により、当日の勤務情報を取得
        attendances = Attendances.Attendance()
        attendances = attendances.query.filter_by(
            enterprise_id=g.user.enterprise_id,
            employee_id=g.user.employee_id, date=datetime.date.today()).first()

        # 出勤時間の前に年月日を付け
        date_string = datetime.datetime.now().strftime("%Y-%m-%d ")
        report_start_time = date_string + request.json.get('report_start_time')[0:5]
        report_end_time = date_string + request.json.get('report_end_time')[0:5]
        # 出勤情報更新
        attendances.report_start_time = datetime.datetime.strptime(report_start_time, "%Y-%m-%d %H:%M")
        attendances.report_end_time = datetime.datetime.strptime(report_end_time, "%Y-%m-%d %H:%M")
        attendances.exclusive_minutes = request.json.get('report_exclusive_minutes')
        attendances.total_minutes = request.json.get('report_total_minutes')
        attendances.update_by = g.user.name
        attendances.update_at = datetime.datetime.now()
        attendances.update_cnt += 1

        DBTransaction.session_commit()

        logger.info('update_attendance_report_info() end.')
        return jsonify({'result_code': 0})
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9})
    finally:
        DBTransaction.session_close()


###################################
# -description: レポート出勤情報更新
# -author: Yaochenxu
# -date: 2016/12/10
###################################
def update_attendance_report_info_by_date():
    from Entity import DBTransaction, Attendances, Dispatches
    logger.info('update_attendance_report_info_by_date() start.')
    try:

        # 更新日付の取得
        update_date_string = request.json.get('update_date')
        update_date = datetime.datetime.strptime(update_date_string, "%Y-%m-%d")

        if update_date > datetime.datetime.now():
            logger.error('未来日の更新ができない')
            return jsonify({'result_code': -1})

        # 一般ユーザの場合、当月しか更新できない
        # !! 権限決めてから修正要、################
        if g.user.auth_id != '2' and g.user.auth_id != '3':
            system_date = datetime.datetime.now()
            if system_date.year != update_date.year or system_date.month != update_date.month:
                logger.error('利用者は当月しか更新できない')
                return jsonify({'result_code': -2})

        # 出勤時間の前に年月日を付け
        report_start_time_string = update_date_string + ' ' + request.json.get('report_start_time')[0:5]
        report_end_time_string = update_date_string + ' ' + request.json.get('report_end_time')[0:5]

        report_start_time = datetime.datetime.strptime(report_start_time_string, "%Y-%m-%d %H:%M")
        report_end_time = datetime.datetime.strptime(report_end_time_string, "%Y-%m-%d %H:%M")
        # 控除時間、総時間の取得
        exclusive_minutes = request.json.get('report_exclusive_minutes')
        total_minutes = request.json.get('report_total_minutes')

        # 社員ID、更新日付により、当日の勤務情報を取得
        attendances = Attendances.Attendance()
        attendances = attendances.query.filter_by(
            enterprise_id=g.user.enterprise_id,
            employee_id=g.user.employee_id, date=update_date).first()

        # データが存在する場合、更新を行い
        if attendances is not None:
            # 変更履歴を作成
            update_history_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            update_history_user_id = g.user.employee_id

            # レポート開始時間変更履歴
            updated = False
            if attendances.report_start_time is None:
                updated = True
            else:
                time_compare = attendances.report_start_time - report_start_time
                if time_compare.seconds != 0:
                    updated = True

            if updated:
                update_history_field_name = 'report_start_time'
                update_history_before = attendances.report_start_time
                update_history_after = report_start_time
                log_string = make_log_string(update_history_time, update_history_user_id,
                                             update_history_field_name, update_history_before, update_history_after)
                attendances.modification_log = unicode(attendances.modification_log) + log_string
                attendances.report_start_time = report_start_time

            # レポート終了時間変更履歴
            updated = False
            if attendances.report_end_time is None:
                updated = True
            else:
                time_compare = attendances.report_end_time - report_end_time
                if time_compare.seconds != 0:
                    updated = True

            if updated:
                update_history_field_name = 'report_end_time'
                update_history_before = attendances.report_end_time
                update_history_after = report_end_time
                log_string = make_log_string(update_history_time, update_history_user_id,
                                             update_history_field_name, update_history_before, update_history_after)
                attendances.modification_log = unicode(attendances.modification_log) + log_string
                attendances.report_end_time = report_end_time

            # 控除時間変更履歴
            if attendances.exclusive_minutes != exclusive_minutes:
                update_history_field_name = 'exclusive_minutes'
                update_history_before = attendances.exclusive_minutes
                update_history_after = exclusive_minutes
                log_string = make_log_string(update_history_time, update_history_user_id,
                                             update_history_field_name, update_history_before, update_history_after)
                attendances.modification_log = unicode(attendances.modification_log) + log_string
                attendances.exclusive_minutes = exclusive_minutes

            # 総時間変更履歴
            if attendances.total_minutes != total_minutes:
                update_history_field_name = 'total_minutes'
                update_history_before = attendances.total_minutes
                update_history_after = total_minutes
                log_string = make_log_string(update_history_time, update_history_user_id,
                                             update_history_field_name, update_history_before, update_history_after)
                attendances.modification_log = unicode(attendances.modification_log) + log_string
                attendances.total_minutes = total_minutes

            # 出勤情報更新
            attendances.update_by = g.user.name
            attendances.update_at = datetime.datetime.now()
            attendances.update_cnt += 1

        # データが存在しない場合、挿入を行い
        else:
            # 派遣情報取得
            dispatch = Dispatches.Dispatch()
            dispatch = dispatch.query.filter_by(
                enterprise_id=g.user.enterprise_id,
                employee_id=g.user.employee_id, end_date=None).first()

            # 派遣ID
            dispatch_id = dispatch.dispatch_id

            # 出勤情報編集
            attendances = Attendances.Attendance()

            attendances.dispatch_id = dispatch_id
            attendances.enterprise_id = g.user.enterprise_id
            attendances.employee_id = g.user.employee_id
            attendances.date = update_date
            attendances.start_time = datetime.datetime.now()
            attendances.start_longitude = 0
            attendances.start_latitude = 0
            attendances.start_spot_name = '後追記：位置記録しない'
            attendances.modification_log = '追加データ'
            attendances.report_start_time = report_start_time
            attendances.report_end_time = report_end_time
            attendances.exclusive_minutes = exclusive_minutes
            attendances.total_minutes = total_minutes
            attendances.create_by = g.user.name
            attendances.create_at = datetime.datetime.now()
            attendances.update_by = g.user.name
            attendances.update_at = datetime.datetime.now()

            # 出勤情報の挿入
            DBTransaction.add_table_object(attendances)

        # 出勤情報のコミット
        DBTransaction.session_commit()

        logger.info('update_attendance_report_info_by_date() end.')
        return jsonify({'result_code': 0})
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9})
    finally:
        DBTransaction.session_close()


###################################
# -description: ログ情報生成
# -author: Yaochenxu
# -date: 2016/12/10
###################################
def make_log_string(update_history_time, update_history_user_id,
                    update_history_field_name, update_history_before, update_history_after):
    separator = ','
    update_history_end = '\n'

    log_string = update_history_time + separator + update_history_user_id + separator + \
                 update_history_field_name + separator + unicode(update_history_before) + separator + \
                 unicode(update_history_after) + update_history_end

    return log_string


###################################
# -description: レポート出勤情報削除
# -author: Yaochenxu
# -date: 2017/06/23
###################################
def delete_attendance_report_info():
    from Entity import DBTransaction, Attendances
    logger.info('delete_attendance_report_info() start.')
    try:
        # 社員ID、日付により、更新の勤務情報を取得
        search_ymd_string = request.json.get('delete_work_date')
        search_ymd = datetime.datetime.strptime(search_ymd_string, "%Y-%m-%d")

        if search_ymd > datetime.datetime.now():
            logger.error('未来日の更新ができない')
            return jsonify({'result_code': -1})

        # 一般ユーザの場合、当月しか更新できない
        # !! 権限決めてから修正要、################
        if g.user.auth_id != '2' and g.user.auth_id != '3':
            system_date = datetime.datetime.now()
            if system_date.year != search_ymd.year or system_date.month != search_ymd.month:
                logger.error('利用者は当月しか更新できない')
                return jsonify({'result_code': -2})

        attendances = Attendances.Attendance()
        attendances = attendances.query.filter_by(
            enterprise_id=g.user.enterprise_id,
            employee_id=g.user.employee_id, date=search_ymd).first()

        # 取得した勤務情報を削除
        DBTransaction.del_table_object(attendances)

        DBTransaction.session_commit()

        logger.info('delete_attendance_report_info() end.')
        return jsonify({'result_code': 0})
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9})
    finally:
        DBTransaction.session_close()
