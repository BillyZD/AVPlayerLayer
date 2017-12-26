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

@interface ViewController ()
/// 布局的table
@property(nonatomic , strong)UITableView *table;
/// cell的标志
@property(nonatomic , copy)NSString *cellId;
/// 数据源
@property(nonatomic , strong)NSMutableArray *dataArr;
/// 缓冲菊花
@property(nonatomic , strong)UIActivityIndicatorView *active;
/// 视频播放模型
@property(nonatomic, strong)PlayModel *playModel;
/// 视频播放的背景view
@property(nonatomic , strong)PlayBgView *playView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellId = @"CELL_ID";
    [self configU];
    [self configPlayMode];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self registerNotification];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [self removeNotifiation];
}



#pragma mark - initUI
/// 布局UI
-(void)configU {
    [self.view addSubview: self.playView];
    self.playView.backgroundColor = [UIColor redColor];
    self.playView.translatesAutoresizingMaskIntoConstraints = false;
    NSDictionary *vd = @{@"playView": self.playView};
   
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"|[playView]|" options:0 metrics:nil views:vd]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[playView(200)]" options:0 metrics:nil views:vd]];
}
#pragma mark logic

/// 设置播放模型
-(void)configPlayMode {
    [self.playModel startPlay: @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    [self.playView.layer addSublayer: self.playModel.playLayer];
}
/// 处理播放器view布局的回调通知，获取播放view的大小
-(void)handlePlayViewFrame: (NSNotification *)fication {
    NSDictionary *infor = fication.userInfo;
    NSString *value = infor[@"frame"];
    self.playModel.playLayer.frame = CGRectFromString(value);
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
#pragma mark register fication and remove fication
/// 注册通知
-(void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(handlePlayViewFrame:) name:PlayViewLoadSubView_Ntifiaction object:nil];
}
/// 移除通知
-(void)removeNotifiation {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: PlayViewLoadSubView_Ntifiaction object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
