# -*- coding: utf-8 -*-
# !/usr/bin/env python
from flask import Flask, jsonify, make_response
from flask_httpauth import HTTPBasicAuth

from BL import *
from Utility import *

# initialization
app = Flask(__name__)
app.config.from_object('config')

# extensions
auth = HTTPBasicAuth()


# authentication callback method
@auth.verify_password
def verify_password(username_or_token, password):
    isPassed = UserAuth.LonginAuth.verify_password(username_or_token, password)
    return isPassed


@auth.error_handler
def unauthorized():
    return make_response(jsonify({'result_code': -999}), 401)


####################################################################
# WebService　URI声明（BL ロジック呼出し開始）
####################################################################

########################################################
# 社員用 Service
################

# ログイン認証を行い、トーケンを戻す
@app.route('/api/MAS0000010', methods=['POST'])
@auth.login_required
def get_auth_token():
    # トーケン有効期間ディフォルト一年
    token = UserAuth.LonginAuth.generate_auth_token()
    return jsonify({'result_code': 0, 'token': token.decode('ascii'), 'duration': 60 * 60 * 24 * 365})


# 画面表示フラグ取得
@app.route('/api/MAS0000020', methods=['POST'])
@auth.login_required
def get_next_page_flag():
    return GetNextPageFlag.get_next_page_flag()


# 社員＆勤務基本情報取得
@app.route('/api/MAS0000030', methods=['POST'])
@auth.login_required
def get_employee_info():
    return GetEmployeeInfo.get_employee_info()


# 月間勤務情報取得
@app.route('/api/MAS0000040', methods=['POST'])
@auth.login_required
def get_attendance_info_by_year_month():
    return GetAttendanceInfo.get_attendance_info_by_year_month()


# パンチ開始情報submit
@app.route('/api/MAS0000050', methods=['POST'])
@auth.login_required
def insert_attendance_work_start_info():
    return ModifyAttendanceInfo.insert_attendance_work_start_info()


# パンチ終了情報submit
@app.route('/api/MAS0000060', methods=['POST'])
@auth.login_required
def update_attendance_work_end_info():
    return ModifyAttendanceInfo.update_attendance_work_end_info()


# レポート出勤情報submit
@app.route('/api/MAS0000070', methods=['POST'])
@auth.login_required
def update_attendance_report_info():
    return ModifyAttendanceInfo.update_attendance_report_info()


# レポート出勤情報更新
@app.route('/api/MAS0000071', methods=['POST'])
@auth.login_required
def update_attendance_report_info_by_date():
    return ModifyAttendanceInfo.update_attendance_report_info_by_date()


# レポート出勤情報削除
@app.route('/api/MAS0000072', methods=['POST'])
@auth.login_required
def delete_attendance_report_info_by_date():
    return ModifyAttendanceInfo.delete_attendance_report_info()


# パスワード更新(社員用)
@app.route('/api/MAS0000080', methods=['POST'])
@auth.login_required
def change_password_for_employee():
    return ChangeUserPwd.change_password_for_employee()


########################################################
# 管理者用 Service
################
# パスワード更新(管理者用)
@app.route('/api/MAS1000010', methods=['POST'])
@auth.login_required
def change_password_for_Manager():
    return ChangeUserPwd.change_password_for_Manager()


# ユーザー新規登録
@app.route('/api/MAS1000020', methods=['POST'])
@auth.login_required
def new_user():
    return CreateUser.create_user()

# ============
@app.route('/api/MAS1000030', methods=['POST'])
@auth.login_required
def get_employee_info_list():
    return GetEmployeeInfoList.get_employee_info_list()

####################################################################
# WebService　URI声明（BL ロジック呼出し終了）
####################################################################

########################################test############################

if __name__ == '__main__':
    app.run(debug=False)

    # app.run(host='0.0.0.0',port=8008)
    # app.run(host='0.0.0.0',port=808,debug=True)
