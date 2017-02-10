//
//  XGYCalendarYearView.h
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGYCalendarYearView : UIView

/**
 初始化方法

 @param frame 位置
 @param yearBlock 点击年份的时候的回调
 @return 返回对象
 */
- (instancetype)initWithFrame:(CGRect)frame clickYearCallBackBlock:(void(^)(NSString *year))yearBlock;


@end
