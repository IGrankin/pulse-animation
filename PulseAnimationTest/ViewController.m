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
@property (strong, nonatomic) IBOutlet UIButton *exampleButton;

@end

@implementation ViewController {
    UIView *_roundedView;
    NSLayoutConstraint *_mainViewWidthConstraint;
    NSLayoutConstraint *_mainViewHeightConstraint;
    NSLayoutConstraint *_mainViewCenterXConstraint;
    NSLayoutConstraint *_mainViewCenterYConstraint;
    CGFloat oldButtonSize;
    UIView *_backRoundedView;
    NSLayoutConstraint *_backViewWidthConstraint;
    NSLayoutConstraint *_backViewHeightConstraint;
    NSLayoutConstraint *_backViewCenterXConstraint;
    NSLayoutConstraint *_backViewCenterYConstraint;
    CGPoint animationCenterPoint;
    UIView *_trackedView;

    PGPulseAnimationView *pulseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];



    
    [self setupAndLaunchAnimWithView:_exampleButton];
}

- (void)setupPulseView {
    pulseView = [[PGPulseAnimationView alloc] init];

    pulseView.pulseColor = [UIColor colorWithRed:5/255.0 green:89/255.0 blue:175/255.0 alpha:1];
    pulseView.mainView_size = 50;
    pulseView.mainView_expandingValue = 10;
    pulseView.backView_expandingSize = 50 * 4;
    //time
    pulseView.mainView_expandingTime = 0.25;
    pulseView.mainView_silenceTimeAfterExpanding = 0.1;
    pulseView.mainView_backingToNormalTime = 0.15;
    pulseView.mainView_silenceTimeAfterBackingToNormal = 0.35;
    pulseView.backView_blowingTime = 0.35;
}

- (void)setupAndLaunchAnimWithView:(UIView *)view {
    _trackedView = view;
    //main view
    oldButtonSize = 50;
    _roundedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _roundedView.center = _trackedView.center;
    _roundedView.backgroundColor = [UIColor colorWithRed:5/255.0 green:89/255.0 blue:175/255.0 alpha:1];
    _roundedView.layer.cornerRadius = oldButtonSize / 2;
    _roundedView.layer.masksToBounds = YES;
    _roundedView.layer.opacity = 0.0;
    _roundedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:_roundedView atIndex:0];

    [NSLayoutConstraint activateConstraints:@[
            _mainViewWidthConstraint = [_roundedView.widthAnchor constraintEqualToConstant:0],
            _mainViewHeightConstraint = [_roundedView.heightAnchor constraintEqualToConstant:0],
            _mainViewCenterXConstraint = [_roundedView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
            _mainViewCenterYConstraint = [_roundedView.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];

    //back view
    _backRoundedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _backRoundedView.center = _trackedView.center;
    _backRoundedView.backgroundColor = [UIColor colorWithRed:5/255.0 green:89/255.0 blue:175/255.0 alpha:1];
    _backRoundedView.layer.cornerRadius = oldButtonSize / 2;
    _backRoundedView.layer.masksToBounds = YES;
    _backRoundedView.layer.opacity = 0.9;

    _backRoundedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:_backRoundedView atIndex:1];

    [NSLayoutConstraint activateConstraints:@[
            _backViewWidthConstraint = [_backRoundedView.widthAnchor constraintEqualToConstant:0],
            _backViewHeightConstraint = [_backRoundedView.heightAnchor constraintEqualToConstant:0],
            _backViewCenterXConstraint = [_backRoundedView.centerXAnchor constraintEqualToAnchor:_roundedView.centerXAnchor],
            _backViewCenterYConstraint = [_backRoundedView.centerYAnchor constraintEqualToAnchor:_roundedView.centerYAnchor]
    ]];

    [self anim_appearance];
}

- (void)anim_appearance{
    CGFloat timing = 1.0;
    [NSLayoutConstraint deactivateConstraints:@[
            _mainViewWidthConstraint,
            _mainViewHeightConstraint,
            _mainViewCenterXConstraint,
            _mainViewCenterYConstraint
    ]];

    //Begin animations
    [CATransaction begin];
    [CATransaction setAnimationDuration:timing];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    //view animations
    [UIView animateWithDuration:timing animations:^{
                _roundedView.frame = CGRectMake(0, 0, oldButtonSize, oldButtonSize);
                _roundedView.center = _trackedView.center;
                _mainViewWidthConstraint.constant = 50;
                _mainViewHeightConstraint.constant = 50;
            }
                     completion:^(BOOL finished) {
                         [self anim_pulse_1part];
                     }];

    //layer animations
    CABasicAnimation *cornerAnim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerAnim.fromValue = @(0);
    cornerAnim.toValue = @(oldButtonSize/2);

    _roundedView.layer.cornerRadius = oldButtonSize/2;
    [_roundedView.layer addAnimation:cornerAnim forKey:@"cornerRadius"];

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.0);
    opacityAnim.toValue = @(0.65);
    _roundedView.layer.opacity = 0.65;
    [_roundedView.layer addAnimation:opacityAnim forKey:@"opacity"];

    [CATransaction commit];

    [NSLayoutConstraint activateConstraints:@[
            _mainViewWidthConstraint,
            _mainViewHeightConstraint,
            _mainViewCenterXConstraint,
            _mainViewCenterYConstraint
    ]];
}

