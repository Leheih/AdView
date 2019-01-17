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
@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) CGFloat pageSpace;

@property (weak, nonatomic) id<BDSSliderViewDelagete> delegate;

@end

NS_ASSUME_NONNULL_END
