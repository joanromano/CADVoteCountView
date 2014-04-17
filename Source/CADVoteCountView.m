//
//  CADVoteCountView.m
//  Gossip
//
//  Created by Joan Romano on 10/05/13.
//  Copyright (c) 2013 Oriol Blanc. All rights reserved.
//

#import "CADVoteCountView.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat const kAnimationDuration = 0.5f;

@interface CADVoteCountView ()

@property (nonatomic, strong) CAAnimationGroup *colorPathGroupAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *colorPathStrokeEndAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *colorPathStrokeColorAnimation;

- (void)setupView;
- (void)updateColorPath;

- (UIColor *)colorFromCurrentAngle;
- (UIColor *)colorFromAngle:(NSUInteger)angle;

@end

@interface CADCircularVoteCountView : CADVoteCountView

@property (nonatomic) NSUInteger radius;

@end

@interface CADLinearVoteCountView : CADVoteCountView

@end

/****************   Abstract CADVoteCountView       ****************/

@implementation CADVoteCountView

#pragma mark - Class Methods

+ (CADVoteCountView *)voteCountViewWithType:(CADVoteCountViewType)type
{
    switch (type)
    {
        case CADVoteCountViewTypeCircular:
            return [[CADCircularVoteCountView alloc] init];
        case CADVoteCountViewTypeLinear:
            return [[CADLinearVoteCountView alloc] init];
    }
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

#pragma mark - Overridden Methods

+ (id)alloc
{
    if ([self class] == [CADVoteCountView class])
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"You should use voteCountViewWithType: creation method to instantiate a CADVoteCountView instead"
                                     userInfo:nil];
    }
    else
    {
        return [super alloc];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupView];
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    
    ((CAShapeLayer *)self.layer).strokeColor = backgroundColor.CGColor;
}

#pragma mark - Public Methods

- (NSUInteger)angle
{
    return angle;
}

- (void)setAngle:(NSUInteger)newAngle
{
    [self setAngle:newAngle animationType:CADVoteCountViewAnimationTypeNone];
}

- (void)setAngle:(NSUInteger)angle animationType:(CADVoteCountViewAnimationType)animationType
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSUInteger)defaultAngle
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSUInteger)maxAngle
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - Private Methods

- (void)setupView
{
    self.angle = [self defaultAngle];
    self.backgroundColor = [UIColor darkGrayColor];
}

- (void)updateColorPath
{
    CAShapeLayer *colorSublayer = [self.layer.sublayers lastObject];
    
    colorSublayer.strokeColor = [self colorFromCurrentAngle].CGColor;
    colorSublayer.strokeEnd = self.angle / (CGFloat)[self maxAngle];
}

- (UIColor *)colorFromCurrentAngle
{
    return [self colorFromAngle:self.angle];
}

- (UIColor *)colorFromAngle:(NSUInteger)newAngle
{
    CGFloat maxAngle = (CGFloat)[self maxAngle];
    
    CGFloat green = ((CGFloat)newAngle / (maxAngle -1));
    CGFloat red = (- 1 / (maxAngle - 1) * (CGFloat)newAngle) + 1;
    
    return [UIColor colorWithRed:red green:green blue:0 alpha:1];
}

- (void)setupAnimationGroup
{
    self.colorPathStrokeColorAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    self.colorPathStrokeColorAnimation.duration = kAnimationDuration;
    
    self.colorPathStrokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    self.colorPathStrokeEndAnimation.duration = kAnimationDuration;
    
    self.colorPathGroupAnimation = [CAAnimationGroup animation];
    self.colorPathGroupAnimation.animations = @[self.colorPathStrokeColorAnimation, self.colorPathStrokeEndAnimation];
    self.colorPathGroupAnimation.duration = kAnimationDuration;
}

@end

/****************   CADCircularVoteCountView        ****************/

static NSUInteger const kCircularMaxAngle = 360;
static NSUInteger const kCircularDefaultAngle = 180;
static NSUInteger const kCircularActualMaxAngle = 343;

static CGFloat const kPaddingArea = 10.0f;
static CGFloat const kDefaultColorLineWidthRatio = 6.0f;
static CGFloat const kDefaultBackgroundLineWidthRatio = 4.0f;

@implementation CADCircularVoteCountView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.radius = (CGRectGetWidth(self.frame)/2) - kPaddingArea;
    
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

- (void)setAngle:(NSUInteger)newAngle animationType:(CADVoteCountViewAnimationType)animationType
{
    if (newAngle>kCircularMaxAngle || newAngle == angle)
        return;
    
    if (newAngle>kCircularActualMaxAngle)
    {
        newAngle = kCircularActualMaxAngle;
    }
    
    CGFloat alpha = newAngle > angle ? newAngle*1.2f : newAngle*0.8f,
    maxAngle = (CGFloat)[self maxAngle];
    
    [self setupAnimationGroup];
    
    self.colorPathStrokeEndAnimation.values = @[@(angle / maxAngle),
                                                @(alpha / maxAngle),
                                                @(newAngle / maxAngle)];
    
    self.colorPathStrokeColorAnimation.values = @[(id)[self colorFromAngle:angle].CGColor,
                                                  (id)[self colorFromAngle:alpha].CGColor,
                                                  (id)[self colorFromAngle:newAngle].CGColor];
    
    angle = newAngle;
    
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
    return kCircularDefaultAngle;
}

- (NSUInteger)maxAngle
{
    return kCircularMaxAngle;
}

@end

/****************   CADLinearVoteCountView      ****************/

static NSUInteger const kLinearMaxAngle = 100;
static NSUInteger const kLinearDefaultAngle = 50;

@implementation CADLinearVoteCountView

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

- (void)setAngle:(NSUInteger)newAngle animationType:(CADVoteCountViewAnimationType)animationType
{
    if (newAngle>[self maxAngle] || newAngle == angle)
        return;
    
    CGFloat alpha = newAngle > angle ? newAngle*1.2f : newAngle*0.8f,
    maxAngle = (CGFloat)[self maxAngle];
    
    [self setupAnimationGroup];
    
    self.colorPathStrokeEndAnimation.values = @[@(angle / maxAngle),
                                                @(alpha / maxAngle),
                                                @(newAngle / maxAngle)];
    
    self.colorPathStrokeColorAnimation.values = @[(id)[self colorFromAngle:angle].CGColor,
                                                  (id)[self colorFromAngle:alpha].CGColor,
                                                  (id)[self colorFromAngle:newAngle].CGColor];
    
    angle = newAngle;
    
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
    return kLinearDefaultAngle;
}

- (NSUInteger)maxAngle
{
    return kLinearMaxAngle;
}

CGMutablePathRef createLineForRect(CGRect rect)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, CGRectGetHeight(rect)/2);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetHeight(rect)/2);
    
    return path;
}

@end