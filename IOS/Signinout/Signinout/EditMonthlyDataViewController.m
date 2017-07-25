//
//  EditMonthlyDataViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import "EditMonthlyDataViewController.h"
#import "WebServiceAPI.h"
#import "Constant.h"
#import "DateUtils.h"
#import <POPAnimation.h>
#import <POP.h>

@interface EditMonthlyDataViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *exceptTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateReportBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *workDateLab;
- (IBAction)updateReport:(UIButton *)sender;
- (IBAction)deleteReport:(UIButton *)sender;

@end

@implementation EditMonthlyDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    // set default. [they will be set up by table value in future]
    if([self.strStartTime isEqualToString:@""] || [self.strStartTime isEqualToString:@"0"]) self.strStartTime = self.strDefaultStartTime;
    if([self.strEndTime isEqualToString:@""] || [self.strEndTime isEqualToString:@"0"]) self.strEndTime = self.strDefaultEndTime;
    if([self.strExceptTime isEqualToString:@""] || [self.strExceptTime isEqualToString:@"0"]) self.strExceptTime = self.strDefaultExceptTime;
    
    // show date
    self.workDateLab.text = [NSString stringWithFormat:CONST_WORK_INFO_EDIT_DATE_FORMAT, self.workDate];
    
    // to adjust time format to hh:mm.[table's value always hh:mm:ss] 
    if(self.strStartTime.length > 5) self.strStartTime = [self.strStartTime substringToIndex:5];
    NSString *strDefalutWorkStartTime = [NSString stringWithFormat:CONST_START_FORMAT, self.strStartTime];
    [self.startTimeBtn setTitle:strDefalutWorkStartTime forState:UIControlStateNormal];
    
    if(self.strEndTime.length > 5) self.strEndTime = [self.strEndTime substringToIndex:5];
    NSString *strDefalutWorkEndTime = [NSString stringWithFormat:CONST_END_FORMAT, self.strEndTime];
    [self.endTimeBtn setTitle:strDefalutWorkEndTime forState:UIControlStateNormal];
    
    int intDefalutWorkExceptTime = [self.strExceptTime intValue];
    int hour = intDefalutWorkExceptTime / 60;
    int minut = intDefalutWorkExceptTime % 60;
    NSString *strDefalutWorkExceptTime = [NSString stringWithFormat:CONST_EXCEPT_FORMAT_3, hour, minut];
    [self.exceptTimeBtn setTitle:strDefalutWorkExceptTime forState:UIControlStateNormal];
    
    // calculate total time
    self.strTotalMinute = [self dateTimeDifferenceWithStartTime:self.strStartTime endTime:self.strEndTime exceptTime:self.strExceptTime];
    
    [self scaleAnimationStartBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 calculate total minute with start/end/except time.
 
 @param startTime <#startTime description#>
 @param endTime <#endTime description#>
 @param exceptTime <#exceptTime description#>
 @return <#return value description#>
 */
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime exceptTime:(NSString *)exceptTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
        
    [date setDateFormat:@"HH:mm"];
    
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    
    //int second = (int)value %60;
    int minute = (int)value /60%60;
    int house = (int)value / 3600%3600;
    //int day = (int)value / (24 * 3600);
    
    int totalMinute = (house*60) + minute;
    totalMinute = totalMinute - [exceptTime intValue];
    
    house = totalMinute / 60;
    minute = totalMinute % 60;
    if( minute < 0 || house < 0) {
        [self.updateReportBtn setTitle:CONST_REPORT_CANNOT_UPDATE_MSG forState:UIControlStateNormal];
        self.updateReportBtn.enabled = NO;
    }else{
        [self.updateReportBtn setTitle:CONST_REPORT_UPDATE_BTN forState:UIControlStateNormal];
        self.updateReportBtn.enabled = YES;
    }
    self.totalTime.text = [NSString stringWithFormat:CONST_TOTAL_TIME_FORMAT_2, house,minute];
    
    NSString *str = [NSString stringWithFormat:@"%d",totalMinute];
    return str;
}

