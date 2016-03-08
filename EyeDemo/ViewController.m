//
//  ViewController.m
//  EyeDemo
//
//  Created by 路亮亮 on 16/3/8.
//  Copyright © 2016年 路亮亮. All rights reserved.
//

#import "ViewController.h"
#import "WYVideoCaptureController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)takeButtonClick:(UIButton *)sender {
    WYVideoCaptureController *videoVC = [[WYVideoCaptureController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:videoVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
