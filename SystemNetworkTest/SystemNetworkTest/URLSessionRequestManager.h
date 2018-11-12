//
//  URLSessionRequestManager.h
//  SystemNetworkTest
//
//  Created by fyc on 2018/11/12.
//  Copyright © 2018 FuYaChen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^CompletionHandler)(id obj, int status, NSString *message);

@interface URLSessionRequestManager : NSObject

+(URLSessionRequestManager * )shareURLSessionManager;
- (void)getRequestWithUrl:(NSString *)url WithCompletionHandler:(CompletionHandler)CompletionHandler;
- (void)postRequestWithUrl:(NSString *)url WithCompletionHandler:(CompletionHandler)CompletionHandler;

@end


