//
// Created by admin on 31/10/2019.
// Copyright (c) 2019 igorgrankin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PGPulseAnimationView : UIView

@property UIView *trackedView;

//Color
@property UIColor *pulseColor;
@property CGFloat smallLayer_size;
@property CGFloat smallLayer_expandingValue;

@property CGFloat bigLayer_expandingSize;

//Timing
@property CGFloat smallLayer_expandingTime;
@property CGFloat smallLayer_silenceTimeAfterExpanding;
@property CGFloat smallLayer_backingToNormalTime;
@property CGFloat smallLayer_silenceTimeAfterBackingToNormal;

@property CGFloat bigLayer_blowingTime;

-(void)startAnimation;
-(void)endAnimation;

//

@end