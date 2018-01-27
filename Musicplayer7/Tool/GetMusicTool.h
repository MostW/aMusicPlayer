//
//  GetMusicTool.h
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/29.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PassMusic) (NSArray *array);

@interface GetMusicTool : NSObject

@property (nonatomic, strong) NSMutableArray *songs;

//单例
+ (instancetype)shareInstace ;

//获取本地音乐
- (void)fetchIpodLibraryMusicThenPassBy: (PassMusic) pass;

@end
