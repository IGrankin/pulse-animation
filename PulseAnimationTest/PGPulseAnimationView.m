//
// Created by admin on 31/10/2019.
// Copyright (c) 2019 igorgrankin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPulseAnimationView.h"


@implementation PGPulseAnimationView {
    UIView *_roundedView;
    UIView *_backRoundedView;
}

- (void)setupWithView:(UIView *)view {

}

- (void)setupViews {
    _roundedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _roundedView.backgroundColor = [UIColor colorWithRed:5/255.0 green:89/255.0 blue:175/255.0 alpha:1];
    _roundedView.layer.cornerRadius = _mainView_size / 2;
    _roundedView.layer.masksToBounds = YES;
    _roundedView.layer.opacity = 0.0;

    _backRoundedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _backRoundedView.backgroundColor = [UIColor colorWithRed:5/255.0 green:89/255.0 blue:175/255.0 alpha:1];
    _backRoundedView.layer.masksToBounds = YES;
    _backRoundedView.layer.opacity = 0.9;
}

- (void)launchAnimation {

}

@end