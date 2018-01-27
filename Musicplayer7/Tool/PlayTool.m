//
//  PlayTool.m
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/30.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import "PlayTool.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayTool()



@end

@implementation PlayTool

+ (instancetype)sharePlayTool {
    static PlayTool *PT = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PT = [[PlayTool alloc] init];
    });
    return PT;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (void)previousMusic {
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:_model.musicURL];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
//    [self play];
}




- (void)playWithModel:(MusicInfoModel *)model {
    
}

@end
