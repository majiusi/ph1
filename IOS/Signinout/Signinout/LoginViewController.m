//
//  LoginViewController.m
//  Signinout
//
//  Created by yaochenxu on 2016/11/26.
//  Copyright © 2016年 maiasoft. All rights reserved.
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ErrorMessage.text = @"";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)LoginButton:(UIButton *)sender {
    self.ErrorMessage.text = @"";
    [[WebServiceAPI requestWithFinishBlock:^(id object) {
        NSNumber *resultCodeObj = [object objectForKey:@"result_code"];
        if ([resultCodeObj integerValue] < 0)
        {
            self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
        } else {
            NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[object objectForKey:@"token"] forKey:@"token"];
            [userDefault setObject:self.EnterpriseID.text forKey:@"enterpriseId"];
            [userDefault setObject:self.UserName.text forKey:@"userName"];
            
//            [userDefault setInteger:1 forKey:@"nextPage"];
            
            UITabBarController *tabControl = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginAfter"];
            [self.navigationController pushViewController:tabControl animated:YES];
        }
    } failBlock:^(int statusCode, int errorCode) {
        self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
        
    }] doLoginGetTokenWithEnterpriseId:self.EnterpriseID.text withUserName:self.UserName.text withPassword:self.Password.text];
    
    
    
}
- (IBAction)ResetPasswd:(UIButton *)sender {
}
@end
