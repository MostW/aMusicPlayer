//
//  PlayTool.h
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/30.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicInfoModel.h"
#import <AVFoundation/AVFoundation.h>

//播放状态

@interface PlayTool : NSObject

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) MusicInfoModel *model;

//单例
+ (instancetype)sharePlayTool ;

//通过传过来的model播放
- (void)playWithModel: (MusicInfoModel *)model;

- (void)playNext;
- (void)playLast;
//- (void)pause;
//- (void)play;
- (void)previousMusic;

@end
