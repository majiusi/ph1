# _*_ coding: utf-8 _*_
#!/usr/bin/env python
###################################
#description: ユーザ新規作成
#author: Yaochenxu
#date: 2016/10/09
###################################
import logging, datetime
from Entity import Users
from flask import Flask, request, jsonify

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.CreateUser')

def create_user():

    logger.info('create_user() start.')
    try:
        # 入力値取得
        employee_id = request.json.get('employee_id')
        user_name = request.json.get('user_name')
        password = request.json.get('password')
        auth_id = request.json.get('auth_id')
        valid = request.json.get('valid')

        # 入力値検証
        if employee_id is None or user_name is None or \
           password is None or auth_id is None:
            logger.error('入力検証エラー')
            return (jsonify({'result_code':-1}))

        user = Users.User.query.filter_by(name=user_name).first()
        if user is not None:
            logger.error('ユーザ存在')
            return  (jsonify({'result_code':-1}))

        # ユーザ作成
        newUser = Users.User(name=user_name)
        newUser.hash_password(password)
        newUser.employee_id = employee_id
        newUser.auth_id = auth_id
        newUser.last_login_at = datetime.datetime.strptime('1900-01-01 00:00:00', '%Y-%m-%d %H:%M:%S')
        newUser.valid = valid
        newUser.create_by = user_name
        newUser.update_by = user_name
        # 値挿入
        Users.User.add_user(newUser)

        logger.info('create_user() end.')
        return (jsonify({'result_code':0 ,'user_name': user_name}))
    except Exception, e:
        logger.error(e)
        return (jsonify({'result_code':-1 ,'user_name': user_name}))


