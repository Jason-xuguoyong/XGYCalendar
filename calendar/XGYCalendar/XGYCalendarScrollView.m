//
//  XGYCalendarScrollView.m
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "XGYCalendarScrollView.h"
#import "XGYCalendarCell.h"
#import "XGYCalendarMonth.h"
#import "NSDate+XGYCalendar.h"

@interface XGYCalendarScrollView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionViewL;
@property (nonatomic, strong) UICollectionView *collectionViewM;
@property (nonatomic, strong) UICollectionView *collectionViewR;

@property (nonatomic, strong) NSDate *currentMonthDate;

@property (nonatomic, strong) NSMutableArray *monthArray;

@end

@implementation XGYCalendarScrollView


static NSString *const kCellIdentifier = @"cell";


#pragma mark - Initialiaztion

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.delegate = self;
        
        self.contentSize = CGSizeMake(3 * self.bounds.size.width, self.bounds.size.height);
        [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO];
        
        _currentMonthDate = [NSDate date];
        [self setupCollectionViews];
        
    }
    
    return self;
    
}

- (NSMutableArray *)monthArray {
    
    if (_monthArray == nil) {
        
        _monthArray = [NSMutableArray arrayWithCapacity:4];
        
        NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
        
        [_monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:previousMonthDate]];
        [_monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:_currentMonthDate]];
        [_monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:nextMonthDate]];
        [_monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]]; // 存储左边的月份的前一个月份的天数，用来填充左边月份的首部
        
        // 发通知，更改当前月份标题
        [self notifyToChangeCalendarHeader];
    }
    
    return _monthArray;
}

- (NSNumber *)previousMonthDaysForPreviousDate:(NSDate *)date {
    return [[NSNumber alloc] initWithInteger:[[date previousMonthDate] totalDaysInMonth]];
}


