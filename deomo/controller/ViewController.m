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
    // 隐藏播放按钮
    [self.playView setPlayButtonStatus: true];
    // 添加缓冲菊花
    [self.playView isBufferAnimaiton: true];
}
/// 视频加载完成准备播放的通知
-(void)VedioLoadFinisFication {
    NSLog(@"可以开始播放，拖动进度条，设置开始播放时间");
    [self.playModel seekPlayTime: 35];
}
/// 处理点击视频播放按钮的回调(播放状态是未开始，没有加载过播放资源)
-(void)VedioPlayButtonBolck {
    // 设置播放链接
    [self configPlayModel: @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
}
/// 处理播放状态发生变化的回调
-(void)handlePlayChange: (AVPlayStatus) status {
    switch (status) {
        case AVPlayWaitStatus:
            NSLog(@"缓冲");
            [self.playView isBufferAnimaiton: true];
            break;
        case AVPlayPauseStatus:
            NSLog(@"播放暂停了");
            [self.playView setToolPlayingButtonStatus: false];
            [self.playView setPlayButtonStatus: false]; // 显示播放按钮
            [self.playView hiddenToolView: true];// 隐藏地步的tool
            break;
        case AVPlayPlayingStatus:
            NSLog(@"开始播放");
            [self.playView isBufferAnimaiton: false];
            [self.playView setToolPlayingButtonStatus: true];
            [self.playView setPlayButtonStatus: true]; // 显示播放按钮
        default:
            break;
    }
}

/// 设置block的回调
-(void)configBolck {
    __weak ViewController *weakSelf = self;
    self.playView.playbuttonClickBock = ^(BOOL isPlay) {
        if (isPlay == true) {
            if (weakSelf.playModel.playStatus == AVPlayNoStartStatus) {
                 [weakSelf VedioPlayButtonBolck];
            }else if (weakSelf.playModel.playStatus == AVPlayPauseStatus) {
                [weakSelf.playView setPlayButtonStatus: true];
                [weakSelf.playModel reStartPlay];
            }else if (weakSelf.playModel.playStatus == AVPlayFinishStatus) {
                [weakSelf.playView setPlayButtonStatus: true]; // 隐藏播放button
                [weakSelf.playModel seekPlayTime: 0];   // 重新开始播放；
            }
        }else{
            [weakSelf.playView isBufferAnimaiton: false];
            [weakSelf.playModel pausePlay];
        }
    };
    self.playModel.playStatusChange = ^(AVPlayStatus status) {
        [weakSelf handlePlayChange: status];
    };
    self.playModel.playFinishBlock = ^(BOOL isFinish, NSString *url) {
        [weakSelf.playView setPlayButtonStatus: false];
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
    if (self.playView.isAnimation == false && self.playModel.playStatus != AVPlayNoStartStatus && self.playModel.playStatus != AVPlayFinishStatus  && self.playModel.playStatus != AVPlayPauseStatus) {
        [self.playView hiddenToolView: !self.playView.isToolHiddlen];
    }
}
#pragma mark register fication and remove fication
/// 注册通知
-(void)registerNotification{
    /// 注册准备开始播放的通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(VedioLoadFinisFication) name: ReadyToPlay_Notification object: nil];
    /// 监听屏幕的旋转
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleDeviceOrigientChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
}
/// 移除通知
-(void)removeNotifiation {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: ReadyToPlay_Notification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIDeviceOrientationDidChangeNotification object: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
