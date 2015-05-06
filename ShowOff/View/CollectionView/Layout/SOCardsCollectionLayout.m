//
//  SOCardsCollectionLayout.m
//  ShowOff
//
//  Created by Itay Dressler on 5/5/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOCardsCollectionLayout.h"

#define kANGLE                      0.15
#define kCollectionHeoghtFactor     1.9
#define kTransformFactor            1.0/-500
#define kItemSizeWidthFactor        2.7
#define kItemSizeHeightFactor       1.5

@implementation SOCardsCollectionLayout

- (void)prepareLayout {
    [super prepareLayout];
    [self setupLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}


- (void)setupLayout
{
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width / kItemSizeWidthFactor,
                               self.collectionView.bounds.size.height / kItemSizeHeightFactor);
    self.scrollDirection                = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled   = NO;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attribs = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect;
    visibleRect.origin              = self.collectionView.contentOffset;
    visibleRect.size                = self.collectionView.bounds.size;
    CGFloat collectionViewHeight    = self.collectionView.bounds.size.height / kCollectionHeoghtFactor;
    
    for (UICollectionViewLayoutAttributes *attributes in attribs) {
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            CGFloat cardX           = attributes.center.x;
            CGFloat distance        =  self.collectionView.contentOffset.x + (0.5 * self.collectionView.bounds.size.width);
            CGFloat computedOffset  = cardX  - distance;
            
            CGFloat fractionComputedOffset  = computedOffset /(attributes.bounds.size.width /17.0);
            CGFloat fraction                = computedOffset/ attributes.bounds.size.width;
            
            CGFloat offset              = fabs((fractionComputedOffset)* (1 - fabsf(cosf(fraction))));
            CGFloat yComputedOffset     = collectionViewHeight + offset;
            attributes.center           = CGPointMake(attributes.center.x, yComputedOffset + collectionViewHeight);
            attributes.frame            = CGRectMake(attributes.frame.origin.x, attributes.frame.origin.y, attributes.frame.size.width, attributes.frame.size.width);
            //transform
            attributes.transform3D      = [self transformFromFraction:fraction];
        }
    }
    
    return attribs;
}

- (CATransform3D)transformFromFraction:(CGFloat)fraction
{
    CATransform3D t         = CATransform3DIdentity;
    t.m34                   = kTransformFactor;
    CGFloat radianFraction  = fraction * kANGLE;
    t                       = CATransform3DRotate(t, radianFraction, 0, 0, 1);
    return t;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
