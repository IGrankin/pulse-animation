//
//  ViewController.m
//  PulseAnimationTest
//
//  Created by admin on 30/10/2019.
//  Copyright © 2019 igorgrankin. All rights reserved.
//

#import "ViewController.h"
#import "PGPulseAnimationView.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *exampleButton;

@end

@implementation ViewController {
    UIView *_roundedView;
    CAShapeLayer *_roundedViewShapeLayer;
    CGFloat oldButtonSize;
    CAShapeLayer *_backRoundedViewShapeLayer;
    UIView *_trackedView;
    CAAnimationGroup *_smallCircleAnimationGroup;
    NSMutableArray *smallAnimations;
    CAAnimationGroup *_bigCircleAnimationGroup;
    NSMutableArray *bigAnimations;
    PGPulseAnimationView *_pulseView;
    BOOL isPlaying;
    IBOutlet UILabel *textLbl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_exampleButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animationManagment)]];
}

- (void)animationManagment {
    if (isPlaying) {
        [self stopPlayingAnimation];
        textLbl.text = @"Press for start pulse";
    } else {
        [self setupPulseView];
        textLbl.text = @"Press for stop pulse";
    }
    isPlaying = !isPlaying;
}

- (void)stopPlayingAnimation {
    [_pulseView endAnimation];
}

- (void)setupPulseView {
    _pulseView = [PGPulseAnimationView new];
    _pulseView.trackedView = _exampleButton;
    _pulseView.pulseColor = [UIColor colorWithRed:5/255.0 green:89/255.0 blue:175/255.0 alpha:1];
    _pulseView.smallLayer_size = 50;
    _pulseView.smallLayer_expandingValue = 10;
    _pulseView.bigLayer_expandingSize = 50 * 4;
    //time
    _pulseView.smallLayer_expandingTime = 0.35;
    _pulseView.smallLayer_silenceTimeAfterExpanding = 0.2;
    _pulseView.smallLayer_backingToNormalTime = 0.35;
    _pulseView.smallLayer_silenceTimeAfterBackingToNormal = 0.55;
    _pulseView.bigLayer_blowingTime = 0.7;

    //Constraints
    _pulseView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:_pulseView belowSubview:_exampleButton];
    [NSLayoutConstraint activateConstraints:@[
            [_pulseView.widthAnchor constraintEqualToConstant:0],
            [_pulseView.heightAnchor constraintEqualToConstant:0],
            [_pulseView.centerXAnchor constraintEqualToAnchor:_exampleButton.leadingAnchor],
            [_pulseView.centerYAnchor constraintEqualToAnchor:_exampleButton.centerYAnchor]
    ]];
    [_pulseView startAnimation];
}

- (void)setupAndLaunchAnimWithView:(UIView *)view {
    _trackedView = view;
    //main view
    oldButtonSize = 50;
    _roundedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:_roundedView.frame cornerRadius:0];
    _roundedViewShapeLayer = [CAShapeLayer new];
    _roundedViewShapeLayer.fillColor = [UIColor colorWithRed:5/255.0 green:89/255.0 blue:175/255.0 alpha:1].CGColor;
    _roundedViewShapeLayer.path = [roundPath CGPath];
    [_roundedView.layer addSublayer:_roundedViewShapeLayer];

    _roundedView.center = _trackedView.center;
    _roundedViewShapeLayer.opacity = 0.0;
    _roundedView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:_roundedView];
    _roundedViewShapeLayer.zPosition = view.layer.zPosition - 1;

    [NSLayoutConstraint activateConstraints:@[
            [_roundedView.widthAnchor constraintEqualToConstant:0],
            [_roundedView.heightAnchor constraintEqualToConstant:0],
            [_roundedView.centerXAnchor constraintEqualToAnchor:view.leadingAnchor],
            [_roundedView.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];

    UIBezierPath *backRoundPath = [UIBezierPath bezierPathWithRoundedRect:_roundedView.frame cornerRadius:0];
    _backRoundedViewShapeLayer = [CAShapeLayer new];
    _backRoundedViewShapeLayer.fillColor = [UIColor colorWithRed:5/255.0 green:89/255.0 blue:175/255.0 alpha:1].CGColor;
    _backRoundedViewShapeLayer.path = [backRoundPath CGPath];
    [_roundedView.layer addSublayer:_backRoundedViewShapeLayer];
    _backRoundedViewShapeLayer.zPosition = view.layer.zPosition-2;
    _backRoundedViewShapeLayer.opacity = 0.9;
    
    _smallCircleAnimationGroup = [CAAnimationGroup new];
    _smallCircleAnimationGroup.duration = 2;
    _smallCircleAnimationGroup.animations = [self anim_appearance];
    [_roundedViewShapeLayer addAnimation:_smallCircleAnimationGroup forKey:nil];

    _bigCircleAnimationGroup = [CAAnimationGroup new];
    _bigCircleAnimationGroup.duration = 1.25;
}

- (NSArray<CABasicAnimation *> *)anim_appearance{
    CGFloat timing = 2.0;
    
    //Path animations
    CGFloat size = oldButtonSize;
    CGRect newRect = CGRectMake(-size/2, -size/2, size, size);
    UIBezierPath *expandingPath = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:size/2];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = timing;
    pathAnimation.beginTime = 0;
    pathAnimation.fromValue = (id)_roundedViewShapeLayer.path;
    pathAnimation.toValue = (id)expandingPath.CGPath;
    _roundedViewShapeLayer.path = expandingPath.CGPath;

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.duration = timing;
    opacityAnim.beginTime = 0;
    opacityAnim.fromValue = @(0.0);
    opacityAnim.toValue = @(0.65);
    _roundedViewShapeLayer.opacity = 0.65;

    return @[pathAnimation, opacityAnim];
}

