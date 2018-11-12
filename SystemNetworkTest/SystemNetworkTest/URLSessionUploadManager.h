//
//  URLSessionUploadManager.h
//  SystemNetworkTest
//
//  Created by fyc on 2018/11/12.
//  Copyright © 2018 FuYaChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLSessionUploadManager : NSObject

+(URLSessionUploadManager * )shareURLSessionManager;
- (void)uploadFileWithURL:(NSString *)url;

@end


