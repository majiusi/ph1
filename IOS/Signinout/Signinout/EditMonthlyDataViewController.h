//
//  EditMonthlyDataViewController.h
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMonthlyDataViewController : UIViewController
@property (nonatomic, strong) NSString *workDate;
@property (nonatomic, strong) NSString *strStartTime;
@property (nonatomic, strong) NSString *strEndTime;
@property (nonatomic, strong) NSString *strExceptTime;
@property (nonatomic, strong) NSString *strTotalMinute;
@property (nonatomic, strong) NSString *strDefaultStartTime;
@property (nonatomic, strong) NSString *strDefaultEndTime;
@property (nonatomic, strong) NSString *strDefaultExceptTime;
@end
