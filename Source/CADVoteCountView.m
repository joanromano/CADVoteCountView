//
//  CADVoteCountView.m
//  Gossip
//
//  Created by Joan Romano on 10/05/13.
//  Copyright (c) 2013 Oriol Blanc. All rights reserved.
//

#import "CADVoteCountView.h"

#import <QuartzCore/QuartzCore.h>

static NSUInteger const kMaxAngle = 360;
static NSUInteger const kActualMaxAngle = 343;

static CGFloat const kPaddingArea = 10.0f;
static CGFloat const kAnimationDuration = 0.5f;
static CGFloat const kDefaultColorLineWidthRatio = 6.0f;
static CGFloat const kDefaultBackgroundLineWidthRatio = 4.0f;

@interface CADVoteCountView ()

@property (nonatomic) NSUInteger radius;

@property (nonatomic, strong) CAAnimationGroup *colorPathGroupAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *colorPathStrokeEndAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *colorPathStrokeColorAnimation;

- (void)setupView;
- (void)updateColorPath;

- (UIColor *)colorFromCurrentAngle;
- (UIColor *)colorFromAngle:(NSUInteger)angle;

CGMutablePathRef createFullArcWithStartingAngleAndRadius(CGRect rect, long double angle, CGFloat radius, long double endAngle);

@end

@implementation CADVoteCountView

@synthesize backgroundLayerColor = _backgroundLayerColor;

#pragma mark - Class Methods

+ (NSUInteger)maxAngle
{
    return kMaxAngle;
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

#pragma mark - Overridden Methods

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _radius = (CGRectGetWidth(self.frame)/2) - kPaddingArea;
    
    // Background drawing
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    
    layer.fillColor = nil;
    layer.lineCap = kCALineCapButt;

    layer.strokeColor = self.backgroundLayerColor.CGColor;
    layer.lineWidth = CGRectGetWidth(self.bounds) / kDefaultBackgroundLineWidthRatio;
    layer.path = createFullArcWithStartingAngleAndRadius(self.frame, M_PI_2, self.radius, M_PI_2 + (M_PI * 2));
    
    // Colored count drawing
    CAShapeLayer *colorPathLayer = [CAShapeLayer layer];
    colorPathLayer.fillColor = nil;
    colorPathLayer.lineCap = kCALineCapRound;
    colorPathLayer.strokeColor = [self colorFromCurrentAngle].CGColor;
    colorPathLayer.strokeEnd = self.angle / (CGFloat)kMaxAngle;
    colorPathLayer.lineWidth = CGRectGetWidth(self.bounds) / kDefaultColorLineWidthRatio;
    colorPathLayer.path = createFullArcWithStartingAngleAndRadius(self.frame, M_PI_2, self.radius, M_PI_2 + (M_PI * 2));
    
    [layer addSublayer:colorPathLayer];
}

#pragma mark - Lazy

- (CAAnimationGroup *)colorPathGroupAnimation
{
    if (!_colorPathGroupAnimation)
    {
        _colorPathGroupAnimation = [CAAnimationGroup animation];
        _colorPathGroupAnimation.animations = @[self.colorPathStrokeColorAnimation, self.colorPathStrokeEndAnimation];
        _colorPathGroupAnimation.duration = kAnimationDuration;
    }
    
    return _colorPathGroupAnimation;
}

- (CAKeyframeAnimation *)colorPathStrokeColorAnimation
{
    if (!_colorPathStrokeColorAnimation)
    {
        _colorPathStrokeColorAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
        _colorPathStrokeColorAnimation.duration = kAnimationDuration;
    }
    
    return _colorPathStrokeColorAnimation;
}

- (CAKeyframeAnimation *)colorPathStrokeEndAnimation
{
    if (!_colorPathStrokeEndAnimation)
    {
        _colorPathStrokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        _colorPathStrokeEndAnimation.duration = kAnimationDuration;
    }
    
    return _colorPathStrokeEndAnimation;
}

#pragma mark - Private Methods

CGMutablePathRef createFullArcWithStartingAngleAndRadius(CGRect rect, long double angle, CGFloat radius, long double endAngle)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, CGRectGetWidth(rect)/2  , CGRectGetHeight(rect)/2, radius, angle, endAngle, 0);
    
    return path;
}

- (void)updateColorPath
{
    CAShapeLayer *colorSublayer = [self.layer.sublayers firstObject];
    
    colorSublayer.strokeColor = [self colorFromCurrentAngle].CGColor;
    colorSublayer.strokeEnd = self.angle / (CGFloat)kMaxAngle;
}

- (void)setupView
{
    _angle = 180;
}

- (UIColor *)colorFromCurrentAngle
{
    return [self colorFromAngle:self.angle];
}

- (UIColor *)colorFromAngle:(NSUInteger)angle
{
    CGFloat green = ((CGFloat)angle / ((CGFloat)360 -1));
    CGFloat red = (- 1 / ((CGFloat)360 - 1) * (CGFloat)angle) + 1;
    
    return [UIColor colorWithRed:red green:green blue:0 alpha:1];
}

#pragma mark - Public Methods

- (void)setAngle:(NSUInteger)angle
{
    [self setAngle:angle bouncing:NO];
}

- (void)setAngle:(NSUInteger)angle bouncing:(BOOL)bouncing
{
    if (angle>kMaxAngle)
        return;
    
    if (angle>kActualMaxAngle)
    {
        angle = kActualMaxAngle;
    }
    
    CGFloat alpha = angle > _angle ? angle*1.2f : angle*0.8f;
    
    self.colorPathStrokeEndAnimation.values = @[@(_angle / (CGFloat)kMaxAngle),
                                                @(alpha / (CGFloat)kMaxAngle),
                                                @(angle / (CGFloat)kMaxAngle)];
    
    self.colorPathStrokeColorAnimation.values = @[(id)[self colorFromAngle:_angle].CGColor,
                                                  (id)[self colorFromAngle:alpha].CGColor,
                                                  (id)[self colorFromAngle:angle].CGColor];
    
    _angle = angle;
    
    [self updateColorPath];
    
    if (bouncing)
    {
        [[self.layer.sublayers firstObject] addAnimation:self.colorPathGroupAnimation forKey:@"strokePathAnimation"];
    }
}

- (UIColor *)backgroundLayerColor
{
    return _backgroundLayerColor ? : [UIColor darkGrayColor];
}

- (void)setBackgroundLayerColor:(UIColor *)backgroundLayerColor
{
    _backgroundLayerColor = backgroundLayerColor;
    
    ((CAShapeLayer *)self.layer).strokeColor = backgroundLayerColor.CGColor;
}

@end
