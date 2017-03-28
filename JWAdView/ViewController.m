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


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *TestCollectView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger pageIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.TestCollectView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

static NSString *itemId = @"testItem";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TestCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:itemId forIndexPath:indexPath];
    item.lb.text = self.dataArray[indexPath.item];
    return item;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    
//    NSLog(@"-----%lf",targetOffset.x);
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGFloat pageSize = 190;
    NSInteger page = roundf(scrollView.contentOffset.x / pageSize);
    self.pageIndex = page;
    NSLog(@"--------%ld",self.pageIndex);
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = 190;
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
    return CGPointMake(targetX, offset.y);
}

#pragma mark -懒加载
- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        NSArray *arr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
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
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(190, 200);
        flowLayout.minimumLineSpacing = 0.01f;
        flowLayout.minimumInteritemSpacing = 0.01f;
        
        [_TestCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([TestCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:itemId];
    }
    return _TestCollectView;
}

@end
