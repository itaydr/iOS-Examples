//
//  SOImageControl.m
//  ShowOff
//
//  Created by Itay Dressler on 5/6/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOImageControl.h"

@interface SOImageControl ()
@property(nonatomic) UIImageView *imageView;
@end

@implementation SOImageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView];
    }
    return self;
}

#pragma mark - Property Setters

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
    _image = image;
}

@end