/**
 Show a dialog to setup report time for work start.
 
 @param sender <#sender description#>
 */
- (IBAction)setStartTime:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
    // convert defalut start time(HH:mm),
    // then show it at the dataPicker
    NSDate * startTime = [[DateUtils sharedDateUtilsByGCD] ConvertToHoursAndMinutesWithStringOfHHmm:self.strStartTime withStartYmd:@"1971/01/01" withFormat:@"yyyy/mm/dd HH:mm"];
    [datePicker setDate:startTime];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        // create NSDateFormatter instance and set time format
        [dateFormat setDateFormat:@"HH:mm"];
        // show the time in startTimeBtn
        self.strStartTime = [dateFormat stringFromDate:datePicker.date];
        NSString *strDefalutWorkStartTime = [NSString stringWithFormat:CONST_START_FORMAT, self.strStartTime];
        [self.startTimeBtn setTitle:strDefalutWorkStartTime forState:UIControlStateNormal];
        // calculate total time
        self.strTotalMinute = [self dateTimeDifferenceWithStartTime:self.strStartTime endTime:self.strEndTime exceptTime:self.strExceptTime];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}

/**
 Show a dialog to setup report time for work end.
 
 @param sender <#sender description#>
 */
- (IBAction)setEndTime:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        // create NSDateFormatter instance and set time format
        [dateFormat setDateFormat:@"HH:mm"];
        // show the time in endTimeBtn
        self.strEndTime = [dateFormat stringFromDate:datePicker.date];
        NSString *strDefalutWorkEndTime = [NSString stringWithFormat:CONST_END_FORMAT, self.strEndTime];
        [self.endTimeBtn setTitle:strDefalutWorkEndTime forState:UIControlStateNormal];
        // calculate total time
        self.strTotalMinute = [self dateTimeDifferenceWithStartTime:self.strStartTime endTime:self.strEndTime exceptTime:self.strExceptTime];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
    
}

/**
 Show a dialog to setup report time for except.
 
 @param sender <#sender description#>
 */
- (IBAction)setExceptTime:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
    // convert defalut except total minute to hour and minutes.
    // then show it at the dataPicker
    NSDate * exceptTime = [[DateUtils sharedDateUtilsByGCD] ConvertToHoursAndMinutesWithTotalMinutes:[self.strExceptTime intValue] withStartYmd:@"1971/01/01" withFormat:@"yyyy/mm/dd HH:mm"];
    [datePicker setDate:exceptTime];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        // create NSDateFormatter instance and set time format
        [dateFormat setDateFormat:@"HH:mm"];
        // show the time in exceptTimeBtn
        self.strExceptTime = [dateFormat stringFromDate:datePicker.date];
        NSString *strDefalutWorkExceptTime = [NSString stringWithFormat:CONST_EXCEPT_FORMAT_2, self.strExceptTime];
        [self.exceptTimeBtn setTitle:strDefalutWorkExceptTime forState:UIControlStateNormal];
        
        // convert time to minutes
        NSArray *array = [self.strExceptTime componentsSeparatedByString:@":"];
        int intExceptTime = [array[0] intValue] * 60 + [array[1] intValue];
        self.strExceptTime = [NSString stringWithFormat:@"%d",intExceptTime];
        
        // calculate total time
        self.strTotalMinute = [self dateTimeDifferenceWithStartTime:self.strStartTime endTime:self.strEndTime exceptTime:self.strExceptTime];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateReport:(UIButton *)sender {
    SHOW_PROGRESS(self.navigationController.view);
    
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] == -1)
        {
            SHOW_MSG(CONST_CHANGE_WORK_REPORT_FAIL_TITLE, CONST_CHANGE_FUTURE_DATE_MSG, self);
        }
        else if ([resultCodeObj integerValue] == -2)
        {
            SHOW_MSG(CONST_CHANGE_WORK_REPORT_FAIL_TITLE, CONST_CHANGE_NOT_CURRENT_MONTH_MSG, self);
        }
        else if ([resultCodeObj integerValue] < -2)
        {
            // change work report fail
            SHOW_MSG(CONST_CHANGE_WORK_REPORT_FAIL_TITLE, CONST_CHANGE_WORK_REPORT_FAIL_MSG, self);
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"修正完了。" preferredStyle: UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // return to before window
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            //show dialog box
            [self presentViewController:alert animated:true completion:nil];
        }
        HIDE_PROGRESS
    } failBlock:^(int statusCode, int errorCode) {
        // web service not available
        HIDE_PROGRESS
        SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
        
    }] updateWorkReportInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withUpdateDate:self.workDate withStartTime:self.strStartTime withEndTime:self.strEndTime withExclusiveMinutes:self.strExceptTime withTotalMinutes:self.strTotalMinute];
}

