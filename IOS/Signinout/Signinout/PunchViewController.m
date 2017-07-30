//
//  PunchViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/08/02.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import "PunchViewController.h"
#import "WebServiceAPI.h"
#import "Constant.h"
#import "DateUtils.h"
#import <CoreLocation/CoreLocation.h>
#import <POPAnimation.h>
#import <POP.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PunchViewController ()<CLLocationManagerDelegate>

- (IBAction)setStartTime:(UIButton *)sender;
- (IBAction)setEndTime:(UIButton *)sender;
- (IBAction)setExceptTime:(UIButton *)sender;

- (IBAction)submitPage1:(UIButton *)sender;
- (IBAction)submitPage2:(UIButton *)sender;
- (IBAction)submitPage3:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel     *positionInfo;
@property (weak, nonatomic) IBOutlet UIButton    *submitPage1Btn;
@property (weak, nonatomic) IBOutlet UIButton    *submitPage2Btn;
@property (weak, nonatomic) IBOutlet UIButton    *submitPage3Btn;

@property (weak, nonatomic) IBOutlet UIStackView *page3Stack;
@property (weak, nonatomic) IBOutlet UIStackView *page4Stack;

@property (weak, nonatomic) IBOutlet UIButton    *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton    *endTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton    *exceptTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel     *userNameJP;
@property (weak, nonatomic) IBOutlet UILabel    *totalTime;

@property (weak, nonatomic) IBOutlet UILabel    *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel    *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel    *exceptTimeLab;
@property (weak, nonatomic) IBOutlet UILabel    *totalTimeLab;
@property (weak, nonatomic) IBOutlet UILabel    *submitEndMsgLab;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString  *strStartTime;
@property (nonatomic, strong) NSString  *strEndTime;
@property (nonatomic, strong) NSString  *strExceptTime;
@property (nonatomic, strong) NSString  *strTotalMinute;
@property (nonatomic, strong) NSString  *strUserNameJP;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)int countDown;


@end

static int const tick = 4;

@implementation PunchViewController 

NSString *strLongitude = nil;
NSString *strLatitude = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc {
    if (_timer) {
        [_timer invalidate];
    }
}

