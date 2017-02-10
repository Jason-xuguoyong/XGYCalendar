//
//  XGYCalendarTool.m
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "XGYCalendarTool.h"
#import "XGYCalendarBlackView.h"
#import "XGYPickerCalendar.h"
#import "XGYCalendarConfiguration.h"
@implementation XGYCalendarTool
/**
 展示日历的方法
 
 @param timeBlock 点击某一天的时间的回调
 */
+ (void)showCalendarWithCompleteBlock:(void(^)(NSInteger year, NSInteger month, NSInteger day))timeBlock animation:(BOOL)annimation
{

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  
    XGYCalendarBlackView *blackView = [[XGYCalendarBlackView alloc] initWithFrame:keyWindow.bounds defaultDate:nil WithCompleteBlock:timeBlock animation:annimation];
    blackView.tag = 574897;//随便写的
     [keyWindow addSubview:blackView];
    if (annimation) {
        
        [UIView animateWithDuration:0.25 animations:^{
          blackView.alpha = 1.0f;
        }];
    }else
    {
        blackView.alpha = 1.0f;
    }
}

/**
 隐藏日历的方法
 
 @param annimation 是否带动画隐藏
 */
+ (void)hideenCalendarWithAnimation:(BOOL)annimation
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *view = [keyWindow viewWithTag:574897];
    
    if ([view isKindOfClass:[XGYCalendarBlackView class]]) {
        XGYCalendarBlackView*vv =(XGYCalendarBlackView *)view;
        [vv hidenCalendarWithAnnimation:annimation];
     
    }
}


/**
 展示滚动日历的方法
 
 @param timeBlock 选择时间后的回调
 @param annimation 是否带动画隐藏
 */
+ (void)showPickerCalendarWithCompleteBlock:(void(^)(NSInteger year, NSInteger month, NSInteger day))timeBlock animation:(BOOL)annimation
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    XGYPickerCalendar  *picker= [[XGYPickerCalendar alloc] initWithFrame:keyWindow.bounds compeletBlock:timeBlock];
    picker.tag = 57489;
    [keyWindow addSubview:picker];
    picker.defaultDate = [NSDate date];
    [UIView animateWithDuration:kShowCalendarAnnimatonTime animations:^{
        picker.alpha = 1.0f;
    }];
    
}

/**
 隐藏滚动日历的方法
 
 @param annimation 是否带动画隐藏
 */
+ (void)hideenPickerCalendarWithAnimation:(BOOL)annimation
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *view = [keyWindow viewWithTag:57489];
   if ([view isKindOfClass:[XGYPickerCalendar class]])
    {
        XGYPickerCalendar*pick =(XGYPickerCalendar *)view;
       [pick hidenPickerCalendarWithAnnimation:annimation];
       
    }
}
/**
 最新的展示日历的方法
 
 @param type 日历的类型
 @param defaultDate 默认显示的日期 如果传空 则表示当前天
 @param timeBlock 选择日期完成时候的回调
 */
+ (void)showCalendarWithCalendarType:(XGYCalendarType)type defaultDate:(NSDate *)defaultDate completeBlock:(void(^)(NSInteger year, NSInteger month, NSInteger day))timeBlock
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    defaultDate = defaultDate?defaultDate:[NSDate date];
    if (type == XGYCalendarType_Page) {
   
        XGYCalendarBlackView *blackView = [[XGYCalendarBlackView alloc] initWithFrame:keyWindow.bounds defaultDate:defaultDate WithCompleteBlock:timeBlock animation:YES];
        blackView.tag = 574897;
        [keyWindow addSubview:blackView];
        [UIView animateWithDuration:kShowCalendarAnnimatonTime animations:^{
            blackView.alpha = 1.0f;
        }];

    }else
    {
        XGYPickerCalendar  *picker= [[XGYPickerCalendar alloc] initWithFrame:keyWindow.bounds compeletBlock:timeBlock];
        picker.tag = 574897;
        [keyWindow addSubview:picker];
  
        picker.defaultDate = defaultDate;
    
        [UIView animateWithDuration:kShowCalendarAnnimatonTime animations:^{
            picker.alpha = 1.0f;
        }];
    }
    

}
/**
 隐藏日历的最新方法
 
 @param annimation 是否带动画隐藏
 */
+ (void)hiddenCalendarAnnimation:(BOOL)annimation
{

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *view = [keyWindow viewWithTag:574897];
    if ([view isKindOfClass:[XGYPickerCalendar class]])
    {
        XGYPickerCalendar*pick =(XGYPickerCalendar *)view;
        [pick hidenPickerCalendarWithAnnimation:annimation];
        
    }else  if ([view isKindOfClass:[XGYCalendarBlackView class]]) {
        XGYCalendarBlackView*vv =(XGYCalendarBlackView *)view;
        [vv hidenCalendarWithAnnimation:annimation];
        
    }else
    {
        [view removeFromSuperview];
        view = nil;
    }
    
    
}


@end
