//
//  CADCircularVoteCountView.m
//  CADVoteCountView
//
//  Created by Joan Romano on 23/03/14.
//  Copyright (c) 2014 Joan Romano. All rights reserved.
//

static NSUInteger const kMaxAngle = 360;
static NSUInteger const kDefaultAngle = 180;
static NSUInteger const kActualMaxAngle = 343;

static CGFloat const kPaddingArea = 10.0f;
static CGFloat const kDefaultColorLineWidthRatio = 6.0f;
static CGFloat const kDefaultBackgroundLineWidthRatio = 4.0f;

#import "CADCircularVoteCountView.h"

#import "CADVoteCountView+Private.h"

@interface CADCircularVoteCountView ()

@property (nonatomic) NSUInteger radius;

@end

@implementation CADCircularVoteCountView

@synthesize angle = _angle;

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _radius = (CGRectGetWidth(self.frame)/2) - kPaddingArea;
    
    // Background drawing
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    
    layer.fillColor = nil;
    layer.lineCap = kCALineCapButt;
    
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    layer.lineWidth = CGRectGetWidth(self.bounds) / kDefaultBackgroundLineWidthRatio;
    layer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2) radius:self.radius startAngle:M_PI_2 endAngle:M_PI_2 + (M_PI * 2) clockwise:YES].CGPath;
    
    // Colored count drawing
    CAShapeLayer *colorPathLayer = [CAShapeLayer layer];
    colorPathLayer.fillColor = nil;
    colorPathLayer.lineCap = kCALineCapRound;
    colorPathLayer.strokeColor = [self colorFromCurrentAngle].CGColor;
    colorPathLayer.strokeEnd = self.angle / (CGFloat)[self maxAngle];
    colorPathLayer.lineWidth = CGRectGetWidth(self.bounds) / kDefaultColorLineWidthRatio;
    colorPathLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2) radius:self.radius startAngle:M_PI_2 endAngle:M_PI_2 + (M_PI * 2) clockwise:YES].CGPath;
    
    [layer addSublayer:colorPathLayer];
}

- (void)setAngle:(NSUInteger)angle animationType:(CADVoteCountViewAnimationType)animationType
{
    if (angle>kMaxAngle || angle == _angle)
        return;
    
    if (angle>kActualMaxAngle)
    {
        angle = kActualMaxAngle;
    }
    
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
        [[self.layer.sublayers firstObject] addAnimation:self.colorPathGroupAnimation forKey:@"strokePathAnimation"];
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

@end
