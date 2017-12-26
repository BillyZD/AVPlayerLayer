//
//  PlayBgView.h
//  deomo
//
//  Created by 张冬 on 2017/12/25.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 返回播放view的frame
#define PlayViewLoadSubView_Ntifiaction @"PLAYVIEW_LOADSUBVIEW_FICATION"

@interface PlayBgView : UIView
@property (nonatomic ,copy , readwrite) void (^buttonClickBock)(void);

/// 设置播放状态(根据播放状态设置按钮的状态)
-(void)setPlayStatus: (BOOL) isPlay;
/// 是否显示缓冲菊花
-(void)isBufferAnimaiton: (BOOL)show;

@end
