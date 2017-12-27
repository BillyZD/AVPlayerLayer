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
@optional -(void)tapGestureForView;
@end

@interface PlayBgView : UIView
/// 播放按钮的点击回调
@property (nonatomic ,copy ,readwrite)void (^playbuttonClickBock)(BOOL isPlay);
/// 底部工具栏是否正在执行动画
@property (nonatomic ,assign ,readonly)BOOL isAnimation;
/// 底部工具栏显示的状态
@property (nonatomic , assign ,readonly)BOOL isToolHiddlen;
@property(nonatomic , weak)id<ToolViewDelegate> toolViewDelgate;

/// 设置播放状态(根据播放状态设置按钮的状态)
-(void)setPlayStatus: (BOOL) isPlay;
/// 是否显示缓冲菊花
-(void)isBufferAnimaiton: (BOOL)show;
/// 设置播放按钮的状态，通过当前屏幕方向
-(void)setFullButtonStatus: (BOOL)isFull;
/// 是否显示工具栏tool
-(void)hiddenToolView:(BOOL)hiddlen;


@end
