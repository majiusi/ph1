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
- (IBAction)LoginButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *EnterpriseID;
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UILabel *ErrorMessage;
- (IBAction)ResetPasswd:(UIButton *)sender;

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
    //NSString * url = [NSString stringWithFormat:@"http://54.199.240.10/api/MAS0000010"];
//    NSString * url = [NSString stringWithFormat:@"http://127.0.0.1:5000/api/MAS0000010"];
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
//    params[@"enterprise_id"] = self.EnterpriseID.text;
//
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//   
//    manager.securityPolicy.allowInvalidCertificates = NO;
//    manager.securityPolicy.validatesDomainName = NO;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.UserName.text password:self.Password.text];
//    
//    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
//        NSLog(@"JSON:%@",responseObject);
//        
//        NSNumber *resultCodeObj = [responseObject objectForKey:@"result_code"];
//        if ([resultCodeObj integerValue] < 0)
//        {
//            self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
//        } else {
//            
//            NSUserDefaults  * userDefault = [NSUserDefaults standardUserDefaults];
//            [userDefault setObject:[responseObject objectForKey:@"token"] forKey:@"token"];
//            
//            
//            [userDefault setInteger:1 forKey:@"nextPage"];
//            
//            UITabBarController *tabControl = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginAfter"];
//            [self.navigationController pushViewController:tabControl animated:YES];
//        }
//        
//    } failure:^(NSURLSessionDataTask * task, NSError * error) {
//        self.ErrorMessage.text = @"企業ID、ユーザID、パスワード不正";
//    }];
    
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
