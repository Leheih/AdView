//
//  BDSSliderView.h
//  JWAdView
//
//  Created by jiajunwei on 2019/1/17.
//  Copyright © 2019年 中再融. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BDSSliderView;
@protocol BDSSliderViewDelagete <NSObject>

- (void)BDSSliderView:(BDSSliderView *)sliderView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BDSSliderView : UIView

/** 本地图片数组 */
@property (nonatomic, strong) NSArray *localizationImageNamesGroup;
/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;
/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;
/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
/** item大小,默认宽高为本视图宽高0.9倍 */
@property (assign, nonatomic) CGSize itemSize;
/** item之间水平方向间距,默认10 */
@property (assign, nonatomic) CGFloat pageSpace;
@property (weak, nonatomic) id<BDSSliderViewDelagete> delegate;


/**
 本地图片卡片式轮播初始化

 @param frame frame
 @param localizationImageNamesGroup 本地图片数组
 @return 轮播view
 */
+ (BDSSliderView *)sliderViewWithFrame:(CGRect)frame localizationImageNamesGroup:(NSArray *)localizationImageNamesGroup;

@end

NS_ASSUME_NONNULL_END

@interface BDSSliderViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

@end
