//
//  XGYCalendarCell.h
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGYCalendarCell : UICollectionViewCell

@property (nonatomic, strong) UIView *todayCircle; //!< 标示'今天'
@property (nonatomic, strong) UILabel *todayLabel; //!< 标示日期（几号）

@end
