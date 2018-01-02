//
//  ToolProgressView.h
//  deomo
//
//  Created by 张冬 on 2017/12/26.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 显示视频播放底部的工具栏
 */
@interface ToolProgressView : UIView
/// 强制转屏的回调
@property(nonatomic , copy)void (^isFullBlock)(BOOL isFull);
/// 播放或者暂停的点击回调
@property(nonatomic , copy)void (^isPlayBlock)(BOOL isPlay);
/// 进度条开始被触摸的回调
@property(nonatomic , copy)void (^touchBeganBlock)(void);
/// 进度条结束触摸的回调
@property(nonatomic , copy)void (^touchEndBlock)(float currentValue);
/// 进度条的值发生改变
@property(nonatomic , copy)void (^sliderValueChangeBlock)(float value);
/// 进度条是否正在响应事件
@property(nonatomic , assign , readonly)BOOL isSeeking;
/// 设置全屏按钮的状态
-(void)setButtonFullStatus: (BOOL) isFull;
/// 设置播放按钮的状态
-(void)setPlayButtonStatus: (BOOL) isPlaying;
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
