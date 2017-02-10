//
//  XGYCalendarYearView.m
//  calendar
//
//  Created by Jason on 2017/2/8.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "XGYCalendarYearView.h"
#import "XGYYearItemCell.h"
@interface XGYCalendarYearView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) void(^getYearBlock)(NSString *year);

@property (nonatomic, strong) NSMutableArray *yearArray;

@end
@implementation XGYCalendarYearView

- (instancetype)initWithFrame:(CGRect)frame clickYearCallBackBlock:(void(^)(NSString *year))yearBlock;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollectionViews];
        _getYearBlock = yearBlock;
    }
    return self;
}

-(NSMutableArray *)yearArray
{
    if (!_yearArray) {
        _yearArray = [[NSMutableArray alloc] init];
        for (int i = 1970; i < 2100; i ++) {
            [_yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _yearArray;
}
- (void)setupCollectionViews {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 40);
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.minimumInteritemSpacing = 10.0;
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [_collectionView registerClass:[XGYYearItemCell class] forCellWithReuseIdentifier:@"year"];
    [self addSubview:_collectionView];

}

#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.yearArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XGYYearItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"year" forIndexPath:indexPath];
    NSString *year = [self.yearArray objectAtIndex:indexPath.item];
    [cell.yearButton setTitle:year forState:UIControlStateNormal];
    return cell;
    
}


#pragma mark - UICollectionViewDeleagate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *year = [self.yearArray objectAtIndex:indexPath.item];
    if (_getYearBlock) {
        _getYearBlock(year);
    }
    
}

@end
