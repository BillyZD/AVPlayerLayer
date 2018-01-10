//
//  DownLoadManager.h
//  deomo
//
//  Created by 张冬 on 2018/1/9.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DownLoadModel;

/**
 * 控制下载的单利模型
 */
@interface DownLoadManager : NSObject
/// 下载容器，所有下载对象
@property(nonatomic , strong , readonly)NSMutableArray *downLoadModelArr;
/// 单利初始化
+ (instancetype)sharedInstance;
/// 创建下载对象，开始下载
-(void)startDownLoadModel: (DownLoadModel *)model;

@end
