//
//  WebServiceAPI.h
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 Yaochenxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface WebServiceAPI : NSObject

@property (nonatomic, copy) void (^finishBlock) (id);
@property (nonatomic, copy) void (^failBlock) (int,int);

/**
 Initialize WebServiceAPI to set finishBlock and failBlock with instance block.
 
 @param finishBlockToRun <#finishBlockToRun description#>
 @param failBlockToRun <#failBlockToRun description#>
 @return WebServiceAPI
 */
- (id)initWithFinishBlock:(void (^)(id))finishBlockToRun failBlock:(void (^)(int,int))failBlockToRun;


/**
 Create WebServiceAPI instance and initialize finishBlock and failBlock with caller block.
 
 @param finishBlockToRun <#finishBlockToRun description#>
 @param failBlockToRun <#failBlockToRun description#>
 @return WebServiceAPI
 */
+ (WebServiceAPI *) requestWithFinishBlock:(void (^)(id object))finishBlockToRun failBlock:(void (^)(int statusCode,int errorCode))failBlockToRun;


/**
 Call Restful WebService to authenticate user's password.
 Hold a token in responseObject when the authentication is successful.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 */
- (void) doLoginGetTokenWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password;


/**
 Call Restful WebService to authenticate user's password.
 Hold a page display flag in responseObject when the authentication is successful.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 */
- (void) getPageFlagWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password;


/**
 Call Restful WebService to submit user's work start info.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 @param startLongitude <#startLongitude description#>
 @param startLatitude <#startLatitude description#>
 @param startSpotName <#startSpotName description#>
 */
- (void) submitWorkStartInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withLongitude:(NSString *)startLongitude withLatitude:(NSString *)startLatitude spotName:(NSString *)startSpotName;


/**
 Call Restful WebService to submit user's work end info.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 @param startLongitude <#startLongitude description#>
 @param startLatitude <#startLatitude description#>
 @param startSpotName <#startSpotName description#>
 */
- (void) submitWorkEndInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withLongitude:(NSString *)startLongitude withLatitude:(NSString *)startLatitude spotName:(NSString *)startSpotName;


/**
 Call Restful WebService to authenticate user's password.
 Get Employee base infomation and attendances infomation.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 */
- (void) getEmployeeBaseInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password;


/**
 Call Restful WebService to authenticate user's password.
 Get Employee monthly attendances infomation.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 */
- (void) getEmployeeMonthlyInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password withSearchYear:(NSString *)searchYear withSearchMonth:(NSString *)searchMonth;


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
- (void) submitWorkReportInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime withExclusiveMinutes:(NSString *)exclusiveMinutes withTotalMinutes:(NSString *) totalMinutes;


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
- (void) updateWorkReportInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password withUpdateDate:(NSString*)updateDate withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime withExclusiveMinutes:(NSString *)exclusiveMinutes withTotalMinutes:(NSString *) totalMinutes;


/**
 Call Restful WebService to delete user's work report info.
 
 @param enterpriseId <#enterpriseId description#>
 @param userName <#userName description#>
 @param password <#password description#>
 @param deleteWorkDate <#deleteWorkDate description#>
 */
- (void) deleteWorkReportInfoWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withDeleteDate:(NSString*)deleteWorkDate;


/**
 Call Restful WebService to change user's password.
 
 @param enterpriseId enterpriseId
 @param userName user name
 @param password old password
 @param password1 new passowrd
 @param password2 confirm password
 
 */
- (void) changePasswordWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withPassword1:(NSString*)password1 withPassword2:(NSString *)password2;

@end
