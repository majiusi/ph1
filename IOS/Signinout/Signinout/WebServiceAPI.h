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

- (id)initWithFinishBlock:(void (^)(id))finishBlockToRun failBlock:(void (^)(int,int))failBlockToRun;

+ (WebServiceAPI *) requestWithFinishBlock:(void (^)(id object))finishBlockToRun failBlock:(void (^)(int statusCode,int errorCode))failBlockToRun;

- (void) doLoginGetTokenWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password;

- (void) getPageFlagWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password;

- (void) submitWorkStartInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withLongitude:(NSString *)startLongitude withLatitude:(NSString *)startLatitude spotName:(NSString *)startSpotName;

- (void) submitWorkEndInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withLongitude:(NSString *)startLongitude withLatitude:(NSString *)startLatitude spotName:(NSString *)startSpotName;

- (void) getEmployeeBaseInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password;

- (void) getEmployeeMonthlyInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password withSearchYear:(NSString *)searchYear withSearchMonth:(NSString *)searchMonth;

- (void) submitWorkReportInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime withExclusiveMinutes:(NSString *)exclusiveMinutes withTotalMinutes:(NSString *) totalMinutes;

- (void) updateWorkReportInfoWithEnterpriseId:(NSString *) enterpriseId withUserName:(NSString *) userName withPassword:(NSString *) password withUpdateDate:(NSString*)updateDate withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime withExclusiveMinutes:(NSString *)exclusiveMinutes withTotalMinutes:(NSString *) totalMinutes;

- (void) changePasswordWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password withPassword1:(NSString*)password1 withPassword2:(NSString *)password2;

@end
