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
@property (assign, nonatomic) BOOL isScrollToCenter;

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
    self.infiniteLoop = YES;
    self.pageSpace = 10.0f;
    self.itemSize = CGSizeMake(self.frame.size.width * 0.9, self.frame.size.height * 0.9);
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self scrollToCenter];
}

- (void)scrollToCenter {
    NSInteger targetIndex = self.infiniteLoop == YES ? self.totalItemsCount * 0.5 : 0;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(BDSSliderView:didSelectItemAtIndexPath:)]) {
        [self.delegate BDSSliderView:self didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - 手动滚动

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    //    NSLog(@"-----%lf",targetOffset.x);
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset {
    CGFloat pageSize = self.itemSize.width + self.pageSpace;
    NSInteger page = roundf(offset.x / pageSize);
    NSLog(@"111--%lf",offset.x);
    NSInteger nextPage;
    if (page > self.pageIndex) {
        nextPage = self.pageIndex + 1;
    } else if (page == self.pageIndex) {
        nextPage = self.pageIndex;
    } else {
        nextPage = self.pageIndex - 1;
    }
    if (self.isScrollToCenter == YES) {
        nextPage = self.totalItemsCount * 0.5;
        self.isScrollToCenter = NO;
    }
    CGFloat targetX = pageSize * nextPage;
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
//    [self.timer invalidate];
//    self.timer = nil;
    
    CGFloat pageSize = self.itemSize.width + self.pageSpace;
    NSInteger page = roundf(scrollView.contentOffset.x / pageSize);
    self.pageIndex = page;
    if (page + 1 >= self.totalItemsCount) {
        [self scrollToCenter];
        self.isScrollToCenter = YES;
    }
}

#pragma mark - setter

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup {
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.totalItemsCount = self.infiniteLoop ? localizationImageNamesGroup.count * 2 : localizationImageNamesGroup.count;
    [self.collectionView reloadData];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    if (self.localizationImageNamesGroup.count) {
        self.localizationImageNamesGroup = self.localizationImageNamesGroup;
    }
}

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
        _collectionView.contentInset = UIEdgeInsetsMake(0, (self.frame.size.width - self.itemSize.width ) / 2.0, 0, (self.frame.size.width - self.itemSize.width ) / 2.0);
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TestCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:BDSSliderViewCellId];
    }
    return _collectionView;
}


@end
