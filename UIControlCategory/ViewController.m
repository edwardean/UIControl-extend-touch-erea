//
//  ViewController.m
//  UIControlCategory
//
//  Created by HerryLee on 15/8/14.
//  Copyright (c) 2015年 Herry. All rights reserved.
//

#import "ViewController.h"
static const CGFloat verticalLimit = -200;
@interface ViewController ()
@property (nonatomic, strong) UIView *animatedView;
@property (nonatomic, strong) NSLayoutConstraint *bottomLayout;
@end

@implementation ViewController {
    CGFloat totalTranslation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    totalTranslation = -200;
    
    _animatedView = [UIView new];
    _animatedView.backgroundColor = [UIColor greenColor];
    _animatedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_animatedView];
    
    _bottomLayout = [NSLayoutConstraint constraintWithItem:_animatedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-100];
    [self.view addConstraint:_bottomLayout];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_animatedView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_animatedView]-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_animatedView(==600)]" options:NSLayoutFormatAlignmentMask metrics:nil views:views]];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(animatedViewDragged:)];
    [_animatedView addGestureRecognizer:panGesture];
}

- (void)animatedViewDragged:(UIPanGestureRecognizer *)gesture {
    CGFloat yTranslation = [gesture translationInView:self.view].y;
    if (_bottomLayout.constant < verticalLimit) {
        totalTranslation += yTranslation;
        _bottomLayout.constant = [self logConstraintValueForYPosition:totalTranslation];
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [self animateToLimit];
        }
    } else {
        _bottomLayout.constant += yTranslation;
    }
    [gesture setTranslation:CGPointZero inView:self.view];
}

- (void)animateToLimit {
    _bottomLayout.constant = verticalLimit;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.view layoutIfNeeded];
        totalTranslation = -200;
    } completion:nil];
}

- (CGFloat)logConstraintValueForYPosition:(CGFloat)yPosition {
    
    return verticalLimit * (1 + log10(yPosition/verticalLimit));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
