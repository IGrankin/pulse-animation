//
// Created by admin on 31/10/2019.
// Copyright (c) 2019 igorgrankin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPulseAnimationView.h"


@implementation PGPulseAnimationView {
    CAShapeLayer *_roundedViewShapeLayer;
    CAShapeLayer *_backRoundedViewShapeLayer;
    CAAnimationGroup *_smallCircleAnimationGroup;
    NSMutableArray *_smallAnimations;
    CAAnimationGroup *_bigCircleAnimationGroup;
    NSMutableArray *_bigAnimations;
}

- (void)setupLayers {
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-_smallLayer_size/2, -_smallLayer_size/2, _smallLayer_size, _smallLayer_size) cornerRadius:_smallLayer_size/2];
    _roundedViewShapeLayer = [CAShapeLayer new];
    _roundedViewShapeLayer.fillColor = _pulseColor.CGColor;
    _roundedViewShapeLayer.path = [roundPath CGPath];
    [self.layer addSublayer:_roundedViewShapeLayer];
    _roundedViewShapeLayer.opacity = 0.0;
    _roundedViewShapeLayer.zPosition = _trackedView.layer.zPosition - 1;

    _backRoundedViewShapeLayer = [CAShapeLayer new];
    _backRoundedViewShapeLayer.fillColor = _pulseColor.CGColor;
    _backRoundedViewShapeLayer.path = [roundPath CGPath];
    [self.layer addSublayer:_backRoundedViewShapeLayer];
    _backRoundedViewShapeLayer.zPosition = _trackedView.layer.zPosition-2;
    _backRoundedViewShapeLayer.opacity = 0.9;
}

-(void)setupAnimations {
    CGFloat appearance = 1;
    CGFloat timing = _smallLayer_expandingTime +
            _smallLayer_silenceTimeAfterExpanding +
            _smallLayer_backingToNormalTime +
            _smallLayer_silenceTimeAfterBackingToNormal;

//    CAAnimationGroup *appearanceAnimGroup = [CAAnimationGroup new];
//    appearanceAnimGroup.duration = appearance;
//    appearanceAnimGroup.animations = [self getExpandAnimationsWithDuration:appearance
//                                                                 beginTime:0
//                                                                   newSize:_smallLayer_size
//                                                                oldOpacity:0
//                                                                newOpacity:0.65
//                                                                  forLayer:_roundedViewShapeLayer];
//    [_roundedViewShapeLayer addAnimation:appearanceAnimGroup forKey:nil];

    _smallCircleAnimationGroup = [CAAnimationGroup new];
    _smallCircleAnimationGroup.duration = timing;
    _smallCircleAnimationGroup.repeatCount = 999;
    _smallAnimations = [NSMutableArray new];
    [_smallAnimations addObjectsFromArray:
            [self getExpandAnimationsWithDuration:_smallLayer_expandingTime
                                        beginTime:0
                                          newSize:_smallLayer_size + _smallLayer_expandingValue
                                       oldOpacity:0.65
                                       newOpacity:0.9
                                         forLayer:_roundedViewShapeLayer]
    ];
    [_smallAnimations addObjectsFromArray:
            [self getExpandAnimationsWithDuration:_smallLayer_backingToNormalTime
                                        beginTime:_smallLayer_expandingTime + _smallLayer_silenceTimeAfterExpanding
                                          newSize:_smallLayer_size
                                       oldOpacity:0.9
                                       newOpacity:0.65
                                         forLayer:_roundedViewShapeLayer]
    ];
    _smallCircleAnimationGroup.animations = _smallAnimations;
    [_roundedViewShapeLayer addAnimation:_smallCircleAnimationGroup forKey:nil];

    _bigCircleAnimationGroup = [CAAnimationGroup new];
    _bigCircleAnimationGroup.duration = timing;
    _bigCircleAnimationGroup.repeatCount = 999;
    _bigAnimations = [NSMutableArray new];
    [_bigAnimations addObjectsFromArray:
            [self getExpandAnimationsWithDuration:_bigLayer_blowingTime
                                        beginTime:_smallLayer_expandingTime
                                          newSize:_bigLayer_expandingSize
                                       oldOpacity:0.9
                                       newOpacity:0.0
                                         forLayer:_backRoundedViewShapeLayer]];
    _bigCircleAnimationGroup.animations = _bigAnimations;
    [_backRoundedViewShapeLayer addAnimation:_bigCircleAnimationGroup forKey:nil];

}

- (void)startAnimation {
    [self setupLayers];
    [self setupAnimations];
}

- (void)endAnimation {
    [_roundedViewShapeLayer removeAllAnimations];
    [_backRoundedViewShapeLayer removeAllAnimations];
    [_roundedViewShapeLayer removeFromSuperlayer];
    [_backRoundedViewShapeLayer removeFromSuperlayer];
    _roundedViewShapeLayer = nil;
    _backRoundedViewShapeLayer = nil;
    
    //TODO: add end animation
}


- (NSArray<CABasicAnimation *> *)getExpandAnimationsWithDuration:(CGFloat)duration
                                                       beginTime:(CGFloat)beginTime
                                                         newSize:(CGFloat)newSize
                                                      oldOpacity:(CGFloat)oldOpacity
                                                      newOpacity:(CGFloat)newOpacity
                                                        forLayer:(CAShapeLayer *)shapeLayer {


    CGFloat size = newSize;
    CGRect newRect = CGRectMake(-size / 2, -size / 2, size, size);
    UIBezierPath *expandingPath = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:size / 2];

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = duration;
    pathAnimation.beginTime = beginTime;
    pathAnimation.fromValue = (id) shapeLayer.path;
    pathAnimation.toValue = (id) expandingPath.CGPath;
    shapeLayer.path = expandingPath.CGPath;


    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fillMode = kCAFillModeForwards;
    opacityAnim.removedOnCompletion = NO;
    opacityAnim.duration = duration;
    opacityAnim.beginTime = beginTime;
    opacityAnim.fromValue = @(oldOpacity);
    opacityAnim.toValue = @(newOpacity);
    shapeLayer.opacity = (float) newOpacity;
    return @[pathAnimation, opacityAnim];
}



@end