- (void)setupCollectionViews {
        
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width / 7.0, self.bounds.size.width / 7.0 * 0.85);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    _collectionViewL = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewL.dataSource = self;
    _collectionViewL.delegate = self;
    _collectionViewL.backgroundColor = [UIColor clearColor];
    [_collectionViewL registerClass:[XGYCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewL];
    
    _collectionViewM = [[UICollectionView alloc] initWithFrame:CGRectMake(selfWidth, 0.0, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewM.dataSource = self;
    _collectionViewM.delegate = self;
    _collectionViewM.backgroundColor = [UIColor clearColor];
    [_collectionViewM registerClass:[XGYCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewM];
    
    _collectionViewR = [[UICollectionView alloc] initWithFrame:CGRectMake(2 * selfWidth, 0.0, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewR.dataSource = self;
    _collectionViewR.delegate = self;
    _collectionViewR.backgroundColor = [UIColor clearColor];
    [_collectionViewR registerClass:[XGYCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewR];

}


#pragma mark -

- (void)notifyToChangeCalendarHeader {
    
    XGYCalendarMonth *currentMonthInfo = self.monthArray[1];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.year] forKey:@"year"];
    [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.month] forKey:@"month"];
    
    NSNotification *notify = [[NSNotification alloc] initWithName:@"ChangeCalendarHeaderNotification" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}

- (void)refreshToCurrentMonth {
    
    // 如果现在就在当前月份，则不执行操作
    XGYCalendarMonth *currentMonthInfo = self.monthArray[1];
    if ((currentMonthInfo.month == [[NSDate date] dateMonth]) && (currentMonthInfo.year == [[NSDate date] dateYear])) {
        return;
    }
    
    _currentMonthDate = [NSDate date];
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    
    // 刷新数据
    [_collectionViewM reloadData];
    [_collectionViewL reloadData];
    [_collectionViewR reloadData];
    
}


/**
 设置默认的日期
 */
- (void)refreshToDefaultDate:(NSDate *)defaultDate
{
    // 如果现在就在当前月份，则不执行操作
    XGYCalendarMonth *currentMonthInfo = self.monthArray[1];
    if ((currentMonthInfo.month == [defaultDate dateMonth]) && (currentMonthInfo.year == [defaultDate dateYear])) {
        return;
    }
    
    _currentMonthDate = defaultDate;
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    
    // 刷新数据
    [_collectionViewM reloadData];
    [_collectionViewL reloadData];
    [_collectionViewR reloadData];
}

-(void)refreshWithYear:(NSString *)year
{
    // 如果现在就在当前年份，则不执行操作
    XGYCalendarMonth *currentMonthInfo = self.monthArray[1];
    if ([year integerValue] == currentMonthInfo.year) {
        return;
    }
    
    NSDateFormatter *dateToStringFormatter=[[NSDateFormatter alloc] init];
    [dateToStringFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateToStringFormatter setTimeZone:GTMzone];
    
    
      NSString *oldMonth = [dateToStringFormatter stringFromDate:_currentMonthDate];
    
    
    //替换年份
    NSString *allDateString = [NSString stringWithFormat:@"%@-%@",year,oldMonth];
    //将时间字符串转成日期NSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //得到转换后的日期
    _currentMonthDate = [dateFormatter dateFromString:allDateString];
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[XGYCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    
    // 刷新数据
    [_collectionViewM reloadData];
    [_collectionViewL reloadData];
    [_collectionViewR reloadData];
    
    // 发通知，更改当前月份标题
    [self notifyToChangeCalendarHeader];
}

#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42; // 7 * 6
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XGYCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (collectionView == _collectionViewL) {
        
        XGYCalendarMonth *monthInfo = self.monthArray[0];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row - firstWeekday + 1)];
            cell.todayLabel.textColor = kEveryDayAndEveryYearTextColor;
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    /*
                     1 先把今天的日期设置成另外一个颜色
                     */
                    
                    cell.todayCircle.backgroundColor =kCurrentDayBackgroundCircleColor;
                    
                    cell.todayLabel.textColor = kSelectDaytextColor;
                } else {
                    cell.todayCircle.backgroundColor = [UIColor clearColor];
                }
            } else {
                cell.todayCircle.backgroundColor = [UIColor clearColor];
            }
            
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            int totalDaysOflastMonth = [self.monthArray[3] intValue];
            cell.todayLabel.text = [NSString stringWithFormat:@"%d", (int)(totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1)];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row - firstWeekday - totalDays + 1)];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
        }
        
        cell.userInteractionEnabled = NO;
        
    }
    else if (collectionView == _collectionViewM) {
        
        XGYCalendarMonth *monthInfo = self.monthArray[1];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row - firstWeekday + 1)];
            cell.todayLabel.textColor = kEveryDayAndEveryYearTextColor;
            cell.userInteractionEnabled = YES;
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    
                    /*
                     1 先把今天的日期设置成另外一个颜色
                     */
                    cell.todayCircle.backgroundColor = kCurrentDayBackgroundCircleColor;
                    
                    cell.todayLabel.textColor = kSelectDaytextColor;
                } else {
                    cell.todayCircle.backgroundColor = [UIColor clearColor];
                }
            } else {
                cell.todayCircle.backgroundColor = [UIColor clearColor];
            }
            
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            XGYCalendarMonth *lastMonthInfo = self.monthArray[0];
            NSInteger totalDaysOflastMonth = lastMonthInfo.totalDays;
            cell.todayLabel.text = [NSString stringWithFormat:@"%d", (int)(totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1)];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = NO;
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row - firstWeekday - totalDays + 1)];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = NO;
        }
        
    }
    else if (collectionView == _collectionViewR) {
        
        XGYCalendarMonth *monthInfo = self.monthArray[2];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            
            cell.todayLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row - firstWeekday + 1)];
            cell.todayLabel.textColor = kEveryDayAndEveryYearTextColor;
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    /*
                     1 先把今天的日期设置成另外一个颜色
                     */
                    cell.todayCircle.backgroundColor = kCurrentDayBackgroundCircleColor;
                    cell.todayLabel.textColor = kSelectDaytextColor;
                } else {
                    cell.todayCircle.backgroundColor = [UIColor clearColor];
                }
            } else {
                cell.todayCircle.backgroundColor = [UIColor clearColor];
            }
            
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            XGYCalendarMonth *lastMonthInfo = self.monthArray[1];
            NSInteger totalDaysOflastMonth = lastMonthInfo.totalDays;
            cell.todayLabel.text = [NSString stringWithFormat:@"%d", (int)(totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1)];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%d", (int)(indexPath.row - firstWeekday - totalDays + 1)];
            cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
        }
        
        cell.userInteractionEnabled = NO;
        
    }
    
    return cell;
    
}


