//
//  ToolProgressView.h
//  deomo
//
//  Created by 张冬 on 2017/12/26.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolProgressView : UIView
/// 强制转屏的回调
@property(nonatomic , copy)void (^isFullBlock)(BOOL isFull);
/// 设置全屏按钮的状态
-(void)setButtonFullStatus: (BOOL) isFull;


@end
