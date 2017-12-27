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
@end

@implementation PlayBgView

-(instancetype)init {
    if (self = [super init]){
        [self configUI];
        [self configBlock];
    }
    return  self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan: touches withEvent: event];
    NSLog(@"点击了");
    static BOOL isHiddlen = true;
    [self isHiddenToolView: isHiddlen];
    isHiddlen = !isHiddlen;
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
    }
    return _toolView;
}
# pragma mark logic
/// 播放按钮的点击事件
-(void)playButtonClick: (UIButton *)sender {
    if (self.buttonClickBock) {
        self.buttonClickBock();
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
}
/// 设置播放按钮的状态
-(void)setPlayStatus:(BOOL)isPlay {
    self.backgroundColor = [UIColor blackColor];
    self.playButton.hidden = isPlay;
}
/// 是否显示缓冲菊花
-(void)isBufferAnimaiton:(BOOL)show {
    show == true ? [self.active startAnimating] : [self.active stopAnimating];
}
/// 是否显示tool
-(void)isHiddenToolView:(BOOL)hiddlen {
    __weak PlayBgView *weakSelf =self;
    [UIView animateWithDuration: 0.5 animations:^{
        hiddlen == true ? (weakSelf.toolView.alpha = 0) : (weakSelf.toolView.alpha = 1);
    }];
}
-(void)setFullButtonStatus:(BOOL)isFull {
    [self.toolView setButtonFullStatus: isFull];
}
@end











