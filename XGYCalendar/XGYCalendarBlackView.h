//
//  XGYCalendarView.h
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGYCalendarView.h"

@interface XGYCalendarBlackView : UIView

- (instancetype)initWithFrame:(CGRect)frame defaultDate:(NSDate *)defaultDate WithCompleteBlock:(void(^)(NSInteger year, NSInteger month, NSInteger day))timeBlock animation:(BOOL)annimation;

@property (nonatomic,strong) XGYCalendarView *calendarView;
//默认显示的日期
@property (nonatomic,strong) NSDate *defaultDate;


- (void)hidenCalendarWithAnnimation:(BOOL)annimation;
@end
