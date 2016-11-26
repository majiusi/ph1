import os
import logging.config

conf_file = os.path.split(os.path.realpath(__file__))[0] + '/logging.conf'
logging.config.fileConfig(conf_file)

SECRET_KEY = 'the key of maiasoft 2016-2017.'
SQLALCHEMY_DATABASE_URI = 'mysql://dbuser:Admin001@localhost/maiaDB'
SQLALCHEMY_POOL_SIZE = 500
SQLALCHEMY_COMMIT_ON_TEARDOWN = True
SQLALCHEMY_TRACK_MODIFICATIONS = True
