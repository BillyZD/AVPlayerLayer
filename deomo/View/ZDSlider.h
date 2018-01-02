//
//  ZDSlider.h
//  deomo
//
//  Created by 张冬 on 2017/12/29.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义进度条
 */
@interface ZDSlider : UIControl

/// 已经加载的显示 0-1
@property (nonatomic, assign)float loadValue;
/// 已经播放的显示(通常为视频播放的当前时常)
@property (nonatomic , assign)float progressValue;
/// 进度条最小值(通常为0)
@property (nonatomic, assign)float progressMinmumValue;
/// 进度条最大值(通常为视频的时常)
@property (nonatomic , assign)float progressMaxmumValue;
/// 设置滑块的图片
@property (nonatomic , strong)UIImage *thumbImage;


@end
