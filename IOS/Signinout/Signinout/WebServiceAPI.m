//
//  WebServiceAPI.m
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 maiasoft. All rights reserved.
//  ---------------------------------------------
//  MAS0000010  Login authenticate and get token
//  MAS0000020  Get flag for which to display
//  MAS0000030  Get the base infomation of employees and attendances
//  MAS0000040  Get the attendances infomation by monthly of employees
//  MAS0000050  Submit work start infomation
//  MAS0000060  Submit work end infomation
//  MAS0000070  Submit report infomation
//  MAS0000071  Update report infomation
//  MAS0000080  Reset password

#import "WebServiceAPI.h"
#import "HttpResponseErrorCode.h"

@implementation WebServiceAPI

static NSString * const baseUrl = @"http://127.0.0.1:5000/api/";
static NSString * const urlDoLoginGetToken     =   @"MAS0000010";
static NSString * const urlGetPageFlag         =   @"MAS0000020";
static NSString * const urlGetBaseInfo         =   @"MAS0000030";
static NSString * const urlGetMonthlyInfo      =   @"MAS0000040";
static NSString * const urlSubmitWorkStartInfo =   @"MAS0000050";
static NSString * const urlSubmitWorkEndInfo   =   @"MAS0000060";
static NSString * const urlSubmitReportInfo    =   @"MAS0000070";
static NSString * const urlUpdateReportInfo    =   @"MAS0000071";
static NSString * const urlResetPassword       =   @"MAS0000080";

/**
 Initialize WebServiceAPI to set finishBlock and failBlock with instance block.

 @param finishBlockToRun <#finishBlockToRun description#>
 @param failBlockToRun <#failBlockToRun description#>
 @return WebServiceAPI
 */
- (id)initWithFinishBlock:(void (^)(id))finishBlockToRun failBlock:(void (^)(int, int))failBlockToRun{
    self = [super init];
    if (self){
        self.finishBlock = finishBlockToRun;
        self.failBlock = failBlockToRun;
    }
    return self;
}

/**
 Create WebServiceAPI instance and initialize finishBlock and failBlock with caller block.

 @param finishBlockToRun <#finishBlockToRun description#>
 @param failBlockToRun <#failBlockToRun description#>
 @return WebServiceAPI
 */
+ (WebServiceAPI *) requestWithFinishBlock:(void (^)(id))finishBlockToRun failBlock:(void (^)(int, int))failBlockToRun{
    return [[WebServiceAPI alloc] initWithFinishBlock:finishBlockToRun failBlock:failBlockToRun];
}

/**
 Call Restful WebService to authenticate user's password.
 Hold a token in responseObject when the authentication is successful.

 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 */
- (void) doLoginGetTokenWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password{
    
    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlDoLoginGetToken];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"enterprise_id"] = enterpriseId;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = NO;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
    }];
}

/**
 Call Restful WebService to authenticate user's password.
 Hold a page display flag in responseObject when the authentication is successful.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 */
- (void) getPageFlagWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password{
    
    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlGetPageFlag];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"enterprise_id"] = enterpriseId;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = NO;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
    }];
}
@end
