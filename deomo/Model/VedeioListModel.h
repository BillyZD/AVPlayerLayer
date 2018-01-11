//
//  VedeioListModel.h
//  deomo
//
//  Created by 张冬 on 2018/1/10.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  视频播放列表的模型
 */
@interface VedeioListModel : NSObject
/// 视频的名称
@property(nonatomic , copy)NSString *vedioName;
/// 视频的播放地址
@property(nonatomic , copy)NSString *vedioUrl;
/// 视频的下载状态
@property(nonatomic , assign)BOOL isDownLoad;
/// 占位图片
@property(nonatomic , strong)UIImage *placeImage;

/// 获取视频链接的第一贞
+(void)firstFrameWithVideoUrl: (NSString *)urlStr getImageBlock: (void (^)(UIImage *image))block;

@end
