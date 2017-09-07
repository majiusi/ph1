# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
#description: メール送信ユーティリティ
#author: Kyoku
#date: 2017/7/23
###################################

from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.utils import parseaddr, formataddr
import smtplib
import ReportUtil

class mail(object):
    
    #メールステータス(0:社内レポート添付／1:社外レポート添付)
    _mail_status = 0

    def __init__(self):
        self.to_addr = None
        
        self._from_addr = 'info@maiasoft.co.jp'
        self._password = 'Nxy#91hT'
        self._smtp_server = 'smtp6.gmoserver.jp'

        self._server = smtplib.SMTP(self._smtp_server, 25)
        self._server.set_debuglevel(0)

    ###################################
    #description:メール送信情報設定する（添付ファイルなし）
    #parameter
    #    uname   : 宛名表示名
    #    to_addr : 宛名のメールアドレス
    #    month   : 月(MM)
    ###################################
    def getMsgText(self, uname, toAddr, month):
        #メンバー変数
        self.to_addr = toAddr
        #変数設定
        msg = None
        subject = u'%s月勤怠明細表の送付' %  month
        try:
            
            # メール本文保存用のMIMETextを作成
            mailText = _get_mail_msg(uname, month)
            msg_1 = MIMEText(mailText, 'plain', 'utf-8')
            msg_1['From'] = _format_addr(u'MAIASOFT <%s>' % self._from_addr)
            msg_1['To'] = _format_addr('%s <%s>' % (uname, self.to_addr))
            msg_1['Subject'] = Header(u'%s' % subject, 'utf-8').encode()
            msg = msg_1
        except Exception as ex:
            print('exception -> getMsgText : {0}'.format(ex))
            raise
        return msg
    
    ###################################
    #description:メール送信情報設定する（添付ファイル付け）
    #parameter
    #    uname     : 宛名表示名
    #    toAddr    : 宛名のメールアドレス
    #    dispatchId: 派遣ID
    #    year      : 年(yyyy)
    #    years     : 月(MM)
    ###################################
    def getMsgAttach(self, uname, toAddr, dispatchId, year, month):
        #メンバー変数
        self.to_addr = toAddr
        #変数設定
        msg = None
        subject = u'%s月勤怠明細表の送付' %  month
        years = '%04d%02d' % (year, month)
        fileN = 'Workbook_%s.xls' % years
        try:
            # メール本文保存用のMIMETextを作成
            mailText = _get_mail_msg(uname, month)
            msg_2 = MIMEMultipart()
            msg_2['From'] = _format_addr(u'MAIASOFT <%s>' % self._from_addr)
            msg_2['To'] = _format_addr('%s <%s>' % (uname, self.to_addr))
            msg_2['Subject'] = Header(u'%s' % subject, 'utf-8').encode()
            msg_2.attach(MIMEText(mailText, 'plain', 'utf-8'))
            
            # 添付ファイルパスを作成
            fpath = ReportUtil.getReportPath(uname, dispatchId, years, mail._mail_status)
        
            # 添付ファイル用のMIMEBaseを作成、権限は「rb」に設定
            with open(fpath, 'rb') as f:
                # ファイル名の設定
                mime = MIMEBase('excel', 'xls', filename=fileN)
                # 基本的な情報の設定
                mime.add_header('Content-Disposition', 'attachment', filename=fileN)
                mime.add_header('Content-ID', '<0>')
                mime.add_header('X-Attachment-Id', '0')
                # 添付ファイルを取込み
                mime.set_payload(f.read())
                # エンコード：Base64
                encoders.encode_base64(mime)
                # MIMEMultipartを設定
                msg_2.attach(mime)
            # 戻り値設定
            msg = msg_2
        except Exception as ex:
            print('exception -> getMsgAttach : {0}'.format(ex))
            raise
        return msg
        
    ###################################
    #description:メールサーバーに接続オープン
    ###################################
    def smtpOpen(self):
        try:
            self._server.login(self._from_addr, self._password)
        except Exception as ex:
            print('exception -> smtpOpen : {0}'.format(ex))
            raise
    
    ###################################
    #description:メール送信を行う
    ###################################
    def sendMail(self, msg):
        try:
            self._server.sendmail(self._from_addr, [self.to_addr], msg.as_string())
        except Exception as ex:
            print('exception -> sendMail : {0}'.format(ex))
            raise

    ###################################
    #description:メールサーバーに接続クローズ
    ###################################
    def smtpClose(self):
        try:
            self._server.quit()
        except Exception as ex:
            print('exception -> smtpClose : {0}'.format(ex))
            raise

###################################
#description:メール本文を取得
#parameter
#    uname:宛名
#    month:月
###################################
def _get_mail_msg(uname, month):
    # メール本文保存用のMIMETextを作成
    mailText = u'''
%s  様

お疲れ様です。

%s月の勤怠明細表を送付します。
トラブルを起こさないように、
現場の勤務時間と一致するように、ご確認ください。

もしかしたら、何か差分が発生したら、
早速該当課長まで連絡してください。

以上、宜しくお願い致します。

--------------------------
    ''' % (uname, month)
    return mailText

###################################
#description:メールアドレスフォーマット
#parameter
#    s:メールアドレス(宛名,メールアドレス)
###################################
def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr(( \
        Header(name, 'utf-8').encode(), \
        addr.encode('utf-8') if isinstance(addr, unicode) else addr))
    
###################################
#description:メイン処理
###################################
if(__name__=="__main__"):
    import datetime
    # 勤務年
    year = datetime.datetime.now().year
    # 勤務月
    month = datetime.datetime.now().month - 1
    
    to_qubo = mail()
    to_qubo.smtpOpen()

    msg = to_qubo.getMsgAttach(u'曲  波', 'qu.bo@maiasoft.co.jp', 'D0008', year, month)
    to_qubo.sendMail(msg)
#    msg = to_qubo.getMsgAttach(u'姚　晨旭', 'yaochenxu@maiasoft.co.jp', 'D0024', year, month)
#    to_qubo.sendMail(msg)
#    msg = to_qubo.getMsgAttach(u'馬　九思', 'ma.jiusi@maiasoft.co.jp', 'D0026', year, month)
#    to_qubo.sendMail(msg)
#    msg = to_qubo.getMsgAttach(u'李  理', 'ri.jet.ri@maiasoft.co.jp', 'D0009', year, month)
#    to_qubo.sendMail(msg)
#    msg = to_qubo.getMsgAttach(u'呉  翰', 'wu.han@maiasoft.co.jp', 'D0012', year, month)
#    to_qubo.sendMail(msg)
#    msg = to_qubo.getMsgAttach(u'王  山鷹', 'ousanyo@maiasoft.co.jp', 'D0001', year, month)
#    to_qubo.sendMail(msg)
#    msg = to_qubo.getMsgAttach(u'姚　小龍', 'yao.xiaolong@maiasoft.co.jp', 'D0036', year, month)

    to_qubo.smtpClose()
