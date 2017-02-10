//
//  XGYCalendarScrollView.h
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XGYCalendarConfiguration.h"


typedef void (^DidSelectDayHandler)(NSInteger, NSInteger, NSInteger);

@interface XGYCalendarScrollView : UIScrollView


@property (nonatomic, copy) DidSelectDayHandler didSelectDayHandler; // 日期点击回调

- (void)refreshToCurrentMonth; // 刷新 calendar 回到当前日期月份


- (void)refreshToDefaultDate:(NSDate *)defaultDate;
//根据年份刷新
- (void)refreshWithYear:(NSString *)year;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
//下一个月
- (void)nextMonth;
//上一个月
- (void)lastMonth;

@end
