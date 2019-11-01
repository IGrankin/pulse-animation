//
// Created by admin on 31/10/2019.
// Copyright (c) 2019 igorgrankin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PGPulseAnimationView : NSObject

//Color
@property UIColor *pulseColor;
@property CGFloat mainView_size;
@property CGFloat mainView_expandingValue;

@property CGFloat backView_expandingSize;

//Timing
@property CGFloat mainView_expandingTime;
@property CGFloat mainView_silenceTimeAfterExpanding;
@property CGFloat mainView_backingToNormalTime;
@property CGFloat mainView_silenceTimeAfterBackingToNormal;

@property CGFloat backView_blowingTime;

//

@end