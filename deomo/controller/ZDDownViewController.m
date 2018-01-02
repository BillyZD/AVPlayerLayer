//
//  ZDDownViewController.m
//  deomo
//
//  Created by 张冬 on 2018/1/2.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import "ZDDownViewController.h"
#import "ZDTimerModel.h"

@interface ZDDownViewController ()
@property(nonatomic , strong)ZDTimerModel *timerModel;

@end

@implementation ZDDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.timerModel startTimerDelayTime:0 RepeatTime:1.5 HandleBlock:^{
        NSLog(@"执行了");
    }];
    [self performSelector:@selector(pauseTimer) withObject: self afterDelay:4.5];
}
-(void)dealloc {
    NSLog(@"dealloc: ZDDownViewController");
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   // [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:true completion: nil];
}

/// 暂停定时器
-(void)pauseTimer {
    [self.timerModel pauseGCDTimer];
    [self performSelector:@selector(resumeTimer) withObject: self afterDelay: 3];
}
/// 重启定时器
-(void)resumeTimer {
    [self.timerModel resumeGCDTimer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark -- set and get
-(ZDTimerModel *)timerModel {
    if (!_timerModel) {
        _timerModel = [[ZDTimerModel alloc] init];
    }
    return _timerModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
