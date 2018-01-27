//
//  BarController.m
//  Musicplayer7
//
//  Created by 巫永健 on 2017/12/29.
//  Copyright © 2017年 巫永健. All rights reserved.
//

#import "BarController.h"
#import "ItemVC1.h"
#import "ItemVC2.h"
#import "ItemVC3.h"
#import <Masonry.h>

@interface BarController ()<UINavigationControllerDelegate>

@end

@implementation BarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTabBar];
}

- (void)initTabBar {
    ItemVC1 *item1 = [[ItemVC1 alloc] init];
    [self initBarItemWithController:item1 title:@"local" image:@"tab_icon_selection_normal_light" selectImage:@"tab_icon_selection_highlight"];
    
    ItemVC2 *item2 = [[ItemVC2 alloc] init];
    [self initBarItemWithController:item2 title:@"play" image:@"icon_tab_shouye_normal_light" selectImage:@"icon_tab_shouye_highlight"];
    
    ItemVC3 *item3 = [[ItemVC3 alloc] init];
    [self initBarItemWithController:item3 title:@"net" image:@"icon_tab_wode_normal_light" selectImage:@"icon_tab_wode_highlight"];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    
    [self setSelectedIndex:0];
    
}

- (void)initBarItemWithController: (UIViewController *)controller title: (NSString *)title image: (NSString *)image selectImage: (NSString *)selectedImage {
    
    
    controller.tabBarItem.title = title;
    if ([image isEqual:@""]) {
        
    }
    else {
        UIImage *img = [UIImage imageNamed:image];
        controller.tabBarItem.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.delegate = self;
    [self addChildViewController:nav];
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
