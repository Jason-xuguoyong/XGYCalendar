//
//  XGYCalendarView.h
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGYCalendarScrollView.h"
typedef void (^DidSelectDayHandler)(NSInteger, NSInteger, NSInteger);

@interface XGYCalendarView : UIView
//默认显示的日期
@property (nonatomic,strong) NSDate *defaultDate;

/**
 *  构造方法
 *
 *  @param origin calendar 的位置
 *  @param width  calendar 的宽度（高度会根据给定的宽度自动计算）
 *
 *  @return bannerView对象
 */
- (instancetype)initWithFrameOrigin:(CGPoint)origin width:(CGFloat)width;


/**
 *  calendar 的高度（只读属性）
 */
@property (nonatomic, assign, readonly) CGFloat calendarHeight;


/**
 *  日期点击回调
 *  block 的参数表示当前日期的 NSDate 对象
 */
@property (nonatomic, copy) DidSelectDayHandler didSelectDayHandler;

/**
 释放内存
 */
- (void)freeMemory;


@end
