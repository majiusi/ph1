//
//  LoginViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/11/26.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import "LoginViewController.h"
#import "WebServiceAPI.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *EnterpriseID;
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UILabel *ErrorMessage;
- (IBAction)ResetPasswd:(UIButton *)sender;
- (IBAction)LoginButton:(UIButton *)sender;
@end

@implementation LoginViewController
NSUserDefaults  * userDefault;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ErrorMessage.text = @"";
    
    userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault stringForKey:@"token"]!=nil)
    {
        self.EnterpriseID.text = [userDefault stringForKey:@"enterpriseId"];
        self.UserName.text = [userDefault stringForKey:@"userName"];
        self.Password.text = @"******";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginButton:(UIButton *)sender {
    self.ErrorMessage.text = @"";
    
    // set username depending on have or not have the token
    NSString * userName = self.UserName.text;
    if([userDefault stringForKey:@"token"]!=nil) userName = [userDefault stringForKey:@"token"];
    
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
        } else {
            userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[object objectForKey:@"token"] forKey:@"token"];
            [userDefault setObject:self.EnterpriseID.text forKey:@"enterpriseId"];
            [userDefault setObject:self.UserName.text forKey:@"userName"];
            
            UITabBarController *tabControl = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginAfter"];
            [self.navigationController pushViewController:tabControl animated:YES];
        }
    } failBlock:^(int statusCode, int errorCode) {
        self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
        
    }] doLoginGetTokenWithEnterpriseId:self.EnterpriseID.text withUserName:userName withPassword:self.Password.text];
    
    
    
}
- (IBAction)ResetPasswd:(UIButton *)sender {
}
@end
