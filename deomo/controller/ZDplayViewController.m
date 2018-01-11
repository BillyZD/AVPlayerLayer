//
//  ViewController.m
//  deomo
//
//  Created by 张冬 on 2017/12/22.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import "ZDplayViewController.h"
#import "PlayModel.h"
#import "PlayBgView.h"
#import "ZDTimerModel.h"
#import "ZDDownViewController.h"
#import "DownLoadModel.h"
#import "DownLoadManager.h"
#import "VedeioListModel.h"
#import "VidelListTableViewCell.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ZDplayViewController () <ToolViewDelegate , UITableViewDelegate , UITableViewDataSource>
/// 视频播放模型
@property(nonatomic, strong)PlayModel *playModel;
/// 视频播放的背景view
@property(nonatomic , strong)PlayBgView *playView;
/// 控制视频播放器全屏的底部约束
@property(nonatomic , strong)NSLayoutConstraint *bottomConstraint;
/// 控制视频播放器的高度
@property(nonatomic , strong)NSLayoutConstraint *heightConstraint;
/// 控制时间的模型
@property(nonatomic , strong)ZDTimerModel *timerModel;
/// 显示视频列表的table
@property(nonatomic , strong)UITableView *table;
/// 显示列表的数据源
@property(nonatomic , strong)NSMutableArray *dataArr;
/// 记录当前播放的row
@property(nonatomic ,assign)int currentPlayRow;

@end

@implementation ZDplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentPlayRow = -1;
    self.playView.toolViewDelgate = self;
    [self configU];
    [self configBolck];
    [self loadData];
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
//    if (self.playModel.playStatus == AVPlayNoStartStatus) {
//        return  false;
//    }
//    return true;
    return  false;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent: event];
