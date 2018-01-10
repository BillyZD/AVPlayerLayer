//
//  DownLoadModel.m
//  deomo
//
//  Created by 张冬 on 2018/1/9.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import "DownLoadModel.h"

@implementation DownLoadModel
/// 初始化
-(instancetype)init {
    if (self = [super init]) {
        self.downStatus = DownLoadNoStartStatus;
    }
    return  self;
}


@end
