//
//  ViewController.m
//  collectionView
//
//  Created by 中再融 on 2017/3/24.
//  Copyright © 2017年 中再融. All rights reserved.
//

#import "ViewController.h"
#import "TestLayout.h"
#import "TestCollectionViewCell.h"
#import "BDSSliderView.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define ITEM_WIDTH 200
#define ITRM_HEIGHT 200

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *TestCollectView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self.view addSubview:self.TestCollectView];
    
    
//    [self addTimer]; // 添加定时器
    
    
    
    BDSSliderView *sliderView = [[BDSSliderView alloc] initWithFrame:CGRectMake(20, 100, 300, 200)];
    NSArray *imageArr = @[@"1",@"4",@"4",@"4",@"4",@"4"];
    sliderView.localizationImageNamesGroup = imageArr;
    sliderView.infiniteLoop = NO;
    [self.view addSubview:sliderView];
    
    
}

#pragma mark - 自动滚动
- (void)addTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        CGPoint pInView = [self.view convertPoint:self.TestCollectView.center toView:self.TestCollectView];
        
        NSIndexPath *currentIndexPath = [self.TestCollectView indexPathForItemAtPoint:pInView];
        NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:3];
        if (self.dataArray.count) {
            [self.TestCollectView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        
        
        //下一个展示位置
        NSInteger nextItem = currentIndexPathReset.item + 1;
        NSInteger nextSection = currentIndexPathReset.section;
        if (nextItem == self.dataArray.count) {
            nextItem = 0;
            nextSection ++;
        }
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
        
        [self.TestCollectView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        NSLog(@"%ld  %ld",currentIndexPath.item,currentIndexPath.section);
        
    }];
    
}

#pragma mark -
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    return 5;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count * 50;
}

static NSString *itemId = @"testItem";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TestCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:itemId forIndexPath:indexPath];
    NSInteger index = indexPath.item % self.dataArray.count;
    item.lb.text = self.dataArray[index];
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
    CGFloat pageSize = ITEM_WIDTH + 10;
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
    CGFloat inset = (self.TestCollectView.frame.size.width - ITEM_WIDTH - 10) * 0.5;
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


    [self.timer invalidate];
    self.timer = nil;

    CGFloat pageSize = ITEM_WIDTH + 10;
    NSInteger page = roundf(scrollView.contentOffset.x / pageSize);
    self.pageIndex = page;
    NSLog(@"--------%ld",self.pageIndex);
}



#pragma mark -懒加载
- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        NSArray *arr = @[@"1",@"2",@"3",@"4"];
        _dataArray = [NSMutableArray arrayWithArray:arr];
    }
    return _dataArray;
}

- (UICollectionView *)TestCollectView {
    
    if (_TestCollectView == nil) {
        
        TestLayout *flowLayout = [[TestLayout alloc] init];
        _TestCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 100, 350, 400) collectionViewLayout:flowLayout];
        _TestCollectView.delegate = self;
        _TestCollectView.dataSource = self;
        _TestCollectView.backgroundColor = [UIColor grayColor];
        _TestCollectView.contentInset = UIEdgeInsetsMake(0, (400 - ITEM_WIDTH) / 2.0, 0, (400 - ITEM_WIDTH) / 2.0);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(ITEM_WIDTH, ITRM_HEIGHT);
        flowLayout.minimumLineSpacing = 10.f;
        flowLayout.minimumInteritemSpacing = 0.01f;
        
        [_TestCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([TestCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:itemId];
        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
//        [self.TestCollectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    return _TestCollectView;
}

@end
