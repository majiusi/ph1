//
//  WebServiceAPI.m
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 maiasoft. All rights reserved.
//

#import "WebServiceAPI.h"
#import "HttpResponseErrorCode.h"

@implementation WebServiceAPI
- (id)initWithFinishBlock:(void (^)(id))finishBlockToRun failBlock:(void (^)(int, int))failBlockToRun{
    self = [super init];
    if (self){
        self.finishBlock = finishBlockToRun;
        self.failBlock = failBlockToRun;
    }
    return self;
}

+ (WebServiceAPI *) requestWithFinishBlock:(void (^)(id))finishBlockToRun failBlock:(void (^)(int, int))failBlockToRun{
    return [[WebServiceAPI alloc] initWithFinishBlock:finishBlockToRun failBlock:failBlockToRun];
}

- (void) doLoginGetTokenWithEnterpriseId:(NSString *)enterpriseId withUserName:(NSString *)userName withPassword:(NSString *)password{
    
    NSString * url = [NSString stringWithFormat:@"http://127.0.0.1:5000/api/MAS0000010"];
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
