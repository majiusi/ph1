//
//  HttpResponseErrorCode.h
//  Signinout
//
//  Created by yaochenxu on 2016/12/25.
//  Copyright © 2016年 maiasoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

NSInteger       getErrorStatusCode          (NSURLSessionDataTask *task);
NSInteger       getErrorCode                (NSError *error);
NSDictionary*   getError                    (NSError *error);