/**
 Get location information and set strLongitude/strLatitude.
 Get placemarks by Longitude/Latitude.

 @param manager <#manager description#>
 @param locations <#locations description#>
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currLocation = [locations lastObject];
    strLongitude = [NSString stringWithFormat:@"%3.11f", currLocation.coordinate.longitude];
    strLatitude = [NSString stringWithFormat:@"%3.11f", currLocation.coordinate.latitude];
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    
    // save Device language
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    // set to jpn
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"jpn",nil] forKey:@"AppleLanguages"];
    
    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error)
        {
            self.positionInfo.text = CONST_LOCATION_INTELLIGENCE_FAILURE;
        }
        else if([placemarks count] > 0)
        {
            for(int i=0;i<[placemarks count];i++)
            {
                // to fix show all number problem when at high speed & high floor
                CLPlacemark *placemrk = placemarks[i];
                if(![self isPureInt:placemrk.name])
                {
                    self.positionInfo.text = placemrk.name;
                    break;
                }
            }
            
            
        }
        // restore Device language
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
        
    }];

}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager error:%@",error);
}

-(void)showLikeButton
{
    
    POPSpringAnimation *spin = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    
    spin.fromValue = @(M_PI / 4);
    spin.toValue = @(0);
    spin.springBounciness = 20;
    spin.velocity = @(10);
    [self.self.submitPage1Btn.layer pop_addAnimation:spin forKey:@"likeAnimation"];
}


- (void)performAnimation
{
    
    [self.submitPage1Btn.layer pop_removeAllAnimations];
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    //anim.beginTime = CACurrentMediaTime() + 1.0f;
    anim.duration = 1.5f;
    static BOOL ani = YES;
    if (ani) {
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
    }else{
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    }
    ani = !ani;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) { [self performAnimation]; }
    };
    [self.submitPage1Btn.layer pop_addAnimation:anim forKey:@"Animation"];
    [self.submitPage2Btn.layer pop_addAnimation:anim forKey:@"Animation"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 1.Get location info and show it.
 2.Get employee base info, and show name of JP, show defalut work start/end/except time.
 3.Get and show monthly attendances infomation.
 4.show UI Controller&Info according page_flag.

 @param animated <#animated description#>
 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.locationManager startUpdatingLocation];
    
    SHOW_PROGRESS(self.navigationController.view);

    // 1.Get location info and show it.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.positionInfo.hidden = NO;
    self.submitPage1Btn.hidden = NO;
    self.submitPage2Btn.hidden = YES;
    self.page3Stack.hidden = YES;
    self.page4Stack.hidden = YES;
    
    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
    
    // 2.Get employee base info, and show name of JP, show defalut work start/end/except time.
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            // get EmployeeBaseInfo error
            //SHOW_MSG(@"", CONST_GET_EMPLOYEE_BASEINFO_ERROR, self);
            SHOW_MSG_STYLE(CONST_GET_EMPLOYEE_BASEINFO_ERROR, @" ")
            HIDE_PROGRESS
        } else {
            self.strUserNameJP = [object objectForKey:@"name_jp"];
            self.strStartTime = [object objectForKey:@"default_work_start_time"];
            NSString *strDefalutWorkStartTime = [NSString stringWithFormat:CONST_START_FORMAT,self.strStartTime];
            [self.startTimeBtn setTitle:strDefalutWorkStartTime forState:UIControlStateNormal];
            
            self.strEndTime = [object objectForKey:@"default_work_end_time"];
            NSString *strDefalutWorkEndTime = [NSString stringWithFormat:CONST_END_FORMAT, self.strEndTime];
            [self.endTimeBtn setTitle:strDefalutWorkEndTime forState:UIControlStateNormal];
            
            self.strExceptTime = [NSString stringWithFormat:@"%@",[object objectForKey:@"default_except_minutes"]];
            int intDefalutWorkExceptTime = [self.strExceptTime intValue];
            int hour = intDefalutWorkExceptTime / 60;
            int minut = intDefalutWorkExceptTime % 60;
            
            NSString *strDefalutWorkExceptTime = [NSString stringWithFormat:CONST_EXCEPT_FORMAT_3, hour, minut];
            [self.exceptTimeBtn setTitle:strDefalutWorkExceptTime forState:UIControlStateNormal];
            
            // calculate total time
            self.strTotalMinute = [self dateTimeDifferenceWithStartTime:self.strStartTime endTime:self.strEndTime exceptTime:self.strExceptTime];
            
            
            // 3.Get and show monthly attendances infomation. --- it move to [2.] better than serial
            // get NSCalendar object
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            // get system date
            NSDate* dt = [NSDate date];
            // define flags to get system year and month
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
            NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
            NSString *searchYear = [NSString stringWithFormat:@"%ld",(long)comp.year];
            NSString *searchMonth = [NSString stringWithFormat:@"%ld",(long)comp.month];
            
            [[WebServiceAPI requestWithFinishBlock:^(id object) {
                NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
                if ([resultCodeObj integerValue] < 0)
                {
                    // get EmployeeMonthlyInfo error
                    // SHOW_MSG(@"", CONST_GET_EMPLOYEE_MONTHLY_INFO_ERROR, self);
                    SHOW_MSG_STYLE(CONST_GET_EMPLOYEE_MONTHLY_INFO_ERROR, @" ")
                } else {
                    // show name and monthly work total time
                    self.userNameJP.text = [NSString stringWithFormat:CONST_NAME_AND_TOTAL_WORK_TIME_FORMAT,
                                            self.strUserNameJP, [[object objectForKey:@"total_hours"] doubleValue] / 60.0f ];
                    
                    // get today's work report info from [monthly_work_time_list]
                    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"d"];
                    NSString *strCurrentDay = [dateFormatter stringFromDate:[NSDate date]];
                    int dayIndex = [strCurrentDay intValue] - 1;
                    NSMutableArray* objects = [object objectForKey:@"monthly_work_time_list"];
                    NSMutableDictionary*  dict = objects[dayIndex];
                    // get report info from dictionary and make format to HH:MM (be used by relogin)
                    NSString* startTimeForPage4 = [dict objectForKey:@"report_start_time"];
                    NSString* endTimeForPage4 = [dict objectForKey:@"report_end_time"];
                    if([startTimeForPage4 intValue] != 0 && [startTimeForPage4 length] > 5){
                        self.strStartTime = [startTimeForPage4 substringToIndex:5];
                        if([endTimeForPage4 length] > 5) self.strEndTime = [endTimeForPage4 substringToIndex:5];
                        self.strExceptTime = [dict objectForKey:@"report_exclusive_minutes"];
                        self.strTotalMinute = [dict objectForKey:@"report_total_minutes"];
                    }
                    // show report info
                    self.startTimeLab.text = [NSString stringWithFormat:CONST_START_FORMAT, self.strStartTime];
                    self.endTimeLab.text = [NSString stringWithFormat:CONST_END_FORMAT, self.strEndTime];
                    self.exceptTimeLab.text = [NSString stringWithFormat:CONST_EXCEPT_FORMAT, self.strExceptTime];
                    double totalTemp = self.strTotalMinute.integerValue / 60.0f;
                    self.totalTimeLab.text = [NSString stringWithFormat:CONST_TOTAL_TIME_FORMAT, totalTemp];
                }
                HIDE_PROGRESS
                
            } failBlock:^(int statusCode, int errorCode) {
                // web service not available
                HIDE_PROGRESS
                //SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
                SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
                
            }] getEmployeeMonthlyInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withSearchYear:searchYear withSearchMonth:searchMonth];
        }
    } failBlock:^(int statusCode, int errorCode) {
        // web service not available
        HIDE_PROGRESS
        //SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
        SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
        
    }] getEmployeeBaseInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" ];

    RESHOW_PROGRESS
    // 4.show UI Controller&Info according page_flag.
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        NSNumber *pageFlagObj = [object objectForKey:@"page_flag"];
        if ([resultCodeObj integerValue] < 0)
        {
            // get page flag error
            //SHOW_MSG(@"", CONST_GET_PAGE_FLAG_ERROR, self);
            SHOW_MSG_STYLE(CONST_GET_PAGE_FLAG_ERROR, @" ")
        } else {
            if ([pageFlagObj integerValue] == 1)
            {
                // show page1
                self.positionInfo.hidden = NO;
                self.submitPage1Btn.hidden = NO;
                [self performAnimation];
            }
            else if ([pageFlagObj integerValue] == 2)
            {
                // hide page1
                self.submitPage1Btn.hidden = YES;
                
                // show page2
                self.positionInfo.hidden = NO;
                self.submitPage2Btn.hidden = NO;
                [self performAnimation];

            }
            else if ([pageFlagObj integerValue] == 3)
            {
                // hide page1
                self.positionInfo.hidden = YES;
                self.submitPage1Btn.hidden = YES;
                
                // start Facebook pop animation
                [self scaleAnimationStartBtn ];
                [self scaleAnimationEndBtn ];
                [self scaleAnimationExceptBtn ];
                [self scaleAnimationTotalTime ];
                [self scaleAnimationSubmitPage3Btn];
                
                // show page3
                self.page3Stack.hidden = NO;
            }
            else if ([pageFlagObj integerValue] == 4)
            {
                // hide page1
                self.positionInfo.hidden = YES;
                self.submitPage1Btn.hidden = YES;
                
                // play Facebook pop animation
                [self scaleAnimationStartLab ];
                [self scaleAnimationEndTimeLab ];
                [self scaleAnimationExceptTimeLab ];
                [self scaleAnimationTotalTimeLab ];
                [self scaleAnimationSubmitEndMsgLab ];
                
                // show page4
                self.page4Stack.hidden = NO;
                
            }
        }
        HIDE_PROGRESS

    } failBlock:^(int statusCode, int errorCode) {
        // web service not available
        HIDE_PROGRESS
        //SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
        SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
        
    }] getPageFlagWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"] withUserName:[userDefault stringForKey:@"token"] withPassword:@""];
}


/**
 submit work start infomation.

 @param sender <#sender description#>
 */
