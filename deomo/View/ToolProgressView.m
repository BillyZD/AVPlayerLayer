//
//  ToolProgressView.m
//  deomo
//
//  Created by 张冬 on 2017/12/26.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import "ToolProgressView.h"
#import "ZDSlider.h"

@interface ToolProgressView()
/// 全屏的button
@property(nonatomic , strong)UIButton *fullButton;
/// 暂停或者播放的button
@property(nonatomic ,strong)UIButton *playButton;
/// 播放进度条
@property(nonatomic , strong)ZDSlider *slider;
/// 进度条是否正在被触摸
@property(nonatomic , assign)BOOL isSeeking;
/// 显示时间的lab
@property(nonatomic , strong)UILabel *timeLab;
@end

@implementation ToolProgressView

/// 播放的进度条工具view
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        [self configUI];
        [self configSliderAction];
    }
    return self;
}
#pragma mark - configUI
-(void)configUI {
    // 设置半透明
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview: self.fullButton];
    [self addSubview: self.playButton];
    [self addSubview: self.slider];
    [self addSubview: self.timeLab];
    NSDictionary *vd = @{@"fullButton": self.fullButton , @"playButton": self.playButton , @"slider": self.slider , @"timeLab": self.timeLab};
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"|[playButton(60)]-10-[slider]-10-[timeLab]-10-[fullButton(60)]|" options:0 metrics: nil views: vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[fullButton]|" options: 0 metrics: nil views: vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[playButton]|" options:0 metrics: nil views: vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[slider]|" options:0 metrics: nil views: vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[timeLab]|" options:0 metrics: nil views: vd]];
}

#pragma  mark - logic
/// 设置全屏button的状态
-(void)setButtonFullStatus:(BOOL)isFull {
    self.fullButton.selected = isFull;
}
/// 全屏button的点击事件
-(void)fullButtonClick: (UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.isFullBlock) {
        [self setButtonFullStatus: sender.selected];
        self.isFullBlock(sender.selected);
    }
}
/// 暂停或者播放的button的点击事件
-(void)playButtonClick: (UIButton *)sender {
    if (self.isPlayBlock) {
        self.isPlayBlock(!sender.selected);
    }
}
/// 设置播放按钮的状态
-(void)setPlayButtonStatus:(BOOL)isPlaying {
    self.playButton.selected = isPlaying;
}
/// 加载的进度
-(void)setLoadValue:(float)loadVaue {
    self.slider.loadValue = loadVaue;
}
/// 当前播放的时间
-(void)setCurrenPlayTime:(float)playTime {
    self.slider.progressValue = playTime;
}
/// 总的时间
-(void)setTotalPlayTime:(float)totalTime {
    self.slider.progressMaxmumValue = totalTime;
    [self setCurrentTime:0 AndTotalTime: totalTime];
}
/// 拖动了
-(void)progressSliderValueChange: (UISlider *)slider {
    if (self.sliderValueChangeBlock) {
        self.sliderValueChangeBlock(slider.value);
    }
}
/// 触摸进度条
-(void)progressSliderTouchBegan: (UISlider *)slider {
    NSLog(@"进度条触摸了");
    self.isSeeking = YES;
    if (self.touchBeganBlock) {
        self.touchBeganBlock();
    }
}
/// 进度条停止触摸
-(void)progressSliderTouchEnd: (UISlider *)slider {
    NSLog(@"停止触摸进度条");
    self.isSeeking = NO;
    if (self.touchEndBlock) {
        self.touchEndBlock(slider.value);
    }
}
/// 设置时间显示
-(void)setCurrentTime: (float)currentTime AndTotalTime: (float)totalTime {
    self.timeLab.text = [NSString stringWithFormat: @"%@/%@",[self handleShowTimeStr: currentTime] , [self handleShowTimeStr: totalTime]];
}
/// 时间显示的处理
-(NSString *)handleShowTimeStr: (float)time {
    // 分钟
    int minute = time/60;
    // 秒数
    int second = (int)time%60;
    return [NSString stringWithFormat:@"%02d:%02d" , minute , second];
}
/// 配置进度条触摸事件
-(void)configSliderAction {
    [self.slider addTarget: self action:@selector(progressSliderValueChange:) forControlEvents:UIControlEventValueChanged | UIControlEventTouchDragInside];
    [self.slider addTarget:self action: @selector(progressSliderTouchBegan:) forControlEvents: UIControlEventTouchDown];
    [self.slider addTarget:self action: @selector(progressSliderTouchEnd:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
}
/// 设置进度条是否响应触摸事件
-(void)setSliderInterac: (BOOL)interac {
    self.slider.userInteractionEnabled = interac;
}
#pragma mark - set and get
-(ZDSlider *)slider {
    if (!_slider) {
        _slider = [[ZDSlider alloc] init];
        _slider.translatesAutoresizingMaskIntoConstraints = false;
        _slider.progressMinmumValue = 0;
    }
    return _slider;
}
-(UIButton *)fullButton {
    if (!_fullButton) {
        _fullButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _fullButton.translatesAutoresizingMaskIntoConstraints = false;
        [_fullButton setImage: [UIImage imageNamed: @"full"] forState: UIControlStateNormal];
        [_fullButton setImage: [UIImage imageNamed: @"noFull"] forState: UIControlStateSelected];
        [_fullButton addTarget: self  action: @selector(fullButtonClick:) forControlEvents: UIControlEventTouchUpInside];
    }
    return _fullButton;
}
-(UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _playButton.translatesAutoresizingMaskIntoConstraints = false;
        _playButton.selected = true;
        [_playButton addTarget: self action: @selector(playButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [_playButton setImage: [UIImage imageNamed: @"video-play"] forState: UIControlStateNormal];
        [_playButton setImage: [UIImage imageNamed: @"video-pause"] forState: UIControlStateSelected];
    }
    return _playButton;
}
-(UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        [_timeLab sizeToFit];
        _timeLab.translatesAutoresizingMaskIntoConstraints = false;
        _timeLab.font = [UIFont systemFontOfSize: 12];
        _timeLab.textColor = [UIColor whiteColor];
    }
    return _timeLab;
}








@end
