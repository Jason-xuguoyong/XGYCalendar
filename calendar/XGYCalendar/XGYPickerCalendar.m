//
//  XGYPickerCalendar.m
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "XGYPickerCalendar.h"
#import "XGYCalendarConfiguration.h"
#import "NSDate+XGYCalendar.h"
@implementation XGYPickerCalendar

/**
 初始化方法
 
 @param frame 所在的位置
 @param timeBlock 选择时间完成后的回调
 @return 返回实例化的对象
 */
- (instancetype)initWithFrame:(CGRect)frame compeletBlock:(void(^)(NSInteger year,NSInteger moth,NSInteger day))timeBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackgroupColor;
        [self creaetUI];
        self.getSelectTime = timeBlock;
        _defaultDate = [NSDate date];
    }
    return self;
}



- (NSMutableArray *)year
{
    if (!_year) {
        _year = [[NSMutableArray alloc] init];
        for (int i = startDateYear; i < endDateYear; i ++) {
            [_year addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _year;
}

- (NSMutableArray *)month
{
    if (!_month) {
        _month = [[NSMutableArray alloc] init];
        for (int i = 1; i < 13; i ++) {
            [_month addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _month;
}

-(void)creaetUI
{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, d_screen_width-30, 235)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    self.bgView.layer.cornerRadius = 5.0f;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.center = self.center;
    

    
    // 选择框
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,self.bgView.frame.size.width, self.bgView.frame.size.height -55)];
    self.pickView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.pickView];

    
    // 显示选中框
    self.pickView.showsSelectionIndicator=YES;
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    
    
   
    UIButton *left = [self setupCalendarHeaderButtonWithFrame:CGRectMake(0, self.bgView.frame.size.height -55,self.bgView.frame.size.width/2.0f, 55)];
    [self.bgView addSubview:left];
    [left setTitle:@"取消" forState:UIControlStateNormal];
    left.tag = 100;
    left.layer.borderWidth = 0.5f;
    left.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIButton *right = [self setupCalendarHeaderButtonWithFrame:CGRectMake(self.bgView.frame.size.width/2.0f+0.5, self.bgView.frame.size.height -55,self.bgView.frame.size.width/2.0f-0.5, 55)];
    [self.bgView addSubview:right];
    [right setTitle:@"确定" forState:UIControlStateNormal];
    right.tag = 101;
    right.layer.borderWidth = 0.5f;
    right.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
}
- (UIButton *)setupCalendarHeaderButtonWithFrame:(CGRect)frame {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (void)buttonClick:(UIButton *)sender
{
    
    if (sender.tag == 101) {
        if (self.getSelectTime) {
            //得到当前的年份 月份
            NSInteger year = [[self.year objectAtIndex:[self.pickView selectedRowInComponent:0]] integerValue];
            NSInteger month = [[self.month objectAtIndex:[self.pickView selectedRowInComponent:1]] integerValue];
            NSInteger day = [self.pickView selectedRowInComponent:2] + 1;
            self.getSelectTime(year,month,day);
            
        }
    }
    [self hidenPickerCalendarWithAnnimation:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.year.count;
    }else if (component == 1)
    {
        return self.month.count;
    }
    
     //得到当前的年份 月份
    int year = [[self.year objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
    int month = [[self.month objectAtIndex:[pickerView selectedRowInComponent:1]] intValue];
   
    switch (month) {
        case 2:
        {
            if((year % 400 == 0)||((year % 4 == 0)&&(year % 100 != 0)))/*闰年29天*/{
                return 29;
            }else
            {
                return 29;
            }
        }
            break;
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
        {
            return 31;
        }
            break;
            
            
        default:
            return 30;
            break;
    }
    return 30;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 80;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        
        return [NSString stringWithFormat:@"%@年",[self.year objectAtIndex:row]];
        
    }else if (component == 1)
    {
        return  [NSString stringWithFormat:@"%@月",[self.month objectAtIndex:row]];
    }
    
    return [NSString stringWithFormat:@"%d日",(int)(row +1)];
    
}

#pragma  mark =================滚动的时候会调用的方法================
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component ==1) {
        
        [pickerView reloadComponent:2];
    }
    
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor =[UIColor lightGrayColor];
        }
    }
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont systemFontOfSize:22]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

- (void)hidenPickerCalendarWithAnnimation:(BOOL)annimation
{
    __weak typeof(self)weakself =self;
     [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    if (annimation) {
        [UIView animateWithDuration:0.25 animations:^{
            weakself.alpha = 0.0;
        }completion:^(BOOL finished) {
            [weakself removeFromSuperview];
            [weakself.pickView removeFromSuperview];
            weakself.pickView = nil;
            [weakself.bgView removeFromSuperview];
            weakself.bgView = nil;
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        }];
    }else
    {   [weakself removeFromSuperview];
        [weakself.pickView removeFromSuperview];
        weakself.pickView = nil;
        [weakself.bgView removeFromSuperview];
        weakself.bgView = nil;
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    __weak typeof(self)weakself =self;
    
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if ([view isKindOfClass:[self class]]) {
        [weakself hidenPickerCalendarWithAnnimation:YES];
    }
    
}

-(void)setDefaultDate:(NSDate *)defaultDate
{
    _defaultDate = defaultDate;
    
    //获取年份
    
   NSInteger year = [[NSDate getDateStringByDate:defaultDate formatter:@"yyyy"] integerValue];
    //获取月份
     NSInteger month = [[NSDate getDateStringByDate:defaultDate formatter:@"MM"] integerValue];
    //获取日
    NSInteger day = [[NSDate getDateStringByDate:defaultDate formatter:@"d"] integerValue];
    
    [self.pickView selectRow:(year- startDateYear) inComponent:0 animated:NO];
    [self.pickView selectRow:month-1 inComponent:1 animated:NO];
    [self.pickView selectRow:day- 1 inComponent:2 animated:NO];

}
@end