- (IBAction)submitPage1:(UIButton *)sender {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self.locationManager startUpdatingLocation];
    if (self.timer.isValid) {
        [self stopTimerForPage1];
    }
    else {
        [self startCountDownForPage1];
    }
}

/**
 submit work end infomation.

 @param sender <#sender description#>
 */
- (IBAction)submitPage2:(UIButton *)sender {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self.locationManager startUpdatingLocation];
    
    if (self.timer.isValid) {
        [self stopTimerForPage2];
    }
    else {
        [self startCountDownForPage2];
    }
}

/**
 submit work report infomation.
 
 @param sender <#sender description#>
 */
- (IBAction)submitPage3:(UIButton *)sender {
    SHOW_PROGRESS(self.navigationController.view);
    
    NSUserDefaults  *userDefault = [NSUserDefaults standardUserDefaults];
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            // WorkReportInfo submit error
            //SHOW_MSG(@"", CONST_SUBMIT_REPORT_INFO_ERROR, self);
            SHOW_MSG_STYLE(CONST_SUBMIT_REPORT_INFO_ERROR, @" ")
            HIDE_PROGRESS
        } else {
            self.startTimeLab.text = [NSString stringWithFormat:CONST_START_FORMAT, self.strStartTime];
            self.endTimeLab.text = [NSString stringWithFormat:CONST_END_FORMAT, self.strEndTime];
            self.exceptTimeLab.text = [NSString stringWithFormat:CONST_EXCEPT_FORMAT, self.strExceptTime];
            double totalTemp = self.strTotalMinute.integerValue / 60.0f;
            self.totalTimeLab.text = [NSString stringWithFormat:CONST_TOTAL_TIME_FORMAT, totalTemp];
            
            self.submitPage1Btn.hidden = YES;
            self.submitPage2Btn.hidden = YES;
            self.positionInfo.hidden = YES;
            self.page3Stack.hidden = YES;

            // play Facebook pop animation
            [self scaleAnimationStartLab ];
            [self scaleAnimationEndTimeLab ];
            [self scaleAnimationExceptTimeLab ];
            [self scaleAnimationTotalTimeLab ];
            [self scaleAnimationSubmitEndMsgLab ];
            
            self.page4Stack.hidden = NO;

            
            // show monthly attendances infomation
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            // get system date
            NSDate* dt = [NSDate date];
            // define flags to get system year and month
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
            NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
            NSString *searchYear = [NSString stringWithFormat:@"%ld",(long)comp.year];
            NSString *searchMonth = [NSString stringWithFormat:@"%ld",(long)comp.month];
            
            [[WebServiceAPI requestWithFinishBlock:^(id object) {
                NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
                if ([resultCodeObj integerValue] < 0)
                {
                    // get EmployeeMonthlyInfo error
                    //SHOW_MSG(@"", CONST_GET_EMPLOYEE_MONTHLY_INFO_ERROR, self);
                    SHOW_MSG_STYLE(CONST_GET_EMPLOYEE_MONTHLY_INFO_ERROR, @" ")
                } else {
                    // show name and monthly work total time
                    self.userNameJP.text = [NSString stringWithFormat:CONST_NAME_AND_TOTAL_WORK_TIME_FORMAT,
                                            self.strUserNameJP, [[object objectForKey:@"total_hours"] doubleValue] / 60.0f ];
                }
                HIDE_PROGRESS
            } failBlock:^(int statusCode, int errorCode) {
                // web service not available
                HIDE_PROGRESS
                //SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
                SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
                
            }] getEmployeeMonthlyInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withSearchYear:searchYear withSearchMonth:searchMonth];
        }
    } failBlock:^(int statusCode, int errorCode) {
        // web service not available
        HIDE_PROGRESS
        //SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
        SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
        
    }] submitWorkReportInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withStartTime:self.strStartTime withEndTime:self.strEndTime withExclusiveMinutes:self.strExceptTime withTotalMinutes:self.strTotalMinute];
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
        [self.submitPage3Btn setTitle:CONST_REPORT_CANNOT_UPDATE_MSG forState:UIControlStateNormal];
        self.submitPage3Btn.enabled = NO;
    }else{
        [self.submitPage3Btn setTitle:CONST_REPORT_SUBMIT_BTN forState:UIControlStateNormal];
        self.submitPage3Btn.enabled = YES;
    }
    self.totalTime.text = [NSString stringWithFormat:CONST_TOTAL_TIME_FORMAT_2, house, minute];
    
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
        NSString *strDefalutWorkExceptTime = [NSString stringWithFormat:CONST_EXCEPT_FORMAT_2,self.strExceptTime];
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

#pragma mark - countdown method area


/**
 *  start countdown for Page1
 */
-(void)startCountDownForPage1 {
    if(strLongitude != nil && [self.positionInfo.text compare:CONST_POSITION_INFO_MSG] != NSOrderedSame  && [self.positionInfo.text compare:CONST_LOCATION_INTELLIGENCE_FAILURE] != NSOrderedSame)
    {
        _countDown = tick; //< 重置计时
        
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFiredForPage1:) userInfo:nil repeats:YES]; //< 需要加入手动RunLoop，需要注意的是在NSTimer工作期间self是被强引用的
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes]; //< 使用NSRunLoopCommonModes才能保证RunLoop切换模式时，NSTimer能正常工作。
    }
    else
    {
        [self.positionInfo setText:CONST_POSITION_INFO_MSG];
    }
}

/**
 *  stop countdown for Page1
 */
- (void)stopTimerForPage1 {
    if (_timer) {
        [_timer invalidate];
        [self.submitPage1Btn setTitle:@"▶" forState:UIControlStateNormal];
    }
}

/**
 *  countdown logic for Page2
 */
    -(void)timerFiredForPage1:(NSTimer *)timer {
        
        if(_countDown == 1) {
            // reset button
            // NSLog(@"request start");
            [self.submitPage1Btn setTitle:@"▶" forState:UIControlStateNormal];
            [self stopTimerForPage1];
            
            NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
            
            //        if(strLongitude != nil && [self.positionInfo.text compare:CONST_POSITION_INFO_MSG] != NSOrderedSame)
            //        {
            // call webservice
            SHOW_PROGRESS(self.navigationController.view);
            [[WebServiceAPI requestWithFinishBlock:^(id object) {
                NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
                if ([resultCodeObj integerValue] < 0)
                {
                    // WorkStartInfo submit error
                    //SHOW_MSG(@"", CONST_SUBMIT_WORKSTART_INFO_ERROR, self);
                    SHOW_MSG_STYLE(CONST_SUBMIT_WORKSTART_INFO_ERROR, @" ")
                } else {
                    self.submitPage1Btn.hidden = YES;
                    self.submitPage2Btn.hidden = NO;
                }
                HIDE_PROGRESS
            } failBlock:^(int statusCode, int errorCode) {
                // web service not available
                HIDE_PROGRESS
                //SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
                SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
                
            }] submitWorkStartInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withLongitude:strLongitude withLatitude:strLatitude spotName:self.positionInfo.text];
            //        }
            //        else
            //        {
            //            [self.positionInfo setText:CONST_POSITION_INFO_MSG];
            //        }
            strLatitude = nil;
            strLongitude = nil;
        }else{
            
            // show countdown number
            _countDown -=1;
            [self.submitPage1Btn setTitle:[NSString stringWithFormat:@"%d", _countDown] forState:UIControlStateNormal];
            // NSLog(@"conutdown：%d",_countDown);
            
        }
    }

