//
//  ToolProgressView.m
//  deomo
//
//  Created by 张冬 on 2017/12/26.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import "ToolProgressView.h"



@interface ToolProgressView()
@property(nonatomic , strong) UISlider *slider;
/// 全屏的button
@property(nonatomic , strong)UIButton *fullButton;
/// 暂停或者播放的button
@property(nonatomic ,strong)UIButton *playButton;
/// 测试
@end

@implementation ToolProgressView

/// 播放的进度条工具view
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        [self configUI];
    }
    return self;
}
#pragma mark - configUI
-(void)configUI {
    // 设置半透明
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview: self.fullButton];
    [self addSubview: self.playButton];

    NSDictionary *vd = @{@"fullButton": self.fullButton , @"playButton": self.playButton};
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"[fullButton(60)]|" options:0 metrics: nil views: vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"|[playButton(60)]" options:0 metrics: nil views: vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[fullButton]|" options: 0 metrics: nil views: vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[playButton]|" options:0 metrics: nil views: vd]];
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
    sender.selected = !sender.selected;
    if (self.isPlayBlock) {
        self.isPlayBlock(sender.selected);
    }
}
/// 设置播放按钮的状态
-(void)setPlayButtonStatus:(BOOL)isPlaying {
    self.playButton.selected = isPlaying;
}

#pragma mark - set and get
-(UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        // 设置缓冲颜色
        _slider.backgroundColor = [UIColor whiteColor];
        // 设置进度颜色
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
@end
