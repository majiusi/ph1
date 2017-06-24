//
//  WebServiceAPI.m
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//  ---------------------------------------------
//  MAS0000010  Login authenticate and get token
//  MAS0000020  Get flag for which to display
//  MAS0000030  Get the base infomation of employees and attendances
//  MAS0000040  Get the attendances infomation by monthly of employees
//  MAS0000050  Submit work start infomation
//  MAS0000060  Submit work end infomation
//  MAS0000070  Submit report infomation
//  MAS0000071  Update report infomation
//  MAS0000071  Delete report infomation
//  MAS0000080  Reset password

#import "WebServiceAPI.h"
#import "HttpResponseErrorCode.h"

@implementation WebServiceAPI

static NSString * const baseUrl = @"https://www.maiasoft.info/api/";
//static NSString * const baseUrl = @"http://localhost:5000/api/";
static NSString * const urlDoLoginGetToken     =   @"MAS0000010";
static NSString * const urlGetPageFlag         =   @"MAS0000020";
static NSString * const urlGetBaseInfo         =   @"MAS0000030";
static NSString * const urlGetMonthlyInfo      =   @"MAS0000040";
static NSString * const urlSubmitWorkStartInfo =   @"MAS0000050";
static NSString * const urlSubmitWorkEndInfo   =   @"MAS0000060";
static NSString * const urlSubmitReportInfo    =   @"MAS0000070";
static NSString * const urlUpdateReportInfo    =   @"MAS0000071";
static NSString * const urlDeleteReportInfo    =   @"MAS0000072";
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
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);

        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
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
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
    }];
}

/**
 Call Restful WebService to authenticate user's password.
 Get Employee base infomation and attendances infomation.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 */
- (void) getEmployeeBaseInfoWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password{
    
    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlGetBaseInfo];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"enterprise_id"] = enterpriseId;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
    }];
}

/**
 Call Restful WebService to authenticate user's password.
 Get Employee monthly attendances infomation.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 */
- (void) getEmployeeMonthlyInfoWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withSearchYear:(NSString *)searchYear withSearchMonth:(NSString *)searchMonth{
    
    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlGetMonthlyInfo];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    
    params[@"enterprise_id"] = enterpriseId;
    params[@"search_year"] = searchYear;
    params[@"search_month"] = searchMonth;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
    }];
}

/**
 Call Restful WebService to submit user's work start info.

 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 @param startLongitude <#startLongitude description#>
 @param startLatitude <#startLatitude description#>
 @param startSpotName <#startSpotName description#>
 */
- (void) submitWorkStartInfoWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withLongitude:(NSString *)startLongitude withLatitude:(NSString *)startLatitude spotName:(NSString *)startSpotName{
    
    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlSubmitWorkStartInfo];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"enterprise_id"] = enterpriseId;
    params[@"start_longitude"] = startLongitude;
    params[@"start_latitude"] = startLatitude;
    params[@"start_spot_name"] = startSpotName;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
    }];
}

/**
 Call Restful WebService to submit user's work end info.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 @param startLongitude <#startLongitude description#>
 @param startLatitude <#startLatitude description#>
 @param startSpotName <#startSpotName description#>
 */
- (void) submitWorkEndInfoWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withLongitude:(NSString *)startLongitude withLatitude:(NSString *)startLatitude spotName:(NSString *)startSpotName{
    
    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlSubmitWorkEndInfo];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"enterprise_id"] = enterpriseId;
    params[@"end_longitude"] = startLongitude;
    params[@"end_latitude"] = startLatitude;
    params[@"end_spot_name"] = startSpotName;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
    }];
}

/**
 Call Restful WebService to submit user's work report info.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 @param startTime <#startTime description#>
 @param endTime <#endTime description#>
 @param exclusiveMinutes <#exclusiveMinutes description#>
 @param totalMinutes <#totalMinutes description#>
 */
- (void) submitWorkReportInfoWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime withExclusiveMinutes:(NSString *)exclusiveMinutes withTotalMinutes:(NSString *) totalMinutes{
    
    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlSubmitReportInfo];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"enterprise_id"] = enterpriseId;
    params[@"report_start_time"] = startTime;
    params[@"report_end_time"] = endTime;
    params[@"report_exclusive_minutes"] = exclusiveMinutes;
    params[@"report_total_minutes"] = totalMinutes;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
    }];
}

/**
 Call Restful WebService to update user's work report info.

 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 @param updateDate <#updateDate description#>
 @param startTime <#startTime description#>
 @param endTime <#endTime description#>
 @param exclusiveMinutes <#exclusiveMinutes description#>
 @param totalMinutes <#totalMinutes description#>
 */
- (void) updateWorkReportInfoWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withUpdateDate:(NSString*)updateDate withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime withExclusiveMinutes:(NSString *)exclusiveMinutes withTotalMinutes:(NSString *) totalMinutes{
    
    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlUpdateReportInfo];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"enterprise_id"] = enterpriseId;
    params[@"update_date"] = updateDate;
    params[@"report_start_time"] = startTime;
    params[@"report_end_time"] = endTime;
    params[@"report_exclusive_minutes"] = exclusiveMinutes;
    params[@"report_total_minutes"] = totalMinutes;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
    }];
    
    
}


/**
 Call Restful WebService to delete user's work report info.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 @param deleteWorkDate <#deleteWorkDate description#>
 */
- (void) deleteWorkReportInfoWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withDeleteDate:(NSString*)deleteWorkDate{
    
    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlDeleteReportInfo];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"enterprise_id"] = enterpriseId;
    params[@"delete_work_date"] = deleteWorkDate;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
    }];
    
    
}


/**
 Call Restful WebService to change user's password.
 
 @param enterpriseId enterpriseId
 @param userName user name
 @param password old password
 @param password1 new passowrd
 @param password2 confirm password
 
 */
- (void) changePasswordWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withPassword1:(NSString*)password1 withPassword2:(NSString *)password2{

    NSString * url = [NSString stringWithFormat:@"%@%@", baseUrl,urlResetPassword];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"enterprise_id"] = enterpriseId;
    params[@"new_pwd1"] = password1;
    params[@"new_pwd2"] = password2;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        self.finishBlock(responseObject);
        [manager.session finishTasksAndInvalidate];
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSInteger statusCode = getErrorStatusCode(task);
        NSInteger errorCode = getErrorCode(error);
        NSDictionary *errorDict = getError(error);
        NSString * errorMessage = errorDict[@"message"];
        NSLog(@"error : %@", errorMessage);
        
        self.failBlock((int)statusCode, (int)errorCode);
        [manager.session finishTasksAndInvalidate];
    }];
}

@end
