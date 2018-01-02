//
//  ZDSlider.m
//  deomo
//
//  Created by 张冬 on 2017/12/29.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import "ZDSlider.h"

/**
 显示颜色的宏
 */
#define ZDColor(r, g, b, a)  [UIColor colorWithRed:(r)/233.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface ZDSlider()
/// 显示播放长度的进度
@property(nonatomic , strong)UISlider *slider;
/// 显示缓冲的进度
@property(nonatomic , strong)UIProgressView *progressView;
@end

@implementation ZDSlider
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self configUI];
    }
    return self;
}
-(void)layoutSubviews {
   
}
-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [_slider addTarget: target action: action forControlEvents: controlEvents];
}
#pragma mark - loadUI
-(void)configUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview: self.progressView];
    [self addSubview: self.slider];
    NSDictionary *vd = @{@"slider": self.slider , @"progressView": self.progressView};
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"|[slider]|" options:0 metrics: nil views:vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"|[progressView]|" options: 0 metrics: nil  views: vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"V:[slider(20)]" options: 0 metrics: nil views: vd]];
    NSLayoutConstraint *progressCenterY = [self.progressView.centerYAnchor constraintEqualToAnchor: self.centerYAnchor];
    NSLayoutConstraint *sliderCenterY = [self.slider.centerYAnchor constraintEqualToAnchor: self.centerYAnchor];
    [NSLayoutConstraint activateConstraints:@[progressCenterY , sliderCenterY]];
    [self sendSubviewToBack: self.progressView];
}
#pragma mark -set get
-(UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.translatesAutoresizingMaskIntoConstraints = false;
        //滑块划过的颜色
        _slider.minimumTrackTintColor = ZDColor(33, 150, 243, 1);
        //滑块未滑过的颜色
        _slider.maximumTrackTintColor = [UIColor clearColor];
        _slider.continuous = false;
    }
    return _slider;
}
-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.translatesAutoresizingMaskIntoConstraints = false;
        _progressView.userInteractionEnabled = false;
        // 缓冲的颜色
        _progressView.progressTintColor = ZDColor(216, 216, 216, 1);
        // 没有缓冲的颜色
        _progressView.trackTintColor = ZDColor(50, 50, 50, 0.5);
    }
    return _progressView;
}
-(void)setThumbImage:(UIImage *)thumbImage {
    [self.slider setThumbImage: thumbImage forState: UIControlStateNormal];
}
-(void)setLoadValue:(float)loadValue {
    self.progressView.progress = loadValue;
}
-(float)loadValue {
    return self.progressView.progress;
}
-(void)setProgressValue:(float)progressValue {
    self.slider.value = progressValue;
}
-(float)progressValue {
    return self.slider.value;
}
-(void)setProgressMinmumValue:(float)progressMinmumValue {
    self.slider.minimumValue = progressMinmumValue;
}
-(float)progressMinmumValue {
    return self.slider.minimumValue;
}
-(void)setProgressMaxmumValue:(float)progressMaxmumValue {
    self.slider.maximumValue = progressMaxmumValue;
}
-(float)progressMaxmumValue {
    return self.slider.maximumValue;
}


@end














