//
//  NSURLSession+resumeData.h
//  SystemNetworkTest
//
//  Created by fyc on 2018/11/12.
//  Copyright © 2018 FuYaChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSURLSession (resumeData)

- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData;

@end