-(void)anim_pulse_1part {
    CGFloat timing = 1;
    CGFloat expanding = 10;
    [NSLayoutConstraint deactivateConstraints:@[
            _mainViewWidthConstraint,
            _mainViewHeightConstraint,
            _mainViewCenterXConstraint,
            _mainViewCenterYConstraint
    ]];
    //Begin animations
    [CATransaction begin];
    [CATransaction setAnimationDuration:timing];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    //view animations
    [UIView animateWithDuration:timing animations:^{
                _mainViewWidthConstraint.constant+=expanding;
                _mainViewHeightConstraint.constant+=expanding;
                _roundedView.frame = CGRectMake(0, 0, oldButtonSize+expanding, oldButtonSize+expanding);
                _roundedView.center = _trackedView.center;
            }
                     completion:^(BOOL finished) {
                         [self anim_backRoundedViewAnim];
                         [self anim_pulse_2part];
                     }];

    //layer animations
    CABasicAnimation *cornerAnim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerAnim.fromValue = @(oldButtonSize / 2);
    cornerAnim.toValue = @((oldButtonSize + expanding) / 2);

    _roundedView.layer.cornerRadius = (oldButtonSize + expanding) / 2;
    [_roundedView.layer addAnimation:cornerAnim forKey:@"cornerRadius"];

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.65);
    opacityAnim.toValue = @(0.9);
    _roundedView.layer.opacity = 0.9;
    [_roundedView.layer addAnimation:opacityAnim forKey:@"opacity"];

    [CATransaction commit];

    [NSLayoutConstraint activateConstraints:@[
            _mainViewWidthConstraint,
            _mainViewHeightConstraint,
            _mainViewCenterXConstraint,
            _mainViewCenterYConstraint
    ]];
}

-(void)anim_pulse_2part {
    CGFloat timing = 1;
    CGFloat expanding = 10;
    [NSLayoutConstraint deactivateConstraints:@[
            _mainViewWidthConstraint,
            _mainViewHeightConstraint,
            _mainViewCenterXConstraint,
            _mainViewCenterYConstraint
    ]];
    //Begin animations
    [CATransaction begin];
    [CATransaction setAnimationDuration:timing];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    //view animations
    [UIView animateWithDuration:timing animations:^{
                _mainViewWidthConstraint.constant-=expanding;
                _mainViewHeightConstraint.constant-=expanding;
                _roundedView.frame = CGRectMake(0, 0, oldButtonSize, oldButtonSize);
                _roundedView.center = _trackedView.center;
            }
                     completion:^(BOOL finished) {
//                         [self anim_pulse_1part];
                     }];

    //layer animations
    CABasicAnimation *cornerAnim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerAnim.fromValue = @((oldButtonSize + expanding) / 2);
    cornerAnim.toValue = @(oldButtonSize / 2);

    _roundedView.layer.cornerRadius = oldButtonSize / 2;
    [_roundedView.layer addAnimation:cornerAnim forKey:@"cornerRadius"];

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.9);
    opacityAnim.toValue = @(0.65);
    _roundedView.layer.opacity = 0.65;
    [_roundedView.layer addAnimation:opacityAnim forKey:@"opacity"];

    [CATransaction commit];

    [NSLayoutConstraint activateConstraints:@[
            _mainViewWidthConstraint,
            _mainViewHeightConstraint,
            _mainViewCenterXConstraint,
            _mainViewCenterYConstraint
    ]];
}

-(void)anim_backRoundedViewAnim{
    [NSLayoutConstraint deactivateConstraints:@[
            _backViewWidthConstraint,
            _backViewHeightConstraint,
            _backViewCenterXConstraint,
            _backViewCenterYConstraint
    ]];
    //sync 2 views
    _backRoundedView.frame = _roundedView.frame;
    _backRoundedView.center = _roundedView.center;
    _backRoundedView.layer.cornerRadius = _roundedView.layer.cornerRadius;
    //animation
    CGFloat timing = 2.0;
    //Begin animations
    [CATransaction begin];
    [CATransaction setAnimationDuration:timing];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    CGFloat newSize = _mainViewWidthConstraint.constant * 4;
    //view animations
    [UIView animateWithDuration:timing animations:^{
                _backViewWidthConstraint.constant= newSize;
                _backViewHeightConstraint.constant= newSize;
                _backRoundedView.frame = CGRectMake(0, 0, newSize, newSize);
                _backRoundedView.center = _trackedView.center;
            }
                     completion:^(BOOL finished) {
                         [self anim_pulse_1part];
                     }];

    //layer animations
    CABasicAnimation *cornerAnim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerAnim.fromValue = @(_backRoundedView.layer.cornerRadius);
    cornerAnim.toValue = @(newSize/2);

    _backRoundedView.layer.cornerRadius = newSize/2;
    [_backRoundedView.layer addAnimation:cornerAnim forKey:@"cornerRadius"];

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = @(0.9);
    opacityAnim.toValue = @(0.0);
    _backRoundedView.layer.opacity = 0.0;
    [_backRoundedView.layer addAnimation:opacityAnim forKey:@"opacity"];

    [CATransaction commit];
    [NSLayoutConstraint activateConstraints:@[
            _backViewWidthConstraint,
            _backViewHeightConstraint,
            _backViewCenterXConstraint,
            _backViewCenterYConstraint
    ]];
}

@end
