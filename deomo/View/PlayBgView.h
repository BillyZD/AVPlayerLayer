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
/// 响应全屏
@optional -(void)forceIsfullScreen: (BOOL)isFull;
/// 点击播放器
@optional -(void)tapGestureForView;
/// 开始点击进度条
@optional -(void)touchBeganSlide;
/// 停止点击进度条
@optional -(void)touchEndSlider: (float)value;
/// 手动拖动进度条的·值发生变化
@optional -(void)sliderValeChange: (float)value;
@end

/**
 视频播放界view
*/
@interface PlayBgView : UIView
/// 播放按钮的点击回调
@property (nonatomic ,copy ,readwrite)void (^playbuttonClickBock)(BOOL isPlay);
/// 底部工具栏是否正在执行动画
@property (nonatomic ,assign ,readonly)BOOL isAnimation;
/// 底部工具栏显示的状态
@property (nonatomic , assign ,readonly)BOOL isToolHiddlen;
/// 进度条是否正在响应事件
@property (nonatomic , assign , readonly)BOOL isSeeking;
@property(nonatomic , weak)id<ToolViewDelegate> toolViewDelgate;

///(根据播放状态设置按钮的现实状态)
-(void)setPlayButtonStatus: (BOOL) isPlay;
/// 是否显示缓冲菊花
-(void)isBufferAnimaiton: (BOOL)show;
/// 设置全屏按钮的状态，通过当前屏幕方向
-(void)setFullButtonStatus: (BOOL)isFull;
/// 是否显示工具栏tool
-(void)hiddenToolView:(BOOL)hiddlen;
/// 设置toolview上面播放按钮的状态
-(void)setToolPlayingButtonStatus: (BOOL) isPlaying;
/// 设置缓冲的进度0-1
-(void)setLoadValue: (float)loadVaue;
/// 设置当前播放的时常
-(void)setCurrenPlayTime: (float)playTime;
/// 设置视频总的时常
-(void)setTotalPlayTime: (float)totalTime;
/// 设置时间显示
-(void)setCurrentTime: (float)currentTime AndTotalTime: (float)totalTime;
/// 设置进度条是否响应触摸事件
-(void)setSliderInterac: (BOOL)interac;


@end
