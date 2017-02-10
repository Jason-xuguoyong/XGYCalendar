//
//  XGYYearItemCell.m
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "XGYYearItemCell.h"
#import "XGYCalendarConfiguration.h"
@implementation XGYYearItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        self.yearButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [self.contentView addSubview:self.yearButton];
        self.yearButton.frame = self.bounds;

        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.yearButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.yearButton setTitleColor:kEveryDayAndEveryYearTextColor forState:UIControlStateNormal];
        self.yearButton.backgroundColor =[UIColor  whiteColor];
        self.yearButton.userInteractionEnabled = NO;
    }
    return self;
}
@end
