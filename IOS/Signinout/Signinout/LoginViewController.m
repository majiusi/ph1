//
//  LoginViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/11/26.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import "LoginViewController.h"
#import "WebServiceAPI.h"
#import "Constant.h"

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
    
    // show login info when next login
    userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault stringForKey:@"userName"]!=nil)
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
    SHOW_PROGRESS(self.navigationController.view);
    
    self.ErrorMessage.text = @"";
    
    // set username depending on have or not have the token
    NSString * userName = self.UserName.text;
    if([userDefault stringForKey:@"token"]!=nil) userName = [userDefault stringForKey:@"token"];
    
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            // login fail
            self.ErrorMessage.text = CONST_LOGIN_FAIL_MSG;
        } else {
            userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[object objectForKey:@"token"] forKey:@"token"];
            [userDefault setObject:self.EnterpriseID.text forKey:@"enterpriseId"];
            [userDefault setObject:self.UserName.text forKey:@"userName"];
            
            UITabBarController *tabControl = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginAfter"];
            [self.navigationController pushViewController:tabControl animated:YES];
        }
    } failBlock:^(int statusCode, int errorCode) {
        // web service not available
        self.ErrorMessage.text = CONST_SERVICE_NOT_AVAILABLE;
        
    }] doLoginGetTokenWithEnterpriseId:self.EnterpriseID.text withUserName:userName withPassword:self.Password.text];

}


/**
 close keyboard.

 @param touches <#touches description#>
 @param event <#event description#>
 */
-(IBAction)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)ResetPasswd:(UIButton *)sender {
}
@end