//    DownLoadModel *model = [[DownLoadModel alloc] init];
//    model.downUrl = @"http://audio.xmcdn.com/group11/M01/93/AF/wKgDa1dzzJLBL0gCAPUzeJqK84Y539.m4a";
//    [[DownLoadManager sharedInstance] startDownLoadModel:model];
}
#pragma mark load data
-(void)loadData {
    NSArray *urlArr = @[@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4" , @"http://rbv01.ku6.com/4N17b68V6904clVpwK4Aag.mp4" , @"http://rbv01.ku6.com/OLgq07gC58nZ_Mpfw2csKQ.mp4" , @"http://rbv01.ku6.com/uUEBClbBAkfep-V0n5Ngeg.mp4" , @"http://rbv01.ku6.com/AaDn0OcAiRkHB7ZOhKqpGA.mp4" , @"http://rbv01.ku6.com/jiCo-8aLJM4kJ33Myh856Q.mp4"];
    NSArray *titleArr = @[@"测试播放·1111" , @"测试播放22222" , @"测试播放3333" , @"测试播放444444" , @"测试55播放555" , @"测试·地址6666"];
    for (int i = 0; i < urlArr.count; i++) {
        VedeioListModel *model = [[VedeioListModel alloc] init];
        model.vedioUrl = urlArr[i];
        model.vedioName = titleArr[i];
        [self.dataArr addObject:model];
    }
    [self.table reloadData];
}

#pragma mark - init UI
/// 布局UI
-(void)configU {
    [self.view addSubview: self.table];
    [self.table registerClass:[VidelListTableViewCell class] forCellReuseIdentifier: @"video"];
    NSDictionary *vd = @{@"table": self.table};
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"|[table]|" options:0 metrics:nil views:vd]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:nil views:vd]];
    
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
    [self.playView setSliderInterac: true];
    [self startGCDTimer];
}
/// 处理点击视频播放按钮的回调(播放状态是未开始，没有加载过播放资源)
-(void)VedioPlayButtonBolck {
    /// 禁止滑动进度条
    [self.playView setSliderInterac: false];
    // 设置播放链接
    if (self.currentPlayRow != -1 && self.currentPlayRow < self.dataArr.count) {
        VedeioListModel *model = self.dataArr[self.currentPlayRow];
        [self configPlayModel:model.vedioUrl];
    }
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
            [self.playView setPlayButtonStatus: self.playView.isSeeking]; // 显示播放按钮
            if (self.playView.isSeeking == false) {
                 [self.playView hiddenToolView: true];// 隐藏底部的tool
            }
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
/// 启动定时器
-(void)startGCDTimer {
    __weak ZDplayViewController *weakSelf = self;
    // 启动GCD定时
    [self.timerModel startTimerDelayTime: 0 RepeatTime: 1 HandleBlock:^{
        [weakSelf handleGCDTimerBlock];
    }];
}
/// 处理定时器方法
-(void)handleGCDTimerBlock {
    if (self.playModel.playStatus == AVPlayPlayingStatus) {
        [self.playView setCurrentTime:self.playModel.currentTime  AndTotalTime: self.playModel.totoalTime];
        [self.playView setCurrenPlayTime:self.playModel.currentTime];
    }
   
}

/// 设置block的回调
-(void)configBolck {
    __weak ZDplayViewController *weakSelf = self;
    self.playView.playbuttonClickBock = ^(BOOL isPlay) {
        if (isPlay == true) {
            if (weakSelf.playModel.playStatus == AVPlayNoStartStatus) { // 还没开始播放
                 [weakSelf VedioPlayButtonBolck]; // 设置播放链接开始播放
            }else if (weakSelf.playModel.playStatus == AVPlayPauseStatus) {  // 暂定状态
                [weakSelf.playView setPlayButtonStatus: true]; // 隐藏播放按钮
                [weakSelf.playModel reStartPlay]; // 重新开始播放
            }else if (weakSelf.playModel.playStatus == AVPlayFinishStatus) { 
                [weakSelf.playView setPlayButtonStatus: true]; // 隐藏播放button
                [weakSelf.playModel seekPlayTime: 0];   // 重新开始播放；
                [weakSelf.timerModel resumeGCDTimer]; // 重新启动定时器
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
        [weakSelf.playView setPlayButtonStatus: false]; // 显示屏幕的播放按钮
        [weakSelf.playView hiddenToolView: true]; // 隐藏底部的工具栏
        [weakSelf.timerModel pauseGCDTimer]; // 暂停定时器
    };
    self.playModel.getVidetTotalTimeBlock = ^(NSTimeInterval totalTime) {
        [weakSelf.playView setTotalPlayTime: totalTime];
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
//    [NSLayoutConstraint deactivateConstraints: @[self.heightConstraint]];
//    [NSLayoutConstraint activateConstraints: @[self.bottomConstraint]];
//    [self.playView setFullButtonStatus: true];
}
/// 竖屏的布局
-(void)noFullScreenLayout {
//    [NSLayoutConstraint deactivateConstraints: @[self.bottomConstraint]];
//    [NSLayoutConstraint activateConstraints: @[self.heightConstraint]];
//    [self.playView setFullButtonStatus: false];
}
/// 处理cell的播放事件
-(void)handleCellPlay: (int)row {
    NSLog(@"播放:%d" ,row);
    [self getPalyCellAndAddPlayLayer:row];
    VedeioListModel *model = self.dataArr[row];
    [self configPlayModel:model.vedioUrl];
}
/// 获取cell添加播放层
-(void)getPalyCellAndAddPlayLayer: (int)row {
    if (row < self.dataArr.count) {
        self.currentPlayRow = row;
        VidelListTableViewCell *cell = [self.table cellForRowAtIndexPath: [NSIndexPath indexPathForRow:row inSection: 0]];
        [cell.contentView addSubview: self.playView];
        self.playView.translatesAutoresizingMaskIntoConstraints = YES;
        self.playView.frame = cell.bounds;
        [self.playView.layer addSublayer:self.playModel.playLayer];
    }
}

/// 判断播放的cell是否在屏幕内
-(BOOL)rectForRowAtIndexPath: (NSIndexPath *)indexPath {
    CGRect cellR = [self.table rectForRowAtIndexPath: indexPath];
    // 判断必须整个cell在屏幕内才返回true
    if ((self.table.contentOffset.y <= cellR.origin.y) && (cellR.origin.y + cellR.size.height  <= self.table.frame.size.height + self.table.contentOffset.y)) {
        return YES;
    }
   
    return NO;
}
/// 处理cell滑倒屏幕内
-(void)handleCellEnterScreen {
    if ([self.playView.superview isEqual:self.view]) {
        [self getPalyCellAndAddPlayLayer: self.currentPlayRow];
    }
}
/// 处理cell滑出屏幕外
-(void)handlCellOverScreen {
    if ([self.playView.superview isEqual:self.view]) {
        NSLog(@"不做处理");
    }else {
        [self.view addSubview: self.playView];
        self.playView.frame = CGRectMake(0, 300, 100, 60);
    }
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
-(ZDTimerModel *)timerModel {
    if (!_timerModel) {
        _timerModel = [[ZDTimerModel alloc] init];
    }
    return _timerModel;
}
-(UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.translatesAutoresizingMaskIntoConstraints = false;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.backgroundColor = [UIColor whiteColor];
        _table.delegate = self;
        _table.dataSource = self;
        _table.bounces = false;
    }
    return _table;
}
-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - delgate
/// 强制转屏
-(void)forceIsfullScreen:(BOOL)isFull {
//    if (isFull) {
//        NSNumber *resetOrientationTarget = [NSNumber numberWithInt: UIInterfaceOrientationLandscapeLeft];
//        [[UIDevice currentDevice] setValue: resetOrientationTarget forKey: @"orientation"];
//    }else{
//        NSNumber *resetOrientationTarget = [NSNumber numberWithInt: UIDeviceOrientationPortrait];
//        [[UIDevice currentDevice] setValue: resetOrientationTarget forKey: @"orientation"];
//    }
}
/// 点击播放器
-(void)tapGestureForView {
    NSLog(@"点击了播放器");
    if (self.playView.isAnimation == false && self.playModel.playStatus != AVPlayNoStartStatus && self.playModel.playStatus != AVPlayFinishStatus  && self.playModel.playStatus != AVPlayPauseStatus) {
        [self.playView hiddenToolView: !self.playView.isToolHiddlen];
    }
}
/// 开始拖动进度条
-(void)touchBeganSlide {
    [self.playModel pausePlay];
}
/// 结束拖动
-(void)touchEndSlider:(float)value {
    [self.playModel seekPlayTime: value];
}
/// 进度条发生改变的
-(void)sliderValeChange:(float)value {
    [self.playView setCurrentTime: value AndTotalTime: self.playModel.totoalTime];
}
/// table滚动回调
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 存在正在播放的视频时，判断cell的位置，是否使用浮层播放
    if ((self.currentPlayRow >= 0) && (self.playModel.playStatus == AVPlayPlayingStatus)) {
        NSLog(@"%d", self.currentPlayRow);
        if ([self rectForRowAtIndexPath: [NSIndexPath indexPathForRow: self.currentPlayRow inSection:0]]) {
            NSLog(@"屏幕内");
            [self handleCellEnterScreen];
        }else{
            NSLog(@"滑出屏幕外");
            [self handlCellOverScreen];
        }
    }
}
/// table return row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
/// table return rowHight layout
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
/// table return rowHight layout
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
/// return tableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VidelListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"video" forIndexPath: indexPath];
    [cell updateCell:self.dataArr[indexPath.row] Row: (int)indexPath.row];
    __weak ZDplayViewController *weakSelf = self;
    cell.playButtonBlock = ^(int row) {
        [weakSelf handleCellPlay:row];
    };
    return cell;
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
