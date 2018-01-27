//
//  MainPlayVC.h
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/30.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPlayVC : UIViewController

@property (nonatomic, assign) NSInteger index;

+ (instancetype)shareMainPlayVC;
- (void)spin: (MainPlayVC *)wSelf;

@end
