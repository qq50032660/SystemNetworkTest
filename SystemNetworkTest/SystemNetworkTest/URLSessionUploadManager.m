//
//  URLSessionUploadManager.m
//  SystemNetworkTest
//
//  Created by fyc on 2018/11/12.
//  Copyright © 2018 FuYaChen. All rights reserved.
//

#import "URLSessionUploadManager.h"

@interface URLSessionUploadManager()

@end

@implementation URLSessionUploadManager

static URLSessionUploadManager * sessionManager = nil;
+(URLSessionUploadManager * )shareURLSessionManager{
    
    if(!sessionManager){
        
        sessionManager = [[self alloc]init];
    }
    return sessionManager;
}
- (void)uploadFileWithURL:(NSString *)url{
    //1.构建URL
    //2.创建request请求
    //NSURLRequest 不可变的 NSMutableURLRequest可变的 可以设置请求属性
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:120];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    //请求头//upload task不会在请求头里添加content-type(上传数据类型)字段
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; charset=utf-8;boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    //设置请求体
    //发送的微博需要这2个参数
    //access_token（微博令牌，根据用户名，密码生成的明文密码） status（微博内容）
    //pic (图片) ----因为图片转成字符串编码量太大如果直接拼接在URL里服务器无法识别其请求，所以要把图片数据放在请求体里
    
    //本地图片
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"桌面.jpg" ofType:nil];
    //拼接请求体
    NSData *bodyData=[self setBodydata:filePath];//（注意上面宏定义的请求体边界下面就要用上了）
    
    //3.创建网络会话
    NSURLSession *session=[NSURLSession sharedSession];
    //4.创建网络上传任务
    NSURLSessionUploadTask *dataTask=[session uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            
            NSLog(@"%@",response);//202及是发布成功
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"jsonDic:%@",jsonDic);
            NSLog(@"original_pic:%@",[jsonDic objectForKey:@"original_pic"]);
        };
    }];
    
    //5.发送网络任务
    [dataTask resume];
    
    //————————————————————————————POST请求体格式——————————————————————————————
    //这个格式比较繁琐，但是这是死格式，大家耐心看，就可以看出规律了。注意看红字分析
    
    //---->拼接成字符串，然后转成 NSData 返回
    
    /*
     HTTP请求头：
     ....
     multipart/form-data; charset=utf-8;boundary=AaB03x //上传数据类型 必须要设置其类型
     ....
     
     
     HTTP请求体：
     
     --AaB03x （边界到下一行用了换行，在oc里面 用 \r\n 来定义换一行 所以下面不要奇怪它的用法）
     Content-Disposition: form-data; name="key1"（这行到 value1 换了2行，所以，自然而然 \r\n\r\n ）
     
     value1
     --AaB03x
     Content-disposition: form-data; name="key2"
     
     value2
     --AaB03x
     Content-disposition: form-data; name="key3"; filename="file"
     Content-Type: application/octet-stream
     
     图片数据...//NSData
     --AaB03x--（结束的分割线也不要落下）
     */
    
    
}
- (NSData *)setBodydata:(NSString *)filePath
{
    //把文件转换为NSData
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    //1.构造body string
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    NSString *boundary = @"0xKhTmLbOuNdArY";

    //2.拼接body string
    //(1)access_token
    [bodyString appendFormat:@"--%@\r\n", boundary];//（一开始的 --也不能忽略）
    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n"];
    [bodyString appendFormat:@"2.00cDQNuBJKVJQC6c99b892efwRBlYB\r\n"];
    
    //(2)status
    [bodyString appendFormat:@"--%@\r\n", boundary];
    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"];
    [bodyString appendFormat:@"带图片的微博\r\n"];
    
    //(3)pic
    [bodyString appendFormat:@"--%@\r\n", boundary];
    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"file\"\r\n"];
    [bodyString appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
    
    //3.string --> data
    NSMutableData *bodyData = [NSMutableData data];
    //拼接的过程
    //前面的bodyString, 其他参数
    [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    //图片数据
    [bodyData appendData:fileData];
    //4.结束的分隔线
    NSString *endStr = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
    //拼接到bodyData最后面
    [bodyData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
    return bodyData;
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    
}
@end
