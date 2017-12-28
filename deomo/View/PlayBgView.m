//
//  PlayBgView.m
//  deomo
//
//  Created by 张冬 on 2017/12/25.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import "PlayBgView.h"
#import "ToolProgressView.h"



@interface PlayBgView()
@property (nonatomic , strong)UIButton *playButton;
@property (nonatomic , strong)UIActivityIndicatorView * active;
@property (nonatomic , strong)ToolProgressView *toolView;
@property (nonatomic , assign)BOOL isAnimation;
@property (nonatomic , assign)BOOL isToolHiddlen;

@end

@implementation PlayBgView

-(instancetype)init {
    if (self = [super init]){
        [self configUI];
        [self configBlock];
        [self addTapGestureToView];
        self.isToolHiddlen = true;
    }
    return  self;
}
# pragma mark - layoutSubviews
-(void)layoutSubviews {
    self.active.center = self.center;
}
# pragma mark - cofigUI
/// 布局所有界面
-(void)configUI {
    [self addSubview: self.active];
    [self addSubview: self.playButton];
    NSLayoutConstraint *centerXConstraint = [self.playButton.centerXAnchor constraintEqualToAnchor: self.centerXAnchor];
    NSLayoutConstraint *centerYConstraint = [self.playButton.centerYAnchor constraintEqualToAnchor: self.centerYAnchor];
    NSLayoutConstraint *widhtConstraint = [self.playButton.widthAnchor constraintEqualToConstant: 50];
    NSLayoutConstraint *heightConstraint = [self.playButton.heightAnchor constraintEqualToConstant: 50];
    [NSLayoutConstraint activateConstraints: @[centerXConstraint , centerYConstraint , widhtConstraint , heightConstraint]];
    [self addSubview: self.toolView];
    NSDictionary *vd = @{@"toolView": self.toolView};
    NSDictionary *metrics = @{@"height": @ToolProgressHeight};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[toolView]|" options:0 metrics: nil views: vd]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolView(height)]|" options:0 metrics: metrics views: vd]];
}

# pragma mark - set and get
-(UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _playButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
        [_playButton addTarget: self action: @selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.layer.zPosition = 9;
    }
    return _playButton;
}
-(UIActivityIndicatorView *)active {
    if (!_active) {
        _active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        _active.hidesWhenStopped = true;
        _active.layer.zPosition = 10; // 确保缓冲的菊花显示在最上面
    }
    return  _active;
}
-(ToolProgressView *)toolView {
    if (!_toolView) {
        _toolView = [[ToolProgressView alloc] init];
        _toolView.layer.zPosition = 11;
        _toolView.translatesAutoresizingMaskIntoConstraints = false;
        _toolView.alpha = 0;
    }
    return _toolView;
}
# pragma mark logic
/// 添加点击手势
-(void)addTapGestureToView {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleViewTapGesture)];
    [tapGesture setNumberOfTapsRequired: 1];
    [self addGestureRecognizer: tapGesture];
}
/// 响应屏幕点击事件
-(void)handleViewTapGesture {
    if ([self.toolViewDelgate respondsToSelector: @selector(tapGestureForView)]) {
        [self.toolViewDelgate tapGestureForView];
        [self performSelector: @selector(HandlePerform) withObject: nil
                   afterDelay: 5];
    }
}
/// 播放按钮的点击事件
-(void)playButtonClick: (UIButton *)sender {
    if (self.playbuttonClickBock) {
        self.playbuttonClickBock(true);
    }
}
/// 设置回调
-(void)configBlock {
    __weak PlayBgView *weakSelf = self;
    self.toolView.isFullBlock = ^(BOOL isFull) {
        if ([weakSelf.toolViewDelgate respondsToSelector: @selector(forceIsfullScreen:)]) {
              [weakSelf.toolViewDelgate forceIsfullScreen: isFull];
        }
    };
    self.toolView.isPlayBlock = ^(BOOL isPlay) {
        if (weakSelf.playbuttonClickBock) {
            weakSelf.playbuttonClickBock(isPlay);
        }
    };
}
/// 设置播放按钮的状态
-(void)setPlayButtonStatus:(BOOL)isPlay {
    self.backgroundColor = [UIColor blackColor];
    self.playButton.hidden = isPlay;
}
/// 是否显示缓冲菊花
-(void)isBufferAnimaiton:(BOOL)show {
    show == true ? [self.active startAnimating] : [self.active stopAnimating];
}
/// 是否显示tool
-(void)hiddenToolView:(BOOL)hiddlen {
    __weak PlayBgView *weakSelf =self;
    self.isAnimation = true;
    self.isToolHiddlen = hiddlen;
    [UIView animateWithDuration: 0.5 animations:^{
        hiddlen == true ? (weakSelf.toolView.alpha = 0) : (weakSelf.toolView.alpha = 1);
    } completion:^(BOOL finished) {
        weakSelf.isAnimation = false;
    }];
}
///设置全屏按钮的状态
-(void)setFullButtonStatus:(BOOL)isFull {
    [self.toolView setButtonFullStatus: isFull];
}
/// 设置播放按钮的状态
-(void)setToolPlayingButtonStatus:(BOOL)isPlaying {
    [self.toolView setPlayButtonStatus: isPlaying];
}
/// 后台自动隐藏底部的工具栏
-(void)HandlePerform {
    if (self.isAnimation == false && self.isToolHiddlen == false) {
        [self hiddenToolView: true];
    }
}
@end











