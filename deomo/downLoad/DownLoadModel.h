//
//  DownLoadModel.h
//  deomo
//
//  Created by 张冬 on 2018/1/9.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 下载状态
typedef NS_ENUM(NSInteger , DownLoadStatus) {
    /// 下载中
    DownLoadProgressStatus = 0,
    /// 下载暂停
    DownLoadPauseStatus,
    /// 下载失败
    DownLoadFaildStatus,
    /// 下载成功
    DownLoadFinish,
    /// 还没有开始下载
    DownLoadNoStartStatus,
    
};

/**
 * 下载模型
 */
@interface DownLoadModel : NSObject
/// 下载的链接
@property(nonatomic , copy)NSString *downUrl;
/// 下载的视频名称(由下载链接生成，唯一标识)
@property(nonatomic , copy )NSArray *veidoName;
/// 下载文件大小(由下载时赋值)
@property(nonatomic , assign )NSInteger filedSize;
/// 已下载的文件大小
@property(nonatomic , assign )NSInteger downSize;
/// 下载状态
@property(nonatomic , assign)DownLoadStatus downStatus;
/// 下载进度发生变化的回调
@property(nonatomic , copy)void (^progressBolck)(float progress);
/// 下载状态发生变化的回调
@property(nonatomic , copy)void (^downLoadStatusChangBolck)(DownLoadStatus status);


@end














