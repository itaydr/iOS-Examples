//
//  SOSlidingMenuLayout.m
//  ShowOff
//
//  Created by Itay Dressler on 5/6/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOSlidingMenuLayout.h"
#import "SOSlidingMenuCollectionViewCell.h"

@interface SOSlidingMenuLayout ()

@property (strong, nonatomic) NSDictionary *layoutAttributes;

@end

@implementation SOSlidingMenuLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    NSInteger topFeatureIndex = [self currentCellIndex];
    
    CGFloat topCellsInterpolation =  [self currentCellIndex] - topFeatureIndex;
    
    NSMutableDictionary *layoutAttributes = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath;
    
    // last rect will be used to calculate frames past the first one.  We initialize it to a non junk 0 value
    CGRect lastRect = CGRectMake(0.0f, 0.0f, screenWidth, SOSlidingMenuCellCollapsedHeight);
    NSInteger numItems = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat featureHeight = SOSlidingMenuCellFeatureHeight;
    CGFloat normalHeight = SOSlidingMenuCellCollapsedHeight;
    
    for (NSInteger itemIndex = 0; itemIndex < numItems; itemIndex++) {
        indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.zIndex = itemIndex;
        NSInteger yValue = 0.0f;
        
        if (indexPath.row == topFeatureIndex) {
            // our top feature cell
            CGFloat yOffset = normalHeight  *topCellsInterpolation;
            yValue = self.collectionView.contentOffset.y - yOffset;
            attributes.frame = CGRectMake(0.0f, yValue , screenWidth, featureHeight);
        } else if (indexPath.row == (topFeatureIndex + 1) && indexPath.row != numItems) {
            // the cell after the feature which grows into one as it goes up unless its the last cell (back to top)
            yValue = lastRect.origin.y + lastRect.size.height;
            CGFloat bottomYValue = yValue + normalHeight;
            CGFloat amountToGrow = MAX((featureHeight - normalHeight) *topCellsInterpolation, 0);
            NSInteger newHeight = normalHeight + amountToGrow;
            attributes.frame = CGRectMake(0.0f, bottomYValue - newHeight, screenWidth, newHeight);
        } else {
            // all other cells above or below those on screen
            yValue = lastRect.origin.y + lastRect.size.height;
            attributes.frame = CGRectMake(0.0f, yValue, screenWidth, normalHeight);
        }
        
        lastRect = attributes.frame;
        [layoutAttributes setObject:attributes forKey:indexPath];
    }
    
    self.layoutAttributes = layoutAttributes;
}

- (CGFloat)currentCellIndex {
    return (self.collectionView.contentOffset.y / [SOSlidingMenuLayout slidingCellDragInterval]);
}


- (CGSize)collectionViewContentSize {
    // -1 for the footer
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0] -1;
    CGFloat height = (numberOfItems * [SOSlidingMenuLayout slidingCellDragInterval]) + (self.collectionView.frame.size.height - [SOSlidingMenuLayout slidingCellDragInterval]);
    return CGSizeMake(self.collectionView.frame.size.width, height);
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // create layouts for the rectangles in the view
    NSMutableArray *attributesInRect =  [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in [self.layoutAttributes allValues]) {
        if(CGRectIntersectsRect(rect, attributes.frame)){
            [attributesInRect addObject:attributes];
        }
    }
    
    return attributesInRect;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat proposedPageIndex = roundf(proposedContentOffset.y / [SOSlidingMenuLayout slidingCellDragInterval]);
    CGFloat nearestPageOffset = proposedPageIndex * [SOSlidingMenuLayout slidingCellDragInterval];
    return CGPointMake(0.0f, nearestPageOffset - 46);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

+ (CGFloat)slidingCellDragInterval {
    return  1.8 * 100;
}

@end
