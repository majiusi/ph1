//
//  EditMonthlyDataViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import "EditMonthlyDataViewController.h"
#import "WebServiceAPI.h"

@interface EditMonthlyDataViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *exceptTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *workDateLab;
- (IBAction)updateReport:(UIButton *)sender;
- (IBAction)updateCancle:(UIButton *)sender;

@end

@implementation EditMonthlyDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    
    self.workDateLab.text = self.workDate;
    
    if(self.strStartTime.length > 5) self.strStartTime = [self.strStartTime substringToIndex:5];
    NSString *strDefalutWorkStartTime = [NSString stringWithFormat:@"＜      開始：%@      ＞",self.strStartTime];
    [self.startTimeBtn setTitle:strDefalutWorkStartTime forState:UIControlStateNormal];
    
    if(self.strEndTime.length > 5) self.strEndTime = [self.strEndTime substringToIndex:5];
    NSString *strDefalutWorkEndTime = [NSString stringWithFormat:@"＜      終了：%@      ＞",self.strEndTime];
    [self.endTimeBtn setTitle:strDefalutWorkEndTime forState:UIControlStateNormal];
    
    int intDefalutWorkExceptTime = [self.strExceptTime intValue];
    int hour = intDefalutWorkExceptTime / 60;
    int minut = intDefalutWorkExceptTime % 60;
    NSString *strDefalutWorkExceptTime = [NSString stringWithFormat:@"＜      控除：%02d:%02d      ＞",hour, minut];
    [self.exceptTimeBtn setTitle:strDefalutWorkExceptTime forState:UIControlStateNormal];
    
    // calculate total time
    self.strTotalMinute = [self dateTimeDifferenceWithStartTime:self.strStartTime endTime:self.strEndTime exceptTime:self.strExceptTime];
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
    self.totalTime.text = [NSString stringWithFormat:@"合計：%02d：%02d",house,minute];
    
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        // create NSDateFormatter instance and set time format
        [dateFormat setDateFormat:@"HH:mm"];
        // show the time in startTimeBtn
        self.strStartTime = [dateFormat stringFromDate:datePicker.date];
        NSString *strDefalutWorkStartTime = [NSString stringWithFormat:@"＜      開始：%@      ＞",self.strStartTime];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        // create NSDateFormatter instance and set time format
        [dateFormat setDateFormat:@"HH:mm"];
        // show the time in endTimeBtn
        self.strEndTime = [dateFormat stringFromDate:datePicker.date];
        NSString *strDefalutWorkEndTime = [NSString stringWithFormat:@"＜      終了：%@      ＞",self.strEndTime];
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
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        // create NSDateFormatter instance and set time format
        [dateFormat setDateFormat:@"HH:mm"];
        // show the time in exceptTimeBtn
        self.strExceptTime = [dateFormat stringFromDate:datePicker.date];
        NSString *strDefalutWorkExceptTime = [NSString stringWithFormat:@"＜      控除：%@      ＞",self.strExceptTime];
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
    
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"サービスが異常終了になりました。" preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                // return to before window
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            //show dialog box
            [self presentViewController:alert animated:true completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"修正完了" preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // return to before window
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            //show dialog box
            [self presentViewController:alert animated:true completion:nil];
        }
    } failBlock:^(int statusCode, int errorCode) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"サービスの利用ができません。" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // return to before window
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        //show dialog box
        [self presentViewController:alert animated:true completion:nil];
        
    }] updateWorkReportInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withUpdateDate:self.workDate withStartTime:self.strStartTime withEndTime:self.strEndTime withExclusiveMinutes:self.strExceptTime withTotalMinutes:self.strTotalMinute];
}

- (IBAction)updateCancle:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