#pragma mark - UICollectionViewDeleagate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.didSelectDayHandler != nil) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:_currentMonthDate];
        NSDate *currentDate = [calendar dateFromComponents:components];
        
        //2  获取到当前点击的Cell 然后改变一下小圈圈的颜色
        XGYCalendarCell *cell = (XGYCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
       
        cell.todayCircle.backgroundColor = kSelectDayBackgroundCircleColor;
         cell.todayLabel.textColor = kSelectDaytextColor;
        
        // 3 GCD延时调用一下Block 让用户点击时候可以看到小圈圈
        __weak typeof(self)weakself =self;
        //4 设置延时时间
        CGFloat afterTime = kSlectedDayAfterDelayHidden;
        //禁用所有点击事件
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSInteger year = [currentDate dateYear];
                NSInteger month = [currentDate dateMonth];
                NSInteger day = [cell.todayLabel.text integerValue];
                weakself.didSelectDayHandler(year, month, day); // 执行回调
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
            });
        });
    }
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self) {
        return;
    }
    
    // 向右滑动
    if (scrollView.contentOffset.x < self.bounds.size.width) {
        
        _currentMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *previousDate = [_currentMonthDate previousMonthDate];
        
        // 数组中最左边的月份现在作为中间的月份，中间的作为右边的月份，新的左边的需要重新获取
        XGYCalendarMonth *currentMothInfo = self.monthArray[0];
        XGYCalendarMonth *nextMonthInfo = self.monthArray[1];
        
        
        XGYCalendarMonth *olderNextMonthInfo = self.monthArray[2];
        
        // 复用 XGYCalendarMonth 对象
        olderNextMonthInfo.totalDays = [previousDate totalDaysInMonth];
        olderNextMonthInfo.firstWeekday = [previousDate firstWeekDayInMonth];
        olderNextMonthInfo.year = [previousDate dateYear];
        olderNextMonthInfo.month = [previousDate dateMonth];
        XGYCalendarMonth *previousMonthInfo = olderNextMonthInfo;
        
        NSNumber *prePreviousMonthDays = [self previousMonthDaysForPreviousDate:[_currentMonthDate previousMonthDate]];
        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    // 向左滑动
    else if (scrollView.contentOffset.x > self.bounds.size.width) {
        
        _currentMonthDate = [_currentMonthDate nextMonthDate];
        NSDate *nextDate = [_currentMonthDate nextMonthDate];
        
        // 数组中最右边的月份现在作为中间的月份，中间的作为左边的月份，新的右边的需要重新获取
        XGYCalendarMonth *previousMonthInfo = self.monthArray[1];
        XGYCalendarMonth *currentMothInfo = self.monthArray[2];
        
        
        XGYCalendarMonth *olderPreviousMonthInfo = self.monthArray[0];
        
        NSNumber *prePreviousMonthDays = [[NSNumber alloc] initWithInteger:olderPreviousMonthInfo.totalDays]; // 先保存 olderPreviousMonthInfo 的月天数
        
        // 复用 XGYCalendarMonth 对象
        olderPreviousMonthInfo.totalDays = [nextDate totalDaysInMonth];
        olderPreviousMonthInfo.firstWeekday = [nextDate firstWeekDayInMonth];
        olderPreviousMonthInfo.year = [nextDate dateYear];
        olderPreviousMonthInfo.month = [nextDate dateMonth];
        XGYCalendarMonth *nextMonthInfo = olderPreviousMonthInfo;

        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    
    [_collectionViewM reloadData]; // 中间的 collectionView 先刷新数据
    [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO]; // 然后变换位置
    [_collectionViewL reloadData]; // 最后两边的 collectionView 也刷新数据
    [_collectionViewR reloadData];
    
    // 发通知，更改当前月份标题
    [self notifyToChangeCalendarHeader];
    
}

- (void)nextMonth
{
    _currentMonthDate = [_currentMonthDate nextMonthDate];
    NSDate *nextDate = [_currentMonthDate nextMonthDate];
    
    // 数组中最右边的月份现在作为中间的月份，中间的作为左边的月份，新的右边的需要重新获取
    XGYCalendarMonth *previousMonthInfo = self.monthArray[1];
    XGYCalendarMonth *currentMothInfo = self.monthArray[2];
    
    
    XGYCalendarMonth *olderPreviousMonthInfo = self.monthArray[0];
    
    NSNumber *prePreviousMonthDays = [[NSNumber alloc] initWithInteger:olderPreviousMonthInfo.totalDays]; // 先保存 olderPreviousMonthInfo 的月天数
    
    // 复用 XGYCalendarMonth 对象
    olderPreviousMonthInfo.totalDays = [nextDate totalDaysInMonth];
    olderPreviousMonthInfo.firstWeekday = [nextDate firstWeekDayInMonth];
    olderPreviousMonthInfo.year = [nextDate dateYear];
    olderPreviousMonthInfo.month = [nextDate dateMonth];
    XGYCalendarMonth *nextMonthInfo = olderPreviousMonthInfo;
    
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:previousMonthInfo];
    [self.monthArray addObject:currentMothInfo];
    [self.monthArray addObject:nextMonthInfo];
    [self.monthArray addObject:prePreviousMonthDays];
    [_collectionViewM reloadData]; // 中间的 collectionView 先刷新数据
    [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO]; // 然后变换位置
    [_collectionViewL reloadData]; // 最后两边的 collectionView 也刷新数据
    [_collectionViewR reloadData];
    
    // 发通知，更改当前月份标题
    [self notifyToChangeCalendarHeader];
}
-(void)lastMonth
{
    _currentMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *previousDate = [_currentMonthDate previousMonthDate];
    
    // 数组中最左边的月份现在作为中间的月份，中间的作为右边的月份，新的左边的需要重新获取
    XGYCalendarMonth *currentMothInfo = self.monthArray[0];
    XGYCalendarMonth *nextMonthInfo = self.monthArray[1];
    
    
    XGYCalendarMonth *olderNextMonthInfo = self.monthArray[2];
    
    // 复用 XGYCalendarMonth 对象
    olderNextMonthInfo.totalDays = [previousDate totalDaysInMonth];
    olderNextMonthInfo.firstWeekday = [previousDate firstWeekDayInMonth];
    olderNextMonthInfo.year = [previousDate dateYear];
    olderNextMonthInfo.month = [previousDate dateMonth];
    XGYCalendarMonth *previousMonthInfo = olderNextMonthInfo;
    
    NSNumber *prePreviousMonthDays = [self previousMonthDaysForPreviousDate:[_currentMonthDate previousMonthDate]];
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:previousMonthInfo];
    [self.monthArray addObject:currentMothInfo];
    [self.monthArray addObject:nextMonthInfo];
    [self.monthArray addObject:prePreviousMonthDays];
    
    [_collectionViewM reloadData]; // 中间的 collectionView 先刷新数据
    [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO]; // 然后变换位置
    [_collectionViewL reloadData]; // 最后两边的 collectionView 也刷新数据
    [_collectionViewR reloadData];
    
    // 发通知，更改当前月份标题
    [self notifyToChangeCalendarHeader];
}



@end
