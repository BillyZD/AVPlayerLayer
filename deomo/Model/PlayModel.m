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
@property(nonatomic , copy)NSString *currentPlayStr;
/// 视频总的时间
@property(nonatomic , assign)NSTimeInterval totoalTime;
/// 视频当前的播放时间
@property(nonatomic , assign)NSTimeInterval currentTime;
@end

@implementation PlayModel
+ (instancetype)sharePlayer {
    static PlayModel *sharePlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePlayer = [[PlayModel alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver: sharePlayer selector: @selector(playFinishFication:) name: AVPlayerItemDidPlayToEndTimeNotification object: nil];
    });
    return sharePlayer;
}

-(void)dealloc {
    NSLog(@"dealloc: PlayModel");
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:AVPlayerItemDidPlayToEndTimeNotification object: nil];
}
# pragma mark - set and get
-(AVPlayerLayer *)playLayer {
    if (!_playLayer) {
        _playLayer = [[AVPlayerLayer alloc] init];
        _playLayer.videoGravity = AVLayerVideoGravityResize;
    }
    return _playLayer;
}
-(NSTimeInterval)currentTime {
    return CMTimeGetSeconds(self.avLayer.currentTime);
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
                 self.totoalTime = CMTimeGetSeconds(self.avLayer.currentItem.duration);
                if (self.getVidetTotalTimeBlock) {
                    self.getVidetTotalTimeBlock(self.totoalTime);
                }
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
            NSTimeInterval current = CMTimeGetSeconds(self.avLayer.currentTime);
            if (current == self.totoalTime) {
                self.playStatus = AVPlayFinishStatus;
            }else{
                 NSLog(@"暂停了");
                self.playStatus = AVPlayPauseStatus;
            }
        }else if (play.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
            NSLog(@"缓冲");
            self.playStatus = AVPlayWaitStatus;
        }
        if (self.playStatusChange) {
            self.playStatusChange(self.playStatus);
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
    // 从当前的item开始播放
    [self reStartPlay];
    // 标记当前播放的链接
    self.currentPlayStr = urlStr;
}
/// 开始播放
-(void)reStartPlay {
    [self.avLayer play];
}
/// 暂停播放
-(void)pausePlay {
    [self.avLayer pause];
}
/// 释放当前的播放器
-(void)freePlayer {
    if (_avLayer) {
        if (_avLayer.currentItem) {
            [self removeObsersForPlayItem: _avLayer.currentItem];
            [_avLayer replaceCurrentItemWithPlayerItem: nil];
        }
        [self pausePlay];
        [_avLayer removeObserver: self forKeyPath: @"timeControlStatus"];
        _avLayer = nil;
    }
    self.playStatus = AVPlayNoStartStatus;
}
/// 完成播放的通知回调
-(void)playFinishFication: (NSNotification *)fication {
    NSLog(@"播放完成了");
    self.playStatus = AVPlayFinishStatus;
    if (self.playFinishBlock) {
        self.playFinishBlock(true, self.currentPlayStr);
    }
}
/// 设置开始播放的播放
-(void)seekPlayTime:(NSTimeInterval)time {
    CMTime seekTime = CMTimeMake(time, 1);
    [self.avLayer seekToTime:seekTime];
    [self reStartPlay];
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









