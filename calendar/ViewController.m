//
//  ViewController.m
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "ViewController.h"
#import "XGYCalendarTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"日历" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 50);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    btn.tag = 100;
    btn.centerX = self.view.centerX;
    [btn addTarget:self action:@selector(setupCalendar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"滚轮" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(100, 200, 100, 50);
    btn1.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn1];
    btn1.centerX = self.view.centerX;
    btn1.tag = 101;
     [btn1 addTarget:self action:@selector(setupCalendar:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)setupCalendar:(UIButton *)sender {
    
    
    
    XGYCalendarType type ;
    if (sender.tag == 100) {
        type =  XGYCalendarType_Page;
    }else
    {
        type =  XGYCalendarType_Picker;
    }
    
    
    [XGYCalendarTool showCalendarWithCalendarType:type defaultDate:nil completeBlock:^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld-%ld-%ld",year,month,day);
    }];
}

@end
