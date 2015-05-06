//
//  SOImageAnimationViewController.m
//  ShowOff
//
//  Created by Itay Dressler on 5/6/15.
//  Copyright (c) 2015 dressler. All rights reserved.
//

#import "SOImageAnimationViewController.h"
#import "SOImageControl.h"

#define kHeightFactor           0.75f
#define kPositionAnimationKey   @"layerPositionAnimation"
#define kScaleAnimationKey      @"scaleAnimation"

@interface SOImageAnimationViewController ()
@property (nonatomic, strong)   SOImageControl  *imageControl;
@end

@implementation SOImageAnimationViewController

#pragma mark Tweaks

+ (BOOL)isInDecayState {
    return YES;
}

#pragma mark LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addImageView];
}

#pragma mark  Private

- (void)addImageView
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    
    CGFloat width               = self.view.bounds.size.width - 20.f;
    self.imageControl           = [[SOImageControl alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    self.imageControl .center   = self.view.center;
    [self.imageControl  setImage:[UIImage imageNamed:@"bg_1"]];
    [self.imageControl  addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.imageControl  addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageControl  addGestureRecognizer:recognizer];
    
    [self.view addSubview:self.imageControl ];
    [self scaleDownView:self.imageControl ];
}

- (void)touchDown:(UIControl *)sender {
    [self pauseAllAnimations:YES forLayer:sender.layer];
}

- (void)touchUpInside:(UIControl *)sender {
    POPSpringAnimation *animation   = [sender.layer pop_animationForKey:kScaleAnimationKey];
    CGPoint toValue                 = [animation.toValue CGPointValue];
    CGPoint currentValue            = [[animation valueForKey:@"currentValue"] CGPointValue];
    CGFloat min                     = MIN(toValue.x, currentValue.x);
    CGFloat max                     = MAX(toValue.x, currentValue.x);
    BOOL hasAnimations = sender.layer.pop_animationKeys.count;
    
    if (hasAnimations && min / max < 0.98) {
        [self pauseAllAnimations:NO forLayer:sender.layer];
        return;
    }
    
    [sender.layer pop_removeAllAnimations];
    if (toValue.x == 1 || sender.layer.affineTransform.a == 1) {
        [self scaleDownView:sender];
        return;
    }
    [self scaleUpView:sender];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    
    if ([SOImageAnimationViewController isInDecayState]) {
        [self decay_handlePan:recognizer];
    }
    else {
        [self scaleDownView:recognizer.view];
        CGPoint translation = [recognizer translationInView:self.view];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        
        if(recognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint velocity = [recognizer velocityInView:self.view];
            [self animateDismissWithVelocity:velocity];
        }
    }
}

#pragma mark Decay

- (void)decay_handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.view];
        POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.delegate = self;
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [recognizer.view.layer pop_addAnimation:positionAnimation forKey:@"layerrPositionAnimation"];
    }
}

#pragma mark Pan


- (void)animateDismissWithVelocity:(CGPoint)velocity {
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.velocity          = [NSValue valueWithCGPoint:velocity];
    positionAnimation.dynamicsTension   = 10.f;
    positionAnimation.dynamicsFriction  = 1.0f;
    positionAnimation.springBounciness  = 12.0f;
    [self.imageControl.layer pop_addAnimation:positionAnimation forKey:kPositionAnimationKey];
}

-(void)scaleUpView:(UIView *)view
{
    POPSpringAnimation *positionAnimation   = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.toValue               = [NSValue valueWithCGPoint:self.view.center];
    [view.layer pop_addAnimation:positionAnimation forKey:kPositionAnimationKey];
    
    POPSpringAnimation *scaleAnimation  = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue              = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleAnimation.springBounciness     = 10.f;
    [view.layer pop_addAnimation:scaleAnimation forKey:kScaleAnimationKey];
    
    POPSpringAnimation *corner          = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    corner.toValue              = @(10);
    [view.layer pop_addAnimation:corner forKey:@"cornerRadius"];
}

- (void)scaleDownView:(UIView *)view
{
    POPSpringAnimation *scaleAnimation  = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue              = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
    scaleAnimation.springBounciness     = 10.f;
    [view.layer pop_addAnimation:scaleAnimation forKey:kScaleAnimationKey];
    
    POPSpringAnimation *corner          = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    corner.toValue              = @(view.bounds.size.width / 2);
    [view.layer pop_addAnimation:corner forKey:@"cornerRadius"];
}

- (void)pauseAllAnimations:(BOOL)pause forLayer:(CALayer *)layer
{
    for (NSString *key in layer.pop_animationKeys) {
        POPAnimation *animation = [layer pop_animationForKey:key];
        [animation setPaused:pause];
    }
}

#pragma mark - POPAnimationDelegate

- (void)pop_animationDidApply:(POPDecayAnimation *)anim
{
    
    if ([SOImageAnimationViewController isInDecayState]) {
        BOOL isDragViewOutsideOfSuperView = !CGRectContainsRect(self.view.frame, self.imageControl.frame);
        if (isDragViewOutsideOfSuperView) {
            CGPoint currentVelocity = [anim.velocity CGPointValue];
            CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
            POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
            positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
            positionAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
            [self.imageControl.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
        }
    }
}

@end
