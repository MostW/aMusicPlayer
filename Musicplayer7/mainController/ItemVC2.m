//
//  ItemVC2.m
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/29.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import "ItemVC2.h"

@interface ItemVC2 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *list;

@end

@implementation ItemVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.list.delegate = self;
    [self initList];
}

- (void)initList {
    self.view.backgroundColor = [UIColor redColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cellID) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    return cell;
}

- (UITableView *)list {
    if (!_list) {
        _list = [[UITableView alloc] init];
    }
    return _list;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
