//
//  ItemVC1.m
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/29.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import "ItemVC1.h"
#import "GetMusicTool.h"
#import "PlayTool.h"
#import "MusicInfoModel.h"
#import "MainPlayVC.h"

@interface ItemVC1 ()

@property (nonatomic, strong) NSArray *musicSong;

@end

@implementation ItemVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[GetMusicTool shareInstace] fetchIpodLibraryMusicThenPassBy:^(NSArray *array){
        self.musicSong = array;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.musicSong.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    MusicInfoModel *model = [[MusicInfoModel alloc] init];
    model = _musicSong[indexPath.row];
    
    cell.textLabel.text = model.musicName;
    cell.detailTextLabel.text = model.musicSinger;
    cell.imageView.image = model.musicPic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainPlayVC *VC = [MainPlayVC shareMainPlayVC];
    VC.index = indexPath.row;
//    [self.navigationController pushViewController:VC animated:YES];
    [self presentViewController:VC animated:YES completion:nil];
}



@end
