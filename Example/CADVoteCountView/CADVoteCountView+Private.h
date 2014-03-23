//
//  CADVoteCountView+Private.h
//  CADVoteCountView
//
//  Created by Joan Romano on 23/03/14.
//  Copyright (c) 2014 Joan Romano. All rights reserved.
//

#import "CADVoteCountView.h"

@interface CADVoteCountView (Private)

@property (nonatomic, strong) CAAnimationGroup *colorPathGroupAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *colorPathStrokeEndAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *colorPathStrokeColorAnimation;

- (void)updateColorPath;

- (UIColor *)colorFromCurrentAngle;
- (UIColor *)colorFromAngle:(NSUInteger)angle;

@end
