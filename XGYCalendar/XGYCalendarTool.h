//
//  XGYCalendarTool.h
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XGYCalendarConfiguration.h"





@interface XGYCalendarTool : NSObject

/**
 最新的展示日历的方法
 
 @param type 日历的类型
 @param defaultDate 默认显示的日期 如果传空 则表示当前天
 @param timeBlock 选择日期完成时候的回调
 */
+ (void)showCalendarWithCalendarType:(XGYCalendarType)type defaultDate:(NSDate *)defaultDate completeBlock:(void(^)(NSInteger year, NSInteger month, NSInteger day))timeBlock;



/**
 隐藏日历的最新方法

 @param annimation 是否带动画隐藏
 */
+ (void)hiddenCalendarAnnimation:(BOOL)annimation;




/**
 展示日历的方法

 @param timeBlock 点击某一天的时间的回调
 */
+ (void)showCalendarWithCompleteBlock:(void(^)(NSInteger year, NSInteger month, NSInteger day))timeBlock animation:(BOOL)annimation NS_DEPRECATED_IOS(2_0, 3_0, "已废弃，请使用 showCalendarWithCalendarType:defaultDate:completeBlock来代替") __TVOS_PROHIBITED;

/**
 隐藏日历的方法

 @param annimation 是否带动画隐藏
 */
+ (void)hideenCalendarWithAnimation:(BOOL)annimation NS_DEPRECATED_IOS(2_0, 3_0, "已废弃，请使用 hiddenCalendarAnnimation来代替") __TVOS_PROHIBITED;


/**
 展示滚动日历的方法

 @param timeBlock 选择时间后的回调
 @param annimation 是否带动画隐藏
 */
+ (void)showPickerCalendarWithCompleteBlock:(void(^)(NSInteger year, NSInteger month, NSInteger day))timeBlock animation:(BOOL)annimation NS_DEPRECATED_IOS(2_0, 3_0, "已废弃，请使用 showCalendarWithCalendarType:defaultDate:completeBlock来代替") __TVOS_PROHIBITED;;

/**
 隐藏滚动日历的方法
 
 @param annimation 是否带动画隐藏
 */
+ (void)hideenPickerCalendarWithAnimation:(BOOL)annimation NS_DEPRECATED_IOS(2_0, 3_0, "已废弃，请使用 hiddenCalendarAnnimation来代替") __TVOS_PROHIBITED;



@end
