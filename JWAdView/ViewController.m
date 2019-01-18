//
//  ViewController.m
//  collectionView
//
//  Created by 中再融 on 2017/3/24.
//  Copyright © 2017年 中再融. All rights reserved.
//

#import "ViewController.h"
#import "BDSSliderView.h"

@interface ViewController () <BDSSliderViewDelagete>

@property (nonatomic,strong) UICollectionView *TestCollectView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSArray *imageArr = @[@"1",@"3",@"4",@"5",@"6",@"7"];
    BDSSliderView *sliderView = [BDSSliderView sliderViewWithFrame:CGRectMake(20, 100, 300, 200) localizationImageNamesGroup:imageArr];
    sliderView.infiniteLoop = YES;
    sliderView.delegate = self;
    sliderView.autoScroll = YES;
    sliderView.autoScrollTimeInterval = 2.5;
//    sliderView.itemSize = CGSizeMake(200, 100);
    sliderView.pageSpace = 10.0f;
    [self.view addSubview:sliderView];
}

- (void)BDSSliderView:(BDSSliderView *)sliderView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.row);
}

@end
