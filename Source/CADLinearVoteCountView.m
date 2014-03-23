//
//  CADLinearVoteCountView.m
//  CADVoteCountView
//
//  Created by Joan Romano on 23/03/14.
//  Copyright (c) 2014 Joan Romano. All rights reserved.
//

#import "CADLinearVoteCountView.h"

#import "CADVoteCountView+Private.h"

static NSUInteger const kMaxAngle = 100;
static NSUInteger const kDefaultAngle = 50;

@implementation CADLinearVoteCountView

@synthesize angle = _angle;

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Background drawing
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.fillColor = nil;
    layer.lineCap = kCALineCapRound;
    layer.strokeColor =  [UIColor darkGrayColor].CGColor;
    layer.lineWidth = CGRectGetHeight(self.bounds)*0.8;
    layer.path = createLineForRect(self.frame);
    
    // Second background drawing
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.fillColor = nil;
    backgroundLayer.lineCap = kCALineCapRound;
    backgroundLayer.strokeColor =  [UIColor whiteColor].CGColor;
    backgroundLayer.lineWidth = CGRectGetHeight(self.bounds)*0.6;
    backgroundLayer.path = createLineForRect(self.frame);
    
    // Colored count drawing
    CAShapeLayer *colorPathLayer = [CAShapeLayer layer];
    colorPathLayer.fillColor = nil;
    colorPathLayer.lineCap = kCALineCapRound;
    colorPathLayer.strokeColor = [self colorFromCurrentAngle].CGColor;
    colorPathLayer.strokeEnd = self.angle / (CGFloat)[self maxAngle];
    colorPathLayer.lineWidth = CGRectGetHeight(self.bounds)*0.4;
    colorPathLayer.path = createLineForRect(self.frame);

    [layer addSublayer:backgroundLayer];
    [layer addSublayer:colorPathLayer];
}

- (void)setAngle:(NSUInteger)angle animationType:(CADVoteCountViewAnimationType)animationType
{
    if (angle>[self maxAngle] || angle == _angle)
        return;
    
    CGFloat alpha = angle > _angle ? angle*1.2f : angle*0.8f,
            maxAngle = (CGFloat)[self maxAngle];
    
    self.colorPathStrokeEndAnimation.values = @[@(_angle / maxAngle),
                                                @(alpha / maxAngle),
                                                @(angle / maxAngle)];
    
    self.colorPathStrokeColorAnimation.values = @[(id)[self colorFromAngle:_angle].CGColor,
                                                  (id)[self colorFromAngle:alpha].CGColor,
                                                  (id)[self colorFromAngle:angle].CGColor];
    
    _angle = angle;
    
    if (animationType == CADVoteCountViewAnimationTypeNone)
    {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        [self updateColorPath];
        [CATransaction commit];
    }
    else
    {
        [self updateColorPath];
    }
    
    if (animationType == CADVoteCountViewAnimationTypeBouncing)
    {
        [[self.layer.sublayers lastObject] addAnimation:self.colorPathGroupAnimation forKey:@"strokePathAnimation"];
    }
}

- (NSUInteger)defaultAngle
{
    return kDefaultAngle;
}

- (NSUInteger)maxAngle
{
    return kMaxAngle;
}

CGMutablePathRef createLineForRect(CGRect rect)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, CGRectGetHeight(rect)/2);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetHeight(rect)/2);
    
    return path;
}

@end
