//
//  XGYCalendarMonth.m
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "XGYCalendarMonth.h"
#import "NSDate+XGYCalendar.h"

@implementation XGYCalendarMonth

- (instancetype)initWithDate:(NSDate *)date {
    
    if (self = [super init]) {
        
        _monthDate = date;
        
        _totalDays = [self setupTotalDays];
        _firstWeekday = [self setupFirstWeekday];
        _year = [self setupYear];
        _month = [self setupMonth];
        
    }
    
    return self;
    
}


- (NSInteger)setupTotalDays {
    return [_monthDate totalDaysInMonth];
}

- (NSInteger)setupFirstWeekday {
    return [_monthDate firstWeekDayInMonth];
}

- (NSInteger)setupYear {
    return [_monthDate dateYear];
}

- (NSInteger)setupMonth {
    return [_monthDate dateMonth];
}


@end
