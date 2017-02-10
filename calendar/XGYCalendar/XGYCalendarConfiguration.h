//
//  XGYCalendarConfiguration.h
//  calendar
//
//  Created by Jason on 2017/2/9.
//  Copyright © 2017年 Jason. All rights reserved.
//

#ifndef XGYCalendarConfiguration_h
#define XGYCalendarConfiguration_h


typedef NS_ENUM(NSInteger, XGYCalendarType) {
    XGYCalendarType_Page = 100, //default
    XGYCalendarType_Picker
};
#import "UIView+XGYFrameExtention.h"

/**
 日历的开始年份（仅对  XGYCalendarType_Picker 有效）
 */
#define startDateYear 1970
/**
 日历的结束年份（仅对  XGYCalendarType_Picker 有效）
 */
#define endDateYear 2100

/**基本色调 （仅对  XGYCalendarType_Page 有效）*/
#define kCalendarBasicColor [UIColor colorWithRed:231.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0]

/**背景蒙层的颜色 */
#define kBackgroupColor   [[UIColor blackColor] colorWithAlphaComponent:0.35]

/**日期（2017年3月）和星期的文字颜色*/
#define kDateAndWeekTextColor [UIColor whiteColor]

/**每一天和每一个年份（选择年份）的颜色*/
#define kEveryDayAndEveryYearTextColor [UIColor blackColor]

/**当前日期圈圈的颜色*/
#define kCurrentDayBackgroundCircleColor [UIColor greenColor]

/**选中日期的圈圈颜色*/
#define kSelectDayBackgroundCircleColor [UIColor blackColor]

/**选中日期的文字颜色*/
#define kSelectDaytextColor [UIColor whiteColor]

/**日历出现时渐变动画的时间*/
#define kShowCalendarAnnimatonTime 0.25

/**点击日期时出现选中的圈圈背景多久后隐藏界面（交互延时时间）*/
#define kSlectedDayAfterDelayHidden 0.1

//上下按钮的大小
#define nextAndLastButtonWith 25
#define nextAndLastButtonHeight 20





#define d_screen_width [UIScreen mainScreen].bounds.size.width
#define d_screen_height [UIScreen mainScreen].bounds.size.height
#endif /* XGYCalendarConfiguration_h */
