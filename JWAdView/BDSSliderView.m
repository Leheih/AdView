//
//  BDSSliderView.m
//  JWAdView
//
//  Created by jiajunwei on 2019/1/17.
//  Copyright © 2019年 中再融. All rights reserved.
//

#import "BDSSliderView.h"
#import "TestLayout.h"

@interface BDSSliderView () <
UICollectionViewDelegate,
UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger totalItemsCount;
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) BOOL isScrollToCenter;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) TestLayout *flowLayout;

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
    self.autoScroll = YES;
    self.pageSpace = 10.0f;
    self.itemSize = CGSizeMake(self.frame.size.width * 0.9, self.frame.size.height * 0.9);
    self.autoScrollTimeInterval = 2.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self scrollToCenter];
}

- (void)scrollToCenter {
    if (self.localizationImageNamesGroup.count == 0) return;
    NSInteger targetIndex = self.infiniteLoop == YES ? self.totalItemsCount * 0.5 : 0;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalItemsCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BDSSliderViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:BDSSliderViewCellId forIndexPath:indexPath];
    NSInteger index = indexPath.item % self.localizationImageNamesGroup.count;
    item.imageView.image = [UIImage imageNamed:self.localizationImageNamesGroup[index]];
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(BDSSliderView:didSelectItemAtIndex:)]) {
        [self.delegate BDSSliderView:self didSelectItemAtIndex:(indexPath.item % self.localizationImageNamesGroup.count)];
    }
}

#pragma mark - 自动滚动

- (void)addTimer {
    [self invalidateTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(autoScrollNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)autoScrollNextPage {
    //下一个展示位置
    NSInteger nextItem = [self currentIndexPathReset].item + 1;
    if (nextItem >= self.totalItemsCount) {
        [self scrollToCenter];
        return;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (NSIndexPath *)currentIndexPathReset {
    CGPoint pInView = [self convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:pInView];
    return [NSIndexPath indexPathForItem:currentIndexPath.item inSection:0];
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 手动滚动

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset {
    CGFloat pageSize = self.itemSize.width + self.pageSpace;
    NSInteger page = roundf(offset.x / pageSize);
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.autoScroll = self.autoScroll;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self invalidateTimer];
    CGFloat pageSize = self.itemSize.width + self.pageSpace;
    NSInteger page = roundf(scrollView.contentOffset.x / pageSize);
    self.pageIndex = page;
    if (page + 1 >= self.totalItemsCount && self.infiniteLoop == YES) {
        [self scrollToCenter];
        self.isScrollToCenter = YES;
    }
}

#pragma mark - setter

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup {
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.totalItemsCount = self.infiniteLoop ? localizationImageNamesGroup.count * 100 : localizationImageNamesGroup.count;
//    [self.collectionView reloadData];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    if (self.localizationImageNamesGroup.count) {
        self.localizationImageNamesGroup = self.localizationImageNamesGroup;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (autoScroll) {
        [self addTimer];
    }
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    [self updateFlowLayout];
}

- (void)setPageSpace:(CGFloat)pageSpace {
    _pageSpace = pageSpace;
    [self updateFlowLayout];
}

- (void)updateFlowLayout {
    self.flowLayout.itemSize = self.itemSize;
    self.flowLayout.minimumLineSpacing = self.pageSpace;
    self.flowLayout.minimumInteritemSpacing = 0.01f;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, (self.frame.size.width - self.itemSize.width ) / 2.0, 0, (self.frame.size.width - self.itemSize.width ) / 2.0);
}

+ (BDSSliderView *)sliderViewWithFrame:(CGRect)frame localizationImageNamesGroup:(NSArray *)localizationImageNamesGroup {
    BDSSliderView *sliderView = [[BDSSliderView alloc] initWithFrame:frame];
    sliderView.localizationImageNamesGroup = localizationImageNamesGroup;
    return sliderView;
}

#pragma mark - lazy

- (TestLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[TestLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor grayColor];
        [_collectionView registerClass:[BDSSliderViewCell class] forCellWithReuseIdentifier:BDSSliderViewCellId];
    }
    return _collectionView;
}

@end

@implementation BDSSliderViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end
