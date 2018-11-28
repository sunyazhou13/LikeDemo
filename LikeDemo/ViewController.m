//
//  ViewController.m
//  LikeDemo
//
//  Created by sunyazhou on 2018/11/26.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import "ViewController.h"
#import "ZanLikeView.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) ZanLikeView *likeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat dx = 5; //倍数
    CGFloat width = 50 * dx;
    CGFloat height = 45 * dx;
    self.likeView = [[ZanLikeView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self.view addSubview:self.likeView];
    self.likeView.likeDuration = 0.5;
    self.likeView.zanFillColor = [UIColor redColor];
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
}


@end
