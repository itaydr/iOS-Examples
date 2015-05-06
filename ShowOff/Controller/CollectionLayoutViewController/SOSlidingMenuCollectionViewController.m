//
//  SOSlidingMenuCollectionViewController.m
//  ShowOff
//
//  Created by Itay Dressler on 5/6/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOSlidingMenuCollectionViewController.h"
#import "SOSlidingMenuCollectionViewCell.h"
#import "SOSlidingMenuLayout.h"

@interface SOSlidingMenuCollectionViewController ()

@end

@implementation SOSlidingMenuCollectionViewController

static NSString * const reuseIdentifier = @"SOSlidingMenuCollectionViewCell";

#pragma mark LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor flatLimeColor];
    [self.collectionView setCollectionViewLayout:[SOSlidingMenuLayout new]];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 34;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SOSlidingMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    NSInteger imageIndex            = indexPath.row + 1;
    cell.backgroundImageView.image  = [UIImage imageNamed:[NSString stringWithFormat:@"bg_%ld", (long)imageIndex]];
    cell.descriptionLabel.text      = [NSString stringWithFormat:@"Awesome description %ld", (long)imageIndex];
    cell.mainLabel.text             = [NSString stringWithFormat:@"Awesome Title %ld", (long)imageIndex];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark Private



@end