- (IBAction)deleteReport:(UIButton *)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"削除しますか" preferredStyle: UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"削除する" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // to be delete
        SHOW_PROGRESS(self.navigationController.view);
        
        NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
        
        [[WebServiceAPI requestWithFinishBlock:^(id object) {
            NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
            if ([resultCodeObj integerValue] == -1)
            {
                SHOW_MSG(CONST_DELETE_WORK_REPORT_FAIL_TITLE, CONST_DELETE_FUTURE_DATE_MSG, self);
            }
            else if ([resultCodeObj integerValue] == -2)
            {
                SHOW_MSG(CONST_DELETE_WORK_REPORT_FAIL_TITLE, CONST_DELETE_NOT_CURRENT_MONTH_MSG, self);
            }
            else if ([resultCodeObj integerValue] < -2)
            {
                // change work report fail
                SHOW_MSG(CONST_DELETE_WORK_REPORT_FAIL_TITLE, CONST_DELETE_WORK_REPORT_FAIL_MSG, self);
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"削除完了。" preferredStyle: UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // return to before window
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }]];
                //show dialog box
                [self presentViewController:alert animated:true completion:nil];
            }
            HIDE_PROGRESS
        } failBlock:^(int statusCode, int errorCode) {
            // web service not available
            HIDE_PROGRESS
            SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
            
        }] deleteWorkReportInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"] withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withDeleteDate:self.workDate];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // do nothing
    }]];
    //show dialog box
    [self presentViewController:alert animated:true completion:nil];
}

- (void) scaleAnimationStartBtn {
    //动画过程中取消用户的交互，防止用户重复点击
//    self.userInteractionEnabled = NO;
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    //它会先缩小到(0.5,0.5),然后再去放大到(1.0,1.0)
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    springAnimation.toValue =[NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    springAnimation.springSpeed = 1;
    springAnimation.springBounciness = 10;

    //动画结束之后的回调方法
    [springAnimation setCompletionBlock:^(POPAnimation * animation, BOOL finished) {
        
//        self.userInteractionEnabled = true;
        if (finished) {
            [self scaleAnimationUpdateBtn];
        }
    }];
    [self.startTimeBtn.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation"];
    
}

- (void) scaleAnimationUpdateBtn {
    //动画过程中取消用户的交互，防止用户重复点击
    //    self.userInteractionEnabled = NO;
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    //它会先缩小到(0.5,0.5),然后再去放大到(1.0,1.0)
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    springAnimation.toValue =[NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    springAnimation.springSpeed = 1;
    springAnimation.springBounciness = 10;
    //动画结束之后的回调方法
    [springAnimation setCompletionBlock:^(POPAnimation * animation, BOOL finished) {
        
        //        self.userInteractionEnabled = true;
        if (finished) {
            [self scaleAnimationStartBtn];
        }
    }];
    [self.updateReportBtn.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation"];
    
}


@end
