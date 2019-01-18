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
@property (strong, nonatomic) BDSSliderView *sliderVeiw;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSArray *imageArr = @[@"1",@"3",@"4",@"5",@"6",@"7"];
    BDSSliderView *sliderView = [BDSSliderView sliderViewWithFrame:CGRectMake(20, 100, 300, 200) localizationImageNamesGroup:imageArr];
//    sliderView.infiniteLoop = YES;
    sliderView.delegate = self;
    sliderView.autoScroll = NO;
    sliderView.autoScrollTimeInterval = 2.5;
//    sliderView.itemSize = CGSizeMake(200, 100);
    sliderView.pageSpace = 10.0f;
    
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
//    sliderView.imageURLStringsGroup = imagesURLStrings;
    [self.view addSubview:sliderView];
    self.sliderVeiw = sliderView;
}

- (void)BDSSliderView:(BDSSliderView *)sliderView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *imageArr = @[@"1",@"3"];
    self.sliderVeiw.localizationImageNamesGroup = imageArr;
}

@end
