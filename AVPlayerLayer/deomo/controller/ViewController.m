//
//  ViewController.m
//  deomo
//
//  Created by 张冬 on 2017/12/22.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import "ViewController.h"
#import "PlayModel.h"
#import "PlayBgView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () <ToolViewDelegate>
/// 视频播放模型
@property(nonatomic, strong)PlayModel *playModel;
/// 视频播放的背景view
@property(nonatomic , strong)PlayBgView *playView;
/// 控制视频播放器全屏的底部约束
@property(nonatomic , strong)NSLayoutConstraint *bottomConstraint;
/// 控制视频播放器的高度
@property(nonatomic , strong)NSLayoutConstraint *heightConstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configU];
    [self configBolck];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self registerNotification];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [self removeNotifiation];
}
-(void)viewDidLayoutSubviews {
    self.playModel.playLayer.frame = self.playView.bounds;
}
-(BOOL)shouldAutorotate {
    if (self.playModel.playStatus == AVPlayNoStartStatus) {
        return  false;
    }
    return true;
}

#pragma mark - initUI
/// 布局UI
-(void)configU {
    [self.view addSubview: self.playView];
    self.playView.translatesAutoresizingMaskIntoConstraints = false;
    NSDictionary *vd = @{@"playView": self.playView};
    self.playView.toolViewDelgate = self;
    [self.playView.layer addSublayer: self.playModel.playLayer];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"|[playView]|" options:0 metrics:nil views:vd]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playView]" options:0 metrics:nil views:vd]];
    self.bottomConstraint = [self.playView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor];
    self.heightConstraint = [self.playView.heightAnchor constraintEqualToConstant: 200];
    [NSLayoutConstraint activateConstraints:@[self.heightConstraint]];
    [NSLayoutConstraint deactivateConstraints:@[self.bottomConstraint]];
}
#pragma mark logic
/// 设置播放链接开始播放
-(void)configPlayModel: (NSString *)playUrlStr {
    [self.playModel startPlay: playUrlStr];
    self.playModel.playLayer.frame = self.playView.bounds;
    
}
/// 视频加载完成准备播放的通知
-(void)VedioLoadFinisFication {
    NSLog(@"准备播放了");
    /// 移除加载的菊花
    [self.playView isBufferAnimaiton: false];
}
/// 处理点击视频播放按钮的回调
-(void)VedioPlayButtonBolck {
    // 隐藏播放按钮
    [self.playView setPlayStatus: true];
    // 添加缓冲菊花
    [self.playView isBufferAnimaiton: true];
    // 设置播放链接
    [self configPlayModel: @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
}
/// 播放完成的处理
-(void)VedioPlayFinishFication {
    NSLog(@"播放完成");
    [self.playView setPlayStatus: false];
}
/// 设置block的回调
-(void)configBolck {
    __weak ViewController *weakSelf = self;
    self.playView.playbuttonClickBock = ^(BOOL isPlay) {
        if (isPlay == true) {
            if (weakSelf.playModel.playStatus == AVPlayNoStartStatus) {
                 [weakSelf VedioPlayButtonBolck];
            }else if (weakSelf.playModel.playStatus == AVPlayPauseStatus) {
                [weakSelf.playModel reStartPlay];
            }
        }else{
            [weakSelf.playModel pausePlay];
        }
    };
}
/// 处理屏幕旋转问题
-(void)handleDeviceOrigientChange: (NSNotification *)fiaciton {
    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
    if (self.playModel.playStatus != AVPlayNoStartStatus) {
        switch (duration) {
            case UIDeviceOrientationLandscapeLeft:
                [self fullScreenLayout];
                break;
            case UIDeviceOrientationLandscapeRight:
                [self fullScreenLayout];
                break;
            case UIDeviceOrientationPortrait:
                [self noFullScreenLayout];
                break;
            default:
                break;
        }
    }
}
/// 布局全屏的约束·
-(void)fullScreenLayout {
    [NSLayoutConstraint deactivateConstraints: @[self.heightConstraint]];
    [NSLayoutConstraint activateConstraints: @[self.bottomConstraint]];
    [self.playView setFullButtonStatus: true];
}
/// 竖屏的布局
-(void)noFullScreenLayout {
    [NSLayoutConstraint deactivateConstraints: @[self.bottomConstraint]];
    [NSLayoutConstraint activateConstraints: @[self.heightConstraint]];
    [self.playView setFullButtonStatus: false];
}
#pragma mark - (set-get)
-(PlayModel *)playModel {
    if (!_playModel) {
        _playModel = [PlayModel sharePlayer];
    }
    return _playModel;
}
-(PlayBgView *)playView {
    if (!_playView) {
        _playView = [[PlayBgView alloc] init];
    }
    return _playView;
}
#pragma mark - delgate
/// 强制转屏
-(void)forceIsfullScreen:(BOOL)isFull {
    if (isFull) {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt: UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue: resetOrientationTarget forKey: @"orientation"];
    }else{
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt: UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue: resetOrientationTarget forKey: @"orientation"];
    }
}
/// 点击播放器
-(void)tapGestureForView {
    if (self.playView.isAnimation == false && self.playModel.playStatus != AVPlayNoStartStatus) {
        [self.playView hiddenToolView: !self.playView.isToolHiddlen];
    }
}
#pragma mark register fication and remove fication
/// 注册通知
-(void)registerNotification{
    /// 注册准备开始播放的通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(VedioLoadFinisFication) name: ReadyToPlay_Notification object: nil];
    /// 注册完成播放的通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(VedioPlayFinishFication) name: AVPlayerItemDidPlayToEndTimeNotification object: nil];
    /// 监听屏幕的旋转
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleDeviceOrigientChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
}
/// 移除通知
-(void)removeNotifiation {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: ReadyToPlay_Notification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: AVPlayerItemDidPlayToEndTimeNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIDeviceOrientationDidChangeNotification object: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
