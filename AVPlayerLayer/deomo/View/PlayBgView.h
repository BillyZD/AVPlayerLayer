//
//  PlayBgView.h
//  deomo
//
//  Created by 张冬 on 2017/12/25.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ToolProgressHeight 50

@protocol ToolViewDelegate <NSObject>
@optional -(void)forceIsfullScreen: (BOOL)isFull;
@end

@interface PlayBgView : UIView
@property (nonatomic ,copy , readwrite) void (^buttonClickBock)(void);
@property(nonatomic , weak)id<ToolViewDelegate> toolViewDelgate;

/// 设置播放状态(根据播放状态设置按钮的状态)
-(void)setPlayStatus: (BOOL) isPlay;
/// 是否显示缓冲菊花
-(void)isBufferAnimaiton: (BOOL)show;
/// 是否隐藏toolView
-(void)isHiddenToolView: (BOOL)hiddlen;
/// 设置播放按钮的状态，通过当前屏幕方向
-(void)setFullButtonStatus: (BOOL)isFull;

@end
