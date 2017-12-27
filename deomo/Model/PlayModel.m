//
//  PlayModel.m
//  deomo
//
//  Created by 张冬 on 2017/12/25.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import "PlayModel.h"


@interface PlayModel()
@property(nonatomic , strong)AVPlayerLayer *playLayer;
@property(nonatomic , strong)AVPlayer *avLayer;
@property(nonatomic , assign)AVPlayStatus playStatus;
@end

@implementation PlayModel
+ (instancetype)sharePlayer {
    static PlayModel *sharePlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePlayer = [[PlayModel alloc] init];
    });
    return sharePlayer;
}

-(void)dealloc {
    NSLog(@"dealloc: PlayModel");
    [self removeObserver: self forKeyPath: @"status"];
}
# pragma mark - set and get
-(AVPlayerLayer *)playLayer {
    if (!_playLayer) {
        _playLayer = [[AVPlayerLayer alloc] init];
        _playLayer.videoGravity = AVLayerVideoGravityResize;
    }
    return _playLayer;
}

#pragma mark -logic
/// 监听回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass: [AVPlayerItem class]]) {
        AVPlayerItem *playitem = (AVPlayerItem *)object;
        if ([keyPath isEqualToString: @"loadedTimeRanges"]){
            NSLog(@"%@", playitem.loadedTimeRanges);
        }else if ([keyPath isEqualToString: @"status"]) {
            if (playitem.status == AVPlayerItemStatusReadyToPlay){
                [[NSNotificationCenter defaultCenter] postNotificationName: ReadyToPlay_Notification object:nil];
            }else if (playitem.status == AVPlayerItemStatusFailed) {
                [[NSNotificationCenter defaultCenter] postNotificationName: PlayFailed_Notification object:nil];
            }else if (playitem.status == AVPlayerItemStatusUnknown) {
                [[NSNotificationCenter defaultCenter] postNotificationName: PlayFailed_Notification object:nil];
            }
        }
    }else if ([object isKindOfClass: [AVPlayer class]]) {
        AVPlayer *play =(AVPlayer *)object;
        if (play.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
            NSLog(@"播放中");
            self.playStatus = AVPlayPlayingStatus;
        }else if (play.timeControlStatus == AVPlayerTimeControlStatusPaused) {
             NSLog(@"暂停了");
            self.playStatus = AVPlayPauseStatus;
        }else if (play.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
            NSLog(@"卡住了");
            self.playStatus = AVPlayWaitStatus;
        }
    }
}
/// 设置播放url(只有设置了播放链接才初始化播放的layer)
-(void)startPlay:(NSString *)urlStr {
    // 移除之前的播放资源
    [self freePlayer];
    // 设置新的播放资源
    NSURL *url = [NSURL URLWithString: urlStr];
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
    self.avLayer = [AVPlayer playerWithPlayerItem:playItem];
    [self.avLayer addObserver: self  forKeyPath: @"timeControlStatus" options: NSKeyValueObservingOptionNew context:nil];
    [self.playLayer setPlayer: self.avLayer];
    // 添加监听
    [self addObservsForPlayItem: playItem];
    /// 从当前的item开始播放
    [self reStartPlay];
}
/// 开始播放
-(void)reStartPlay {
    [self.avLayer play];
}
/// 暂停播放
-(void)pausePlay {
    [self.avLayer pause];
}
-(BOOL)isPlaying {
    if (self.avLayer.rate == 0) {
        return NO;
    }
    return  YES;
}
/// 释放当前的播放器
-(void)freePlayer {
    if (_avLayer) {
        if (_avLayer.currentItem) {
            [self removeObsersForPlayItem: _avLayer.currentItem];
            [self pausePlay];
            [_avLayer replaceCurrentItemWithPlayerItem: nil];
            [_avLayer removeObserver: self forKeyPath: @"timeControlStatus"];
            _avLayer = nil;
        }
    }
    self.playStatus = AVPlayNoStartStatus;
}

/// 添加AVPlayerItem的播放状态监听
-(void)addObservsForPlayItem: (AVPlayerItem *)item {
    [item addObserver: self forKeyPath: @"status" options: NSKeyValueObservingOptionNew context: nil];
    [item addObserver: self forKeyPath: @"loadedTimeRanges" options:NSKeyValueObservingOptionNew context: nil];
}
/// 移除AVPlayerItem的播放状态监听
-(void)removeObsersForPlayItem: (AVPlayerItem *)item {
    [item removeObserver: self forKeyPath: @"status"];
    [item removeObserver: self forKeyPath: @"loadedTimeRanges"];
}
@end









