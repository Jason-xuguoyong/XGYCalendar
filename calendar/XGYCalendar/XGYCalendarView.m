//
//  XGYCalendarView.h
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "XGYCalendarView.h"
#import "NSDate+XGYCalendar.h"
#import "XGYCalendarYearView.h"
@interface XGYCalendarView()

@property (nonatomic, strong) UIButton *calendarHeaderButton;
@property (nonatomic, strong) UIView *weekHeaderView;
@property (nonatomic, strong) UIView *datekHeaderView;
@property (nonatomic, strong) XGYCalendarScrollView *calendarScrollView;
@property (nonatomic, strong) XGYCalendarYearView *calendarYearView;
@property (nonatomic,assign) CGFloat width;

@end

@implementation XGYCalendarView


#pragma mark - Initialization

- (instancetype)initWithFrameOrigin:(CGPoint)origin width:(CGFloat)width {
    
    // 根据宽度计算 calender 主体部分的高度
    CGFloat weekLineHight = 0.85 * (width / 7.0);
    CGFloat monthHeight = 6.5 * weekLineHight;
    
    // 星期头部栏高度
    CGFloat weekHeaderHeight = 0.6 * weekLineHight;
    
    // calendar 头部栏高度
    CGFloat calendarHeaderHeight = 1.0 * weekLineHight;
    
    // 最后得到整个 calender 控件的高度
    _calendarHeight = calendarHeaderHeight + weekHeaderHeight + monthHeight;
    
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, _calendarHeight)]) {
        
        self.layer.masksToBounds = YES;
        self.layer.borderColor = kCalendarBasicColor.CGColor;
        self.layer.borderWidth = 2.0 / [UIScreen mainScreen].scale;
        self.layer.cornerRadius = 8.0;
       /*
        _calendarHeaderButton = [self setupCalendarHeaderButtonWithFrame:CGRectMake(0.0, 0.0, width, calendarHeaderHeight)];
        
        
        // 增加左右的点击事件
        UIButton *leftButton = [self setupCalendarHeaderButtonWithFrame:CGRectMake(0.0, 0.0, 30, 30)];
        [_calendarHeaderButton addSubview:leftButton];
        leftButton.backgroundColor = [UIColor redColor];
        leftButton.tag = 100;
        
        UIButton *rightButton = [self setupCalendarHeaderButtonWithFrame:CGRectMake(width-30,0.0 , 30, 30)];
        [_calendarHeaderButton addSubview:rightButton];
        rightButton.backgroundColor = [UIColor redColor];
        rightButton.tag = 101;
        */
        
        
        
        _datekHeaderView = [self setupDateHeadViewWithFrame:CGRectMake(0.0, 0.0, width, calendarHeaderHeight)];
        
        
        _weekHeaderView = [self setupWeekHeadViewWithFrame:CGRectMake(0.0, calendarHeaderHeight, width, weekHeaderHeight)];

        _calendarScrollView = [self setupCalendarScrollViewWithFrame:CGRectMake(0.0, calendarHeaderHeight + weekHeaderHeight, width, monthHeight)];
        
    
        [self addSubview:_datekHeaderView];
        [self addSubview:_weekHeaderView];
        [self addSubview:_calendarScrollView];
        
        _calendarYearView = [self setupCalendarYearViewWithFrame:CGRectMake(0.0, calendarHeaderHeight + weekHeaderHeight, width, monthHeight)];
        [self addSubview:_calendarYearView];
        _calendarYearView.hidden = YES;
        
        // 注册 Notification 监听
        [self addNotificationObserver];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
    
}

- (void)dealloc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIButton *)setupCalendarHeaderButtonWithFrame:(CGRect)frame {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = kCalendarBasicColor;
    [button setTitleColor:kDateAndWeekTextColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(refreshToCurrentMonthAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView *)setupDateHeadViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] init];
    view.frame = frame;
    view.backgroundColor = kCalendarBasicColor;
    
    _calendarHeaderButton = [self setupCalendarHeaderButtonWithFrame:CGRectMake((frame.size.width - 150)/2.0f, 0, 150, frame.size.height)];
    [view addSubview:_calendarHeaderButton];
    
    //上一年
   UIButton *lastYearButton =  [self setupNextAndLastButtonWithframe:CGRectMake(10.0, 0.0, nextAndLastButtonWith, nextAndLastButtonHeight) tag:200 imageName:@"last_year_icon" superView:view];
    
    //下一年
    UIButton *nextYearButton=  [self setupNextAndLastButtonWithframe:CGRectMake(view.width-10-nextAndLastButtonWith, 0.0, nextAndLastButtonWith, nextAndLastButtonHeight) tag:201 imageName:@"next_year_icon" superView:view];
    
    //上一月
    [self setupNextAndLastButtonWithframe:CGRectMake(lastYearButton.maxX + 10, 0.0, nextAndLastButtonWith, nextAndLastButtonHeight) tag:100 imageName:@"last_month_icon" superView:view];
    
    //下一月
     [self setupNextAndLastButtonWithframe:CGRectMake(nextYearButton.x - 10 - nextAndLastButtonWith, 0.0, nextAndLastButtonWith, nextAndLastButtonHeight) tag:101 imageName:@"next_month_icon" superView:view];
    return view;
}

