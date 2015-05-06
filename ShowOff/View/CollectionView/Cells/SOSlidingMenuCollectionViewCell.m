//
//  SOSlidingMenuCollectionViewCell.m
//  ShowOff
//
//  Created by Itay Dressler on 5/6/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOSlidingMenuCollectionViewCell.h"

@interface SOSlidingMenuCollectionViewCell ()

@end

@implementation SOSlidingMenuCollectionViewCell

#pragma mark - UICollectionViewCell methods

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    [super applyLayoutAttributes:layoutAttributes];
    
    CGFloat featureNormaHeightDifference = SOSlidingMenuCellFeatureHeight - SOSlidingMenuCellCollapsedHeight;
    
    // how much its grown from normal to feature
    CGFloat amountGrown = MAX(0,SOSlidingMenuCellFeatureHeight - self.frame.size.height);
    
    // percent of growth from normal to feature
    CGFloat percentOfGrowth = 1 - (amountGrown / featureNormaHeightDifference);
    
    //Curve the percent so that the animations move smoother
    percentOfGrowth = sin(percentOfGrowth * M_PI_2);
    
    [self interpolate:percentOfGrowth];
    
}

- (void)interpolate:(CGFloat)interpolation {
    CGFloat transform = 0.2 + 0.8 * interpolation;
    self.mainLabel.transform = CGAffineTransformMakeScale(transform, transform);
    self.descriptionLabel.alpha = interpolation;
    self.imageCover.alpha = SOSlidingMenuMenuNormalImageCoverAlpha - (interpolation * (SOSlidingMenuMenuNormalImageCoverAlpha - SOSlidingMenuMenuFeaturedImageCoverAlpha));
}

@end