/**
 *  start countdown for Page2
 */
-(void)startCountDownForPage2 {
    if(strLongitude != nil && [self.positionInfo.text compare:CONST_POSITION_INFO_MSG] != NSOrderedSame && [self.positionInfo.text compare:CONST_LOCATION_INTELLIGENCE_FAILURE] != NSOrderedSame)
    {
        // reset countdown
        _countDown = tick;
        
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFiredForPage2:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    else
    {
        [self.positionInfo setText:CONST_POSITION_INFO_MSG];
    }
}

/**
 *  stop countdown for Page2
 */
- (void)stopTimerForPage2 {

        if (_timer) {
            [_timer invalidate];
            [self.submitPage2Btn setTitle:@"■" forState:UIControlStateNormal];
        }
}

/**
 *  countdown logic for Page2
 */
-(void)timerFiredForPage2:(NSTimer *)timer {
    
    if(_countDown == 1) {
        // reset button
        // NSLog(@"request start");
        [self.submitPage2Btn setTitle:@"■" forState:UIControlStateNormal];
        [self stopTimerForPage2];
        
        NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
        
        //        if(strLongitude != nil && [self.positionInfo.text compare:CONST_POSITION_INFO_MSG] != NSOrderedSame)
        //        {
        // call webservice
        SHOW_PROGRESS(self.navigationController.view);
        [[WebServiceAPI requestWithFinishBlock:^(id object) {
            NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
            if ([resultCodeObj integerValue] < 0)
            {
                // WorkEndInfo submit error
                //SHOW_MSG(@"", CONST_SUBMIT_WORKEND_INFO_ERROR, self);
                SHOW_MSG_STYLE(CONST_SUBMIT_WORKEND_INFO_ERROR, @" ")
            } else {
                self.submitPage1Btn.hidden = YES;
                self.submitPage2Btn.hidden = YES;
                self.positionInfo.hidden = YES;
                
                // start Facebook pop animation
                [self scaleAnimationStartBtn ];
                [self scaleAnimationEndBtn ];
                [self scaleAnimationExceptBtn ];
                [self scaleAnimationTotalTime ];
                [self scaleAnimationSubmitPage3Btn];
                
                self.page3Stack.hidden = NO;
                self.page4Stack.hidden = YES;
            }
            HIDE_PROGRESS
        } failBlock:^(int statusCode, int errorCode) {
            // web service not available
            HIDE_PROGRESS
            //SHOW_MSG(@"", CONST_SERVICE_NOT_AVAILABLE, self);
            SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
            
        }] submitWorkEndInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withLongitude:strLongitude withLatitude:strLatitude spotName:self.positionInfo.text];
        //        }
        //        else
        //        {
        //            [self.positionInfo setText:CONST_POSITION_INFO_MSG];
        //        }
        
        strLatitude = nil;
        strLongitude = nil;
    }else{
        // show countdown number
        _countDown -=1;
        [self.submitPage2Btn setTitle:[NSString stringWithFormat:@"%d", _countDown] forState:UIControlStateNormal];
        // NSLog(@"conutdown：%d",_countDown);
    }
}

#pragma mark - facebook pop animation block ↓
- (void) scaleAnimationStartBtn {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.10f;
    springAnimation.springBounciness = 15.0f;
    
    [self.startTimeBtn.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation1"];
    
}

- (void) scaleAnimationEndBtn {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.20f;
    springAnimation.springBounciness = 15.0f;
    
    [self.endTimeBtn.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation2"];
}
- (void) scaleAnimationExceptBtn {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.30f;
    springAnimation.springBounciness = 15.0f;
    
    [self.exceptTimeBtn.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation3"];
}

- (void) scaleAnimationTotalTime {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.40f;
    springAnimation.springBounciness = 15.0f;
    
    [self.totalTime.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation4"];
}

- (void) scaleAnimationSubmitPage3Btn {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.50f;
    springAnimation.springBounciness = 15.0f;
    
    [self.submitPage3Btn.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation5"];
}

//- (void) scaleAnimation {
//    
//    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//    springAnimation.fromValue = @(self.view.frame.origin.y - 400);
//    springAnimation.beginTime = CACurrentMediaTime();
//    springAnimation.springBounciness = 15.0f;
//    
//    [self.page4Stack.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation5"];
//}

- (void) scaleAnimationStartLab {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.10f;
    springAnimation.springBounciness = 15.0f;
    
    [self.startTimeLab.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation1"];
    
}

- (void) scaleAnimationEndTimeLab {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.20f;
    springAnimation.springBounciness = 15.0f;
    
    [self.endTimeLab.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation2"];
}
- (void) scaleAnimationExceptTimeLab {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.30f;
    springAnimation.springBounciness = 15.0f;
    
    [self.exceptTimeLab.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation3"];
}

- (void) scaleAnimationTotalTimeLab {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.40f;
    springAnimation.springBounciness = 15.0f;
    
    [self.totalTimeLab.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation4"];
}

- (void) scaleAnimationSubmitEndMsgLab {
    
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    springAnimation.fromValue = @(self.view.frame.origin.x + 400);
    springAnimation.beginTime = CACurrentMediaTime() + 0.50f;
    springAnimation.springBounciness = 15.0f;
    
    [self.submitEndMsgLab.layer pop_addAnimation:springAnimation forKey:@"SpringAnimation5"];
}


@end
