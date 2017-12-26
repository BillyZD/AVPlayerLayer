//
//  PlayBgView.m
//  deomo
//
//  Created by 张冬 on 2017/12/25.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import "PlayBgView.h"
@interface PlayBgView()
@property (nonatomic , strong)UIButton *playButton;
@end

@implementation PlayBgView

-(instancetype)init {
    if (self = [super init]){
    }
    return  self;
}

# pragma mark - layoutSubviews
-(void)layoutSubviews {
    /// 发送通知，返回播放view的frame
    [[NSNotificationCenter defaultCenter] postNotificationName: PlayViewLoadSubView_Ntifiaction object: nil userInfo: @{@"frame": NSStringFromCGRect(self.frame)}];
}

# pragma mark - set and get
-(UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_playButton addTarget: self action: @selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

# pragma mark logic
/// 播放按钮的点击事件
-(void)playButtonClick: (UIButton *)sender {
    if (self.buttonClickBock) {
        self.buttonClickBock();
    }
}
/// 设置播放按钮的状态
-(void)setPlayStatus:(BOOL)isPlay {
    self.playButton.selected = isPlay;
    self.playButton.hidden = !isPlay;
}








@end
