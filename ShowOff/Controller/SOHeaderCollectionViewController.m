//
//  SOHeaderCollectionViewController.m
//  ShowOff
//
//  Created by Itay Dressler on 5/6/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOHeaderCollectionViewController.h"
#import "SOCollectionViewCell.h"
#import "SOHeaderCollectionReusableView.h"
#import "SOHeaderCollectionLayout.h"

@interface SOHeaderCollectionViewController ()

@end

@implementation SOHeaderCollectionViewController

static NSString * const reuseIdentifier = @"imageCell";

#pragma mark LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor flatWatermelonColor];
    [self.collectionView setCollectionViewLayout:[SOHeaderCollectionLayout new]];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (section == 3 ? 3 : 10) + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SOCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    NSInteger imageIndex = 10 * indexPath.section + indexPath.row;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg_%ld", (long)imageIndex]];
    cell.backgroundColor = [UIColor flatGrayColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SOHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                withReuseIdentifier:@"SOHeaderCollectionReusableView" forIndexPath:indexPath];
    
    header.titleLabel.text = [NSString stringWithFormat:@"Great Header %d", indexPath.section + 1];
    return header;
}

@end
