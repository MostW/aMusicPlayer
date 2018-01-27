//
//  MusicInfoModel.h
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/29.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MusicInfoModel : NSObject

@property (nonatomic, strong) NSURL *musicURL;//音乐地址
@property (nonatomic, strong) NSString *musicID;//音乐id
@property (nonatomic, strong) NSString *musicName;//歌名
@property (nonatomic, strong) UIImage *musicPic;//图片
@property (nonatomic, strong) NSString *musicAlbum;//专辑
@property (nonatomic, strong) NSString *musicSinger;//歌手
@property (nonatomic, strong) NSString *musicDuration;//时长

@end