-(NSArray<CABasicAnimation *> *)anim_pulse_1part {
    CGFloat timing = 1.0;
    CGFloat expanding = 10;
    //Begin animations
    [CATransaction begin];
    [CATransaction setAnimationDuration:timing];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [CATransaction setCompletionBlock:^{
        [self anim_backRoundedViewAnim];
        [self anim_pulse_2part];
    }];
    
    CGFloat size = oldButtonSize+expanding;
    CGRect newRect = CGRectMake(-size/2, -size/2, size, size);
    UIBezierPath *expandingPath = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:size/2];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = timing;
    pathAnimation.fromValue = (id)_roundedViewShapeLayer.path;
    pathAnimation.toValue = (id)expandingPath.CGPath;

    _roundedViewShapeLayer.path = expandingPath.CGPath;
    [_roundedViewShapeLayer addAnimation:pathAnimation forKey:@"path"];

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.65);
    opacityAnim.toValue = @(0.9);
    _roundedViewShapeLayer.opacity = 0.9;
    [_roundedViewShapeLayer addAnimation:opacityAnim forKey:@"opacity"];

    
    [CATransaction commit];
    return nil;
}

-(NSArray<CABasicAnimation *> *)anim_pulse_2part {
    CGFloat timing = 1.0;
    CGFloat expanding = 10;
    //Begin animations
    [CATransaction begin];
    [CATransaction setAnimationDuration:timing];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CGFloat size = oldButtonSize;
    CGRect newRect = CGRectMake(-size/2, -size/2, size, size);
    UIBezierPath *expandingPath = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:size/2];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = timing;
    pathAnimation.fromValue = (id)_roundedViewShapeLayer.path;
    pathAnimation.toValue = (id)expandingPath.CGPath;
    _roundedViewShapeLayer.path = expandingPath.CGPath;
    [_roundedViewShapeLayer addAnimation:pathAnimation forKey:@"path"];

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.9);
    opacityAnim.toValue = @(0.65);
    _roundedView.layer.opacity = 0.65;
    [_roundedView.layer addAnimation:opacityAnim forKey:@"opacity"];

    [CATransaction commit];
    return nil;
}

-(NSArray<CABasicAnimation *> *)anim_backRoundedViewAnim{
    //sync
    //animation
    CGFloat timing = 2.0;
    //Begin animations
    [CATransaction begin];
    [CATransaction setAnimationDuration:timing];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setCompletionBlock:^{
        [self anim_pulse_1part];

    }];

    CGFloat newSize = oldButtonSize * 4;
    CGRect newRect = CGRectMake(-newSize/2, -newSize/2, newSize, newSize);
    UIBezierPath *expandingPath = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:newSize/2];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = timing;
    pathAnimation.fromValue = (id)_roundedViewShapeLayer.path;
    pathAnimation.toValue = (id)expandingPath.CGPath;
    _backRoundedViewShapeLayer.path = expandingPath.CGPath;
    [_backRoundedViewShapeLayer addAnimation:pathAnimation forKey:@"path"];

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.9);
    opacityAnim.toValue = @(0.0);
    _backRoundedViewShapeLayer.opacity = 0.0;
    [_backRoundedViewShapeLayer addAnimation:opacityAnim forKey:@"opacity"];

    [CATransaction commit];
    return nil;
}

@end
