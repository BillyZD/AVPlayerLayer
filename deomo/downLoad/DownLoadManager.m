//
//  DownLoadManager.m
//  deomo
//
//  Created by 张冬 on 2018/1/9.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import "DownLoadManager.h"
#import "DownLoadModel.h"
#import "NSString+Hash.h"

@interface DownLoadManager ()<NSURLSessionDataDelegate>
/// 下载容器，所有下载对象
@property(nonatomic , strong)NSMutableArray *downLoadModelArr;
/// 下载的任务队列容器·
@property(nonatomic , strong)NSMutableArray *downLoadTaskArr;
/// session
@property(nonatomic , strong)NSURLSession *session;

@end


@implementation DownLoadManager

#pragma mark -- init
/// 单利初始化
+(instancetype)sharedInstance{
    static DownLoadManager *downLoad = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downLoad = [[self alloc] init];
    });
    return downLoad;
}
#pragma mark -- logic
-(void)startDownLoadModel:(DownLoadModel *)model {
    [self.downLoadModelArr addObject:model];
    // 创建task
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: model.downUrl]];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest: request];
    [self.downLoadTaskArr addObject:task];
    //https://rbv01.ku6.com/wifi/o_1c08nhslb105j631jo0vltv29ckvs
    // https://rbv01.ku6.com/wifi/o_1c08nhslb105j631jo0vltv29ckvs
   // [request setValue:"" forHTTPHeaderField:"Range"]
    [task resume];
    
}
#pragma mark -- set and get
-(NSMutableArray *)downLoadModelArr {
    if (!_downLoadModelArr) {
        _downLoadModelArr = [NSMutableArray array];
    }
    return _downLoadModelArr;
}
-(NSMutableArray *)downLoadTaskArr {
    if (!_downLoadTaskArr) {
        _downLoadTaskArr = [NSMutableArray array];
    }
    return _downLoadTaskArr;
}
-(NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate: self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}
#pragma mark -- <NSURLSessionDataDelegate>
/**
 * 代理接受响应(是否允许接受服务器数据)
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"%@", dataTask.currentRequest.URL.absoluteString);
    NSString *url = dataTask.currentRequest.URL.absoluteString;
    // 文件获取大小
    NSInteger totoalFiled = response.expectedContentLength;
    NSLog(@"%ld", totoalFiled);
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: url.md5String];
    NSLog(@"%@",path);
    // 创建文件
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }else{
    }
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接受·服务器返沪的数据(多次被调用)
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSString *url = dataTask.currentRequest.URL.absoluteString;
    NSLog(@"%lu", (unsigned long)[self.downLoadTaskArr indexOfObject: dataTask]);
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: url.md5String];
    NSLog(@"%@",path);
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath: path];
    [handle seekToEndOfFile];
    [handle writeData: data];
    [handle synchronizeFile];
    [handle closeFile];
}
/**
 * 请求完毕(成功／失败)
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"失败:%@" , error.localizedDescription);
    }else{
        NSLog(@"%lu", (unsigned long)[self.downLoadTaskArr indexOfObject: task]);
        NSLog(@"下载成功");
    }
}
@end








