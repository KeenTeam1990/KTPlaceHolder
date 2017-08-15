//
//  ViewController.m
//  KTPlaceHolder
//
//  Created by KT on 2017/8/15.
//  Copyright © 2017年 KEENTEAM. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+KTPlaceHolder.h"
#import "UITextView+KTLimitCounter.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = CGRectMake(5, 330, [UIScreen mainScreen].bounds.size.width-10, 80);
    UITextView *textView = [[UITextView alloc] initWithFrame:rect];
    textView.layer.borderWidth = 1;
    textView.font = [UIFont systemFontOfSize:14];
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.kt_placeHolder = @"向厂家反馈同业相关活动、产品信息、用于市场分析。";
    textView.kt_limitCount = 60;
    textView.kt_placeHolderColor = [UIColor lightGrayColor];
    [self.view addSubview:textView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
