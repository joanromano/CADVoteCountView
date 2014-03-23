//
//  CADVoteCountView.m
//  Gossip
//
//  Created by Joan Romano on 10/05/13.
//  Copyright (c) 2013 Oriol Blanc. All rights reserved.
//

#import "CADVoteCountView.h"

#import "CADVoteCountView+Private.h"
#import "CADCircularVoteCountView.h"
#import "CADLinearVoteCountView.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat const kAnimationDuration = 0.5f;

@interface CADVoteCountView ()

@property (nonatomic) NSUInteger radius;

@property (nonatomic, strong) CAAnimationGroup *colorPathGroupAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *colorPathStrokeEndAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *colorPathStrokeColorAnimation;

- (void)setupView;
- (void)updateColorPath;

- (UIColor *)colorFromCurrentAngle;
- (UIColor *)colorFromAngle:(NSUInteger)angle;

@end

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

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    
    ((CAShapeLayer *)self.layer).strokeColor = backgroundColor.CGColor;
}

#pragma mark - Public Methods

- (void)setAngle:(NSUInteger)angle
{
    [self setAngle:angle animationType:CADVoteCountViewAnimationTypeNone];
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

- (UIColor *)colorFromAngle:(NSUInteger)angle
{
    CGFloat maxAngle = (CGFloat)[self maxAngle];
    
    CGFloat green = ((CGFloat)angle / (maxAngle -1));
    CGFloat red = (- 1 / (maxAngle - 1) * (CGFloat)angle) + 1;
    
    return [UIColor colorWithRed:red green:green blue:0 alpha:1];
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

@end
