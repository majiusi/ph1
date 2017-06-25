# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: ユーザ新規作成
# author: Yaochenxu
# date: 2016/10/09
###################################
import logging
import datetime

from flask import Flask, request, jsonify, g

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.CreateUser')


def create_user():
    from Entity import DBTransaction, Users
    logger.info('create_user() start.')
    try:
        # 入力値取得
        enterprise_id = request.json.get('enterprise_id')
        new_user_employee_id = request.json.get('new_user_employee_id')
        new_user_name = request.json.get('new_user_name')
        new_user_password = request.json.get('new_user_password')
        new_user_auth_id = request.json.get('new_user_auth_id')

        # 入力値検証
        if enterprise_id is None or new_user_employee_id is None or \
                        new_user_name is None or new_user_password is None or new_user_auth_id is None:
            logger.error('入力検証エラー')
            return jsonify({'result_code': -1})

        user = Users.User.query.filter_by(enterprise_id=enterprise_id, name=new_user_name).first()
        if user is not None:
            logger.error('ユーザ存在')
            return jsonify({'result_code': -2})

        # ユーザ情報作成
        newUser = Users.User(name=new_user_name)
        newUser.enterprise_id = enterprise_id
        newUser.hash_password(new_user_password)
        newUser.employee_id = new_user_employee_id
        newUser.auth_id = new_user_auth_id
        newUser.last_login_at = datetime.datetime.strptime('1900-01-01 00:00:00', '%Y-%m-%d %H:%M:%S')
        newUser.create_by = g.user.name
        newUser.update_by = g.user.name
        # ユーザ情報コミット
        DBTransaction.add_table_object(newUser)
        DBTransaction.session_commit()

        logger.info('create_user() end.')
        return jsonify({'result_code': 0, 'new_user_name': new_user_name})
    except Exception, e:
        logger.error(e)
        return jsonify({'result_code': -9, 'new_user_name': new_user_name})
    finally:
        DBTransaction.session_close()
