# _*_ coding: utf-8 _*_
#!/usr/bin/env python
import logging
from flask import Flask, request, jsonify
from Entity import UserEntity
from itsdangerous import (TimedJSONWebSignatureSerializer
                          as Serializer, BadSignature, SignatureExpired)

# initialization
app = Flask(__name__)
app.config.from_object('config')
logger = logging.getLogger('MaiaService.BL.GetUserLaborList')

# the following is test code, 
def get_persional_labour_time_list():

    logger.info('get_persional_labour_time_list() start.')
    try:
        lablist = [
            {
                'id': 1,
                'name': u'张Yao',
                'workdate':u'2016/06/06',
                'checkin': u'08:55',
                'checkout': u'18:00'
            },
            {
                'id': 2,
                'name': u'張よう',
                'workdate':u'2016/06/07',
                'checkin': u'08:53',
                'checkout': u'18:01'
            }
        ]

        #resultList = [
        #       {
        #          'ResultCode':0,
        #          'labList':lablist
        #       }
        #]

        logger.info('get_persional_labour_time_list() end.')
        return jsonify({'ResultCode':0,'labList':lablist})
    except Exception, e:
        return (jsonify({'ResultCode':-1 }))


