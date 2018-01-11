//
//  VedeioListModel.m
//  deomo
//
//  Created by 张冬 on 2018/1/10.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import "VedeioListModel.h"
#import <AVKit/AVKit.h>
@implementation VedeioListModel

+(void)firstFrameWithVideoUrl:(NSString *)urlStr getImageBlock:(void (^)(UIImage *))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:urlStr] options: nil];
        NSParameterAssert(avAsset);
        AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset: avAsset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef refImage = NULL;
        NSError *err = nil;
        refImage = [assetImageGenerator copyCGImageAtTime:CMTimeMake(2, 60) actualTime:NULL error:&err];
        if (err) {
            NSLog(@"获取第一贞失败:%@%@",err.localizedDescription , urlStr);
            block(nil);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                 block([[UIImage alloc] initWithCGImage:refImage]);
                 CFRelease(refImage);
            });
        }
    });
   
}

@end
