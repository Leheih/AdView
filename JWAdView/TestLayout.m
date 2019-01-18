//
//  TestLayout.m
//  collectionView
//
//  Created by 中再融 on 2017/3/24.
//  Copyright © 2017年 中再融. All rights reserved.
//

#import "TestLayout.h"

@implementation TestLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 获得super已经计算好的布局属性
    NSArray *attributes = [[NSArray alloc] initWithArray:array copyItems:YES];
    // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in attributes) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = fabs(attrs.center.x - centerX);
        // 根据间距值 计算 cell的缩放比例
        CGFloat scale = delta / self.collectionView.frame.size.width;
        //把卡片移动范围固定到 -π/4到 +π/4这一个范围内
        scale = fabs(cos(scale * M_PI/4));
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(1, scale);
    }
    return  attributes;
}

@end
