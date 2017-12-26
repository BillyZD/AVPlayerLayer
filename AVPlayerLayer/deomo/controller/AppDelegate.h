//
//  AppDelegate.h
//  deomo
//
//  Created by 张冬 on 2017/12/22.
//  Copyright © 2017年 张冬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

