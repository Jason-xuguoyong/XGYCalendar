//
//  XGYCalendarView.m
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "XGYCalendarBlackView.h"

@implementation XGYCalendarBlackView


- (instancetype)initWithFrame:(CGRect)frame defaultDate:(NSDate *)defaultDate WithCompleteBlock:(void(^)(NSInteger year, NSInteger month, NSInteger day))timeBlock animation:(BOOL)annimation
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackgroupColor;
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 20.0;
        CGPoint origin = CGPointMake(10.0, 64.0 + 70.0);
        self.calendarView = [[XGYCalendarView alloc] initWithFrameOrigin:origin width:width];
        // 点击某一天的回调
        __weak typeof(self)weakself =self;

        self.calendarView.didSelectDayHandler =^(NSInteger year, NSInteger month, NSInteger day)
        {
            [weakself hidenCalendarWithAnnimation:annimation];
            timeBlock(year,month,day);
            
        };
        
        [self addSubview:self.calendarView];
        self.calendarView.defaultDate = defaultDate?defaultDate:[NSDate date];
        self.alpha = 0.0f;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    __weak typeof(self)weakself =self;

    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if ([view isKindOfClass:[XGYCalendarBlackView class]]) {
        [weakself hidenCalendarWithAnnimation:YES];
    }
 
}

- (void)hidenCalendarWithAnnimation:(BOOL)annimation
{
    //停止点击
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    __weak typeof(self)weakself =self;

    if (annimation) {
        [UIView animateWithDuration:0.25 animations:^{
            weakself.alpha = 0.0;
        }completion:^(BOOL finished) {
            [weakself removeFromSuperview];
            [weakself.calendarView removeFromSuperview];
            [weakself.calendarView freeMemory];
            weakself.calendarView = nil;
            //停止点击
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        }];
    }else
    {   [weakself removeFromSuperview];
        [weakself.calendarView removeFromSuperview];
        [weakself.calendarView freeMemory];
        weakself.calendarView = nil;
     [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }

}
@end
