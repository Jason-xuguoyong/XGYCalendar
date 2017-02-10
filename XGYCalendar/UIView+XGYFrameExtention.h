//
//  UIView+XGYFrameExtention.h
//  calendar
//
//  Created by Jason on 2017/2/9.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XGYFrameExtention)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property (nonatomic,assign) CGFloat maxY;
@property (nonatomic,assign) CGFloat maxX;
@end
