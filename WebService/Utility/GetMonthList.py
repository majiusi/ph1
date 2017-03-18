# -*- coding: utf-8 -*-
# !/usr/bin/env python
###################################
# description: 指定月の全ての日付リストの取得
# author: Yaochenxu
# date: 2017/03/05
###################################
import datetime
import calendar


def get_month_days(begin_year, begin_month):
    date_list = []
    if len(begin_month) < 2:
        begin_month = "0" + begin_month
    begin_date = datetime.datetime.strptime(str(begin_year) + str(begin_month) + "01", "%Y%m%d")
    month_range = calendar.monthrange(int(begin_year), int(begin_month))
    end_date = datetime.datetime.strptime(str(begin_year) + str(begin_month) + str(month_range[1]), "%Y%m%d")
    while begin_date <= end_date:
        date_str = begin_date.strftime("%Y-%m-%d")
        date_list.append(date_str)
        begin_date += datetime.timedelta(days=1)
    return date_list
