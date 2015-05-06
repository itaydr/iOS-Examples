//
//  SOCollectionLayoutViewController.m
//  ShowOff
//
//  Created by Itay Dressler on 5/5/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOCollectionLayoutViewController.h"
#import "SOCollectionViewCell.h"
#import "SOCardsCollectionLayout.h"

#define kItemSpacing                20
#define kItemPadding                10

@interface SOCollectionLayoutViewController ()

@property (nonatomic, assign)   NSInteger   layoutIndex;
@property (nonatomic, strong)   NSArray     *layouts;
@property (nonatomic, assign)   CGSize      itemSize;

@end

@implementation SOCollectionLayoutViewController

static NSString * const reuseIdentifier = @"imageCell";

#pragma mark LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpLayouts];
    
    self.collectionView.backgroundColor = [UIColor flatPurpleColor];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 3 ? 3 : 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SOCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    NSInteger imageIndex = 10 * indexPath.section + indexPath.row + 1;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg_%ld", (long)imageIndex]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self animateToLayoutAtIndex:++self.layoutIndex];
}

#pragma mark Private

- (void)setUpLayouts {
    
    UICollectionViewLayout *verticalFlow = [self createVerticalFlowLayout];
    self.itemSize = ((UICollectionViewFlowLayout*)verticalFlow).itemSize;
    
    
    self.layouts = @[verticalFlow,
                    [self createHorizontalFlowLayout],
                    [self createSmallItemsLayout],
                    [self createCardsLayout]];
}

- (void)animateToLayoutAtIndex:(NSInteger)index {
    UICollectionViewLayout *layout = self.layouts[index % self.layouts.count];
    
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.collectionView setCollectionViewLayout:layout];
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark LayoutsCreation

- (UICollectionViewLayout*)createVerticalFlowLayout {
    // We created this in the storyboard.
    UICollectionViewFlowLayout *flow    = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    [self setupLayoutSpacing:flow];
    
    return self.collectionViewLayout;
}

- (UICollectionViewLayout*)createHorizontalFlowLayout {
    UICollectionViewFlowLayout *horizontal = [UICollectionViewFlowLayout new];
    horizontal.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    horizontal.itemSize = self.itemSize;
    [self setupLayoutSpacing:horizontal];
    
    return horizontal;
}

- (UICollectionViewLayout*)createCardsLayout {
    SOCardsCollectionLayout *layout = [SOCardsCollectionLayout new];
    return layout;
}

- (UICollectionViewLayout*)createSmallItemsLayout {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [self setupLayoutSpacing:layout];
    NSInteger side = self.collectionView.bounds.size.width / 4;
    layout.itemSize = CGSizeMake(side, side);
    return layout;
}

- (void)setupLayoutSpacing:(UICollectionViewFlowLayout*)flow {
    flow.minimumInteritemSpacing  = kItemSpacing;
    flow.minimumLineSpacing       = kItemSpacing;
    flow.sectionInset             = UIEdgeInsetsMake(kItemPadding, kItemPadding, kItemPadding, kItemPadding);
}

@end
