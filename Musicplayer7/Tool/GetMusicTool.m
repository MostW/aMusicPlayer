//
//  GetMusicTool.m
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/29.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import "GetMusicTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicInfoModel.h"

@interface GetMusicTool()



@end

@implementation GetMusicTool

+ (instancetype)shareInstace {
    static GetMusicTool *getMusic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getMusic = [[GetMusicTool alloc] init];
    });
    return getMusic;
}

- (void)fetchIpodLibraryMusicThenPassBy:(PassMusic)pass {
    self.songs = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MPMediaQuery *query = [MPMediaQuery songsQuery];
        for (MPMediaItemCollection *collection in query.collections) {
            for (MPMediaItem *item in collection.items) {
                
                MusicInfoModel *model = [[MusicInfoModel alloc] init];
                model.musicURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
                model.musicName = [item valueForProperty:MPMediaItemPropertyTitle];
                model.musicSinger = [item valueForProperty:MPMediaItemPropertyArtist];
                if (!model.musicSinger) {
                    model.musicSinger = @"unKnow";
                }
                model.musicAlbum = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
                model.musicPic = [[item valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:CGSizeMake(50,50)];
                if (!model.musicPic) {
                    model.musicPic = [UIImage imageNamed:@"music"];
                }
                [self.songs addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            pass(_songs);
        });
    });
    
}

@end
