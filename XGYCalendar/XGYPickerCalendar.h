//
//  XGYPickerCalendar.h
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGYPickerCalendar : UIView<UIPickerViewDataSource,UIPickerViewDelegate>


@property (nonatomic,strong) UIPickerView *pickView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSMutableArray *year;
@property (nonatomic,strong) NSMutableArray *month;
@property (nonatomic,strong) NSMutableArray *day;
@property (nonatomic,strong) NSDate *defaultDate;
/**
 初始化方法

 @param frame 所在的位置
 @param timeBlock 选择时间完成后的回调
 @return 返回实例化的对象
 */
- (instancetype)initWithFrame:(CGRect)frame compeletBlock:(void(^)(NSInteger year,NSInteger moth,NSInteger day))timeBlock;

/**
 隐藏界面的方法

 @param annimation 是否带动画隐藏
 */
- (void)hidenPickerCalendarWithAnnimation:(BOOL)annimation;

/**
 获取选中的时间
 */
@property (nonatomic,strong) void (^getSelectTime)(NSInteger year,NSInteger moth,NSInteger day);

@end
