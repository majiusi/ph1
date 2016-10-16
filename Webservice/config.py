import logging
import logging.config

logging.config.fileConfig('logging.conf')

SECRET_KEY = 'the key of maiasoft 2016-2017.'
SQLALCHEMY_DATABASE_URI = 'mysql://dbuser:Admin001@localhost/maiaDB'
SQLALCHEMY_COMMIT_ON_TEARDOWN = True
SQLALCHEMY_TRACK_MODIFICATIONS =True

