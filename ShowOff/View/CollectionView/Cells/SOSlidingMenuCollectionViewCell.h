//
//  SOSlidingMenuCollectionViewCell.h
//  ShowOff
//
//  Created by Itay Dressler on 5/6/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOSlidingMenuCollectionViewCell : UICollectionViewCell

#define SOSlidingMenuMenuNormalImageCoverAlpha    0.5f
#define SOSlidingMenuMenuFeaturedImageCoverAlpha  0.2f
#define SOSlidingMenuCellFeatureHeight            240.0f
#define SOSlidingMenuCellCollapsedHeight          85.0f

@property (weak, nonatomic) IBOutlet UIView *imageCover;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

- (void)interpolate:(CGFloat)interpolation;

@end
