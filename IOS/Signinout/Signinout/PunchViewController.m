//
//  PunchViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/08/02.
//  Copyright © 2016年 maiasoft. All rights reserved.
//

#import "PunchViewController.h"
#import "WebServiceAPI.h"
#import <CoreLocation/CoreLocation.h>

@interface PunchViewController ()<CLLocationManagerDelegate>

- (IBAction)setStartTime:(UIButton *)sender;
- (IBAction)setEndTime:(UIButton *)sender;
- (IBAction)setExceptTime:(UIButton *)sender;

- (IBAction)submitPage1:(UIButton *)sender;
- (IBAction)submitPage2:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel     *positionInfo;
@property (weak, nonatomic) IBOutlet UIButton    *submitPage1Btn;
@property (weak, nonatomic) IBOutlet UIButton    *submitPage2Btn;
@property (weak, nonatomic) IBOutlet UIStackView *page3Stack;
@property (weak, nonatomic) IBOutlet UIButton    *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton    *endTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton    *exceptTimeBtn;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PunchViewController 

NSString *strLongitude = nil;
NSString *strLatitude = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"token:%@",[userDefault stringForKey:@"token"]);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
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
    
    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error)
        {
            self.positionInfo.text = @"位置情報取得失敗";
        }
        else if([placemarks count] > 0)
        {
            CLPlacemark *placemrk = placemarks[0];
            self.positionInfo.text = placemrk.name;
        }
    }];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager error:%@",error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidAppear:(BOOL)animated{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.positionInfo.hidden = YES;
    self.submitPage1Btn.hidden = YES;
    self.submitPage2Btn.hidden = YES;
    self.page3Stack.hidden = YES;
    
    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
    
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        NSNumber *pageFlagObj = [object objectForKey:@"page_flag"];
        if ([resultCodeObj integerValue] < 0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
//            self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
        } else {
            if ([pageFlagObj integerValue] == 1)
            {
                //[self performSegueWithIdentifier:@"id1" sender:self];
                self.positionInfo.hidden = NO;
                self.submitPage1Btn.hidden = NO;
            }
            else if ([pageFlagObj integerValue] == 2)
            {
                //[self performSegueWithIdentifier:@"id2" sender:self];
                self.positionInfo.hidden = NO;
                self.submitPage2Btn.hidden = NO;
            }
            else if ([pageFlagObj integerValue] == 3)
            {
                //[self performSegueWithIdentifier:@"id2" sender:self];
                self.page3Stack.hidden = NO;
            }
        }
    } failBlock:^(int statusCode, int errorCode) {
//        self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }] getPageFlagWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"] withUserName:[userDefault stringForKey:@"token"] withPassword:@""];
}


/**
 submit work start infomation.

 @param sender <#sender description#>
 */
- (IBAction)submitPage1:(UIButton *)sender {
    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
    
    if(strLatitude != nil)
    {
        [[WebServiceAPI requestWithFinishBlock:^(id object) {
            NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
            if ([resultCodeObj integerValue] < 0)
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                //            self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
            } else {
                self.submitPage1Btn.hidden = YES;
                self.submitPage2Btn.hidden = NO;
            }
        } failBlock:^(int statusCode, int errorCode) {
            //        self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }] submitWorkStartInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withLongitude:strLongitude withLatitude:strLatitude spotName:self.positionInfo.text];
    }
    else
    {
        self.positionInfo.text = @"位置情報取得中・・・";
    }
    strLatitude = nil;
    strLongitude = nil;
}

/**
 submit work end infomation.

 @param sender <#sender description#>
 */
- (IBAction)submitPage2:(UIButton *)sender {
    NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
    
    if(strLatitude != nil)
    {
        [[WebServiceAPI requestWithFinishBlock:^(id object) {
            NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
            if ([resultCodeObj integerValue] < 0)
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                //            self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
            } else {
                self.submitPage1Btn.hidden = YES;
                self.submitPage2Btn.hidden = YES;
                self.positionInfo.hidden = YES;
                self.page3Stack.hidden = NO;
            }
        } failBlock:^(int statusCode, int errorCode) {
            //        self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }] submitWorkEndInfoWithEnterpriseId:[userDefault stringForKey:@"enterpriseId"]  withUserName:[userDefault stringForKey:@"token"] withPassword:@"" withLongitude:strLongitude withLatitude:strLatitude spotName:self.positionInfo.text];
    }
    else
    {
        self.positionInfo.text = @"位置情報取得中・・・";
    }
    strLatitude = nil;
    strLongitude = nil;
}

/**
 Show a dialog to setup report time for work start.

 @param sender <#sender description#>
 */
- (IBAction)setStartTime:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"start\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        // create NSDateFormatter instance and set time format
        [dateFormat setDateFormat:@"HH:SS"];
        NSString *timeString = [dateFormat stringFromDate:datePicker.date];
        // get and show time
        self.startTimeBtn.titleLabel.text = timeString;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}

- (IBAction)setEndTime:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"end\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        // create NSDateFormatter instance and set time format
        [dateFormat setDateFormat:@"HH:SS"];
        NSString *timeString = [dateFormat stringFromDate:datePicker.date];
        // get and show time
        self.endTimeBtn.titleLabel.text = timeString;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}

- (IBAction)setExceptTime:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"except\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        // create NSDateFormatter instance and set time format
        [dateFormat setDateFormat:@"HH:SS"];
        NSString *timeString = [dateFormat stringFromDate:datePicker.date];
        // get and show time
        self.exceptTimeBtn.titleLabel.text = timeString;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];
}


@end
