//
//  VidelListTableViewCell.h
//  deomo
//
//  Created by 张冬 on 2018/1/10.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VedeioListModel;

@interface VidelListTableViewCell : UITableViewCell
/// 播放按钮的点击回调
@property(nonatomic , copy)void (^playButtonBlock)(int row);
/// 刷新cell
-(void)updateCell: (VedeioListModel *)model Row:(int)row;

@end
