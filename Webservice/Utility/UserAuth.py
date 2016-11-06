# -*- coding: utf-8 -*-
#!/usr/bin/env python
###################################
#description: ログイン認証
#author: Yaochenxu
#date: 2016/10/09
###################################
import logging, datetime
from Entity import Users
from flask import Flask, request, g
from itsdangerous import (TimedJSONWebSignatureSerializer
                          as Serializer, BadSignature, SignatureExpired)

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.Utility.UserAuth')

class LonginAuth:

    @staticmethod
    def generate_auth_token(expiration=60*60*24*365):
        logger.info('generate_auth_token() start.')

        s = Serializer(app.config['SECRET_KEY'], expires_in=expiration)

        logger.info('generate_auth_token() end.')
        return s.dumps({'employee_id': g.user.employee_id})

    @staticmethod
    def verify_auth_token(token):
        logger.info('verify_auth_token() start.')

        s = Serializer(app.config['SECRET_KEY'])
        try:
            data = s.loads(token)
        except SignatureExpired:
            return None    # valid token, but expired
        except BadSignature:
            return None    # invalid token
        user = Users.User.query.get(data['employee_id'])

        logger.info('verify_auth_token() end.')
        return user

    @staticmethod
    def verify_password(username_or_token, password):
        logger.info('verify_password() start.')

        # first try to authenticate by token
        user = LonginAuth.verify_auth_token(username_or_token)
        enterprise_id = request.json.get('enterprise_id')
        if not user:
            # try to authenticate with username/password
            #user = Users.User()
            #user.clear_query_cache()
            user = Users.User.query.filter_by(
                enterprise_id=enterprise_id,name=username_or_token).first()
            if not user or not user.verify_password(password):
                return False

        user.last_login_at = datetime.datetime.now()
        user.update_user()
        g.user = user

        logger.info('enterprise_id:' + '['+ enterprise_id + ']' +
            ' User: [' +user.name + ' ]Longin Successful.')
        logger.info('verify_password() end.')
        return True


