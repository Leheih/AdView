//
//  BDSSliderView.m
//  JWAdView
//
//  Created by jiajunwei on 2019/1/17.
//  Copyright © 2019年 中再融. All rights reserved.
//

#import "BDSSliderView.h"
#import "TestLayout.h"
#import "TestCollectionViewCell.h"

@interface BDSSliderView () <
UICollectionViewDelegate,
UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger totalItemsCount;
@property (assign, nonatomic) NSInteger pageIndex;

@end

@implementation BDSSliderView

static NSString *BDSSliderViewCellId = @"BDSSliderViewCellId";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)initialization {
    self.infiniteLoop = NO;
    self.pageSpace = 10.0;
    self.itemSize = CGSizeMake(self.frame.size.width * 0.8, self.frame.size.width * 0.6);
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalItemsCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TestCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:BDSSliderViewCellId forIndexPath:indexPath];
    NSInteger index = indexPath.item % self.localizationImageNamesGroup.count;
    item.lb.text = [NSString stringWithFormat:@"%ld",index];
    return item;
}

#pragma mark - 手动滚动

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    
    //    NSLog(@"-----%lf",targetOffset.x);
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = self.itemSize.width + self.pageSpace;
    NSInteger page = roundf(offset.x / pageSize);
    
    NSInteger page2;
    if (page > self.pageIndex) {
        page2 = self.pageIndex + 1;
    } else if (page == self.pageIndex) {
        page2 = self.pageIndex;
    } else {
        page2 = self.pageIndex - 1;
    }
    
    CGFloat targetX = pageSize * page2;
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width - self.pageSpace) * 0.5;
    return CGPointMake(targetX - inset, offset.y);
}


//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//
//
//    CGPoint pInView = [self.view convertPoint:self.TestCollectView.center toView:self.TestCollectView];
//
//    NSIndexPath *currentIndexPath = [self.TestCollectView indexPathForItemAtPoint:pInView];
//    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:3];
//    if (self.dataArray.count) {
//        [self.TestCollectView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    }
//
//
//    [self addTimer];
//
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
//    [self.timer invalidate];
//    self.timer = nil;
    
    CGFloat pageSize = self.itemSize.width + self.pageSpace;
    NSInteger page = roundf(scrollView.contentOffset.x / pageSize);
    self.pageIndex = page;
    NSLog(@"--------%ld",self.pageIndex);
}


#pragma mark - setter

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup {
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.totalItemsCount = self.infiniteLoop ? localizationImageNamesGroup.count * 100 : localizationImageNamesGroup.count;
    [self.collectionView reloadData];
}

//- (void)setInfiniteLoop:(BOOL)infiniteLoop {
//    _infiniteLoop = infiniteLoop;
//    self.localizationImageNamesGroup = self.localizationImageNamesGroup;
//}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        TestLayout *flowLayout = [[TestLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = self.itemSize;
        flowLayout.minimumLineSpacing = self.pageSpace;
        flowLayout.minimumInteritemSpacing = 0.01f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, (self.frame.size.width - self.itemSize.width) / 2.0, 0, (self.frame.size.width - self.itemSize.width) / 2.0);
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TestCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:BDSSliderViewCellId];
    }
    return _collectionView;
}

@end