- (UIButton *)setupNextAndLastButtonWithframe:(CGRect)frame tag:(NSInteger)tag imageName:(NSString *)imageName superView:(UIView *)superView
{
    
   UIButton *btn =  [self setupCalendarHeaderButtonWithFrame:frame];
    [superView addSubview:btn];
    btn.centerY =_calendarHeaderButton.centerY;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.tag = tag;
    return btn;
}



- (UIView *)setupWeekHeadViewWithFrame:(CGRect)frame {
    
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width / 7.0;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = kCalendarBasicColor;
    
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < 7; ++i) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * width, 0.0, width, height)];
        label.backgroundColor = [UIColor clearColor];
        label.text = weekArray[i];
        label.textColor = kDateAndWeekTextColor;
        label.font = [UIFont systemFontOfSize:13.5];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
    }
    
    return view;
    
}

- (XGYCalendarScrollView *)setupCalendarScrollViewWithFrame:(CGRect)frame {
    XGYCalendarScrollView *scrollView = [[XGYCalendarScrollView alloc] initWithFrame:frame];
    return scrollView;
}
- (XGYCalendarYearView *)setupCalendarYearViewWithFrame:(CGRect)frame {
    XGYCalendarYearView *yearView = [[XGYCalendarYearView alloc] initWithFrame:frame clickYearCallBackBlock:^(NSString *year) {
        _calendarScrollView.hidden = NO;
        _calendarYearView.hidden = YES;
        [self uploadCalendarWithSelectYear:year];
    }];
    return yearView;
}


- (void)setDidSelectDayHandler:(DidSelectDayHandler)didSelectDayHandler {
    _didSelectDayHandler = didSelectDayHandler;
    if (_calendarScrollView != nil) {
        _calendarScrollView.didSelectDayHandler = _didSelectDayHandler; // 传递 block
    }
}

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCalendarHeaderAction:) name:@"ChangeCalendarHeaderNotification" object:nil];
}


#pragma mark - Actions

- (void)refreshToCurrentMonthAction:(UIButton *)sender {
    
    
    
    
    if (sender.tag == 100) {
        if (_calendarYearView.hidden) {
            [_calendarScrollView lastMonth];
        }
       
    }else if(sender.tag == 101)
    {
         if (_calendarYearView.hidden) {
             [_calendarScrollView nextMonth];
         }
    }else if(sender.tag == 200)
    {
        NSArray *arr =  [_calendarHeaderButton.titleLabel.text componentsSeparatedByString:@"年"];
        
          [self uploadCalendarWithSelectYear:[NSString stringWithFormat:@"%d",[[arr firstObject] intValue] - 1]];
    }else if(sender.tag == 201)
    {
        NSArray *arr =  [_calendarHeaderButton.titleLabel.text componentsSeparatedByString:@"年"];
        
        [self uploadCalendarWithSelectYear:[NSString stringWithFormat:@"%d",[[arr firstObject] intValue] + 1]];
    }else
    {
        _calendarScrollView.hidden = !_calendarScrollView.hidden;
        _calendarYearView.hidden = !_calendarScrollView.hidden;
        
    }
}

/**
 设置默认日期
 */
-(void)setDefaultDate:(NSDate *)defaultDate
{
    _defaultDate = defaultDate;
    [_calendarScrollView refreshToDefaultDate:defaultDate];
    
}

/**
 选中年份的时候更新日历

 @param year 选中的年份
 */
- (void)uploadCalendarWithSelectYear:(NSString *)year
{

    
    [_calendarScrollView refreshWithYear:year];
    
}



- (void)changeCalendarHeaderAction:(NSNotification *)sender {
    
    NSDictionary *dic = sender.userInfo;
    
    NSNumber *year = dic[@"year"];
    NSNumber *month = dic[@"month"];
    
    NSString *title = [NSString stringWithFormat:@"%@年%@月", year, month];
    
    [_calendarHeaderButton setTitle:title forState:UIControlStateNormal];
}


- (void)freeMemory
{
    [_calendarHeaderButton removeFromSuperview];
    _calendarHeaderButton = nil;
    
    [_weekHeaderView removeFromSuperview];
    _weekHeaderView = nil;
    
    [_calendarScrollView removeFromSuperview];
    _calendarScrollView = nil;
    
    
    [_calendarYearView removeFromSuperview];
    _calendarYearView = nil;
}
@end
