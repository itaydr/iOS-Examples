//
//  SOHeaderCollectionLayout.m
//  ShowOff
//
//  Created by Itay Dressler on 5/6/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOHeaderCollectionLayout.h"

#define kPaddingBetweenItems            5
#define kIndexOfSectionHeader           0
#define kItemSide                       140
#define kItemPadding                    20
#define kHeaderHight                    40
#define kTopPadding                     100

@interface SOHeaderCollectionLayout ()

@property (strong, nonatomic) NSDictionary *layoutAttributes;
@property (strong, nonatomic) NSDictionary *layoutAttributesForSupplementaryViews;
@property (nonatomic, assign) BOOL          useNextSuggestedContentOffset;
@property (nonatomic, assign) CGSize        cachedContentSize;


@end

@implementation SOHeaderCollectionLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat collectionWidth = self.collectionView.bounds.size.width;
    
    NSMutableDictionary *layoutAttributes = [NSMutableDictionary dictionary];
    
    NSIndexPath *indexPath;
    CGFloat x, numItemsUntil = 0, solidX;
    CGRect lastRect = CGRectZero;
    CGPoint offset = self.collectionView.contentOffset;
    NSInteger numOfSections = [self.collectionView numberOfSections];
    for (int section = 0 ; section < numOfSections ; section++) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger itemIndex = 0; itemIndex < numItems; itemIndex++) {
            indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:section];
            UICollectionViewLayoutAttributes *attributes;
            
            if (itemIndex == kIndexOfSectionHeader) {
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
                solidX = numItemsUntil * (kItemSide + kPaddingBetweenItems);
                x = MAX(offset.x, solidX);
                attributes.frame = CGRectMake(x, kTopPadding, collectionWidth, kHeaderHight);
            } else {
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                attributes.frame = CGRectMake(lastRect.origin.x + lastRect.size.width + kPaddingBetweenItems,
                                              kTopPadding + kHeaderHight + kPaddingBetweenItems,
                                              kItemSide, kItemSide);
                lastRect = attributes.frame;
                numItemsUntil++;
            }
            
            if (attributes) {
                [layoutAttributes setObject:attributes forKey:indexPath];
            }
        }
    }
    
    // Fix headers
    for (int i = 0 ; i < numOfSections -1; i++) {
        UICollectionViewLayoutAttributes *currentHeader, *nextHeader;
        currentHeader   = [layoutAttributes objectForKey:[NSIndexPath indexPathForRow:0 inSection:i]];
        nextHeader      = [layoutAttributes objectForKey:[NSIndexPath indexPathForRow:0 inSection:i+1]];
        
        CGFloat diff = currentHeader.frame.origin.x + (0.75 * currentHeader.frame.size.width) - nextHeader.frame.origin.x;
        if (diff >= 0) {
            CGRect frame        = currentHeader.frame;
            frame.origin.x      = currentHeader.frame.origin.x - diff;
            currentHeader.frame = frame;
        }
        
    }
    
    
    self.layoutAttributes = layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[indexPath];
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

- (CGSize)collectionViewContentSize {
    
    if (CGSizeEqualToSize(CGSizeZero,self.cachedContentSize)) {
        CGFloat width = 0;
        NSInteger numOfSections = [self.collectionView numberOfSections];
        for (int section = 0 ; section < numOfSections ; section++) {
            width += ([self.collectionView numberOfItemsInSection:section] -2) * (kItemSide + kItemPadding);
        }
        
        self.cachedContentSize = CGSizeMake(width, 250);
    }
    
    return self.cachedContentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end