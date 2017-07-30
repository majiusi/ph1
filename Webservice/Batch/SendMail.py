# -*- coding: utf-8 -*-
# !/usr/bin/env python

from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr, formataddr
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
import smtplib

def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr(( \
        Header(name, 'utf-8').encode(), \
        addr.encode('utf-8') if isinstance(addr, unicode) else addr))

def mail(uname, fpath, mailaddr):
    from_addr = 'info@maiasoft.co.jp'
    password = 'Nxy#91hT'
    to_addr = mailaddr
    smtp_server = 'smtp6.gmoserver.jp'
    
    msg = MIMEMultipart()
    msg['From'] = _format_addr(u'MAIASOFT <%s>' % from_addr)
    msg['To'] = _format_addr('%s <%s>' % (uname, to_addr))
    msg['Subject'] = Header(u'6月勤怠明細表の送付', 'utf-8').encode()
    
    # 邮件正文是MIMEText:
    mailText = u'''
%s 様

お疲れ様です。

6月の勤怠明細表を送付します。
トラブルを起こさないように、
現場の勤務時間と一致するように、ご確認ください。

もしかしたら、何か差分が発生したら、
早速該当課長まで連絡してください。

以上、宜しくお願い致します。
    ''' % uname 
    msg.attach(MIMEText(mailText, 'plain', 'utf-8'))
    
    # 添加附件就是加上一个MIMEBase，从本地读取一个File:
    #print(fpath)
    with open(fpath, 'rb') as f:
        # 设置附件的MIME和文件名，这里是png类型:
        mime = MIMEBase('excel', 'xls', filename='Workbook_201706.xls')
        # 加上必要的头信息:
        mime.add_header('Content-Disposition', 'attachment', filename='Workbook_201706.xls')
        mime.add_header('Content-ID', '<0>')
        mime.add_header('X-Attachment-Id', '0')
        # 把附件的内容读进来:
        mime.set_payload(f.read())
        # 用Base64编码:
        encoders.encode_base64(mime)
        # 添加到MIMEMultipart:
        msg.attach(mime)

    server = smtplib.SMTP(smtp_server, 25)
    server.set_debuglevel(1)
    server.login(from_addr, password)
    server.sendmail(from_addr, [to_addr], msg.as_string())
    server.quit()
if(__name__=="__main__"):
    uname = u'王  山鷹'
    fpath = '/home/maiasoft/WebService/Batch/report/勤務表_社内用/201706/派遣ID_D0001/王  山鷹_201706.xls'.decode('utf-8')
    mailaddr = 'qu.bo@maiasoft.co.jp'
    mail(uname, fpath, mailaddr)
