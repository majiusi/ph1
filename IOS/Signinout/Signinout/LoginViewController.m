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
    // clean saved token when login info changed
    [self.EnterpriseID addTarget:self action:@selector(TextValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.UserName addTarget:self action:@selector(TextValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.Password addTarget:self action:@selector(TextValueChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 clean saved token when login info changed

 @param sender <#sender description#>
 */
- (IBAction)TextValueChanged:(UITextField *)sender {
    [userDefault setObject:nil forKey:@"token"];
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
        HIDE_PROGRESS
    } failBlock:^(int statusCode, int errorCode) {
        // web service not available
        HIDE_PROGRESS

        if(statusCode == 401) {
            // login fail
            self.ErrorMessage.text = CONST_LOGIN_FAIL_MSG;

            SHOW_MSG_STYLE(CONST_LOGIN_FAIL_MSG, @" ")
        }
        else{
            // service fail
            self.ErrorMessage.text = CONST_SERVICE_NOT_AVAILABLE;
            
            SHOW_MSG_STYLE(CONST_SERVICE_NOT_AVAILABLE, @" ")
        }
        
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
    [self sendEmailAction];
}

- (void)sendEmailAction
{

    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        self.ErrorMessage.text = CONST_MAIL_SEND_UNSUPPORTED_MSG;
        return;
    }
    if (![mailClass canSendMail]) {
        self.ErrorMessage.text = CONST_MAIL_ACCOUNT_NULL_MSG;
        return;
    }
    
    MFMailComposeViewController *mailSender = [[MFMailComposeViewController alloc] init];
    [mailSender setMailComposeDelegate:self];
    // title
    [mailSender setSubject:CONST_MAIL_TITLE];
    // reciver
    [mailSender setToRecipients:@[@"info@maiasoft.co.jp"]];
    [mailSender setCcRecipients:@[@"yaochenxu@maiasoft.co.jp"]];
    // mail context
    NSString *emailContent = CONST_MAIL_CONTEXT;
    // is HTML?
    [mailSender setMessageBody:emailContent isHTML:NO];
    // popup view and shwo mail
    [self presentViewController:mailSender animated:YES completion:nil];
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // canceled by user
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // saved by user
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // sent by user
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // send failed
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // close mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
