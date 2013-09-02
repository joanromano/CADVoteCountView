//
//  CADVoteCountView.h
//  Gossip
//
//  Created by Joan Romano on 10/05/13.
//  Copyright (c) 2013 Oriol Blanc. All rights reserved.
//

@interface CADVoteCountView : UIView

/**
 The background color for the arc. Defaults to [UIColor colorWithRed:68.0f/255.0f green:68.0f/255.0f blue:68.0f/255.0f alpha:1.0f]
 */

@property (nonatomic, strong) UIColor *backgroundLayerColor;

/**
 The line width ratio for both the background and color layers, measured:
    lineWidth = CGRectGetWidth(self.bounds) / ratio
 
 Thus, the colorLineWidthRatio should ALWAYS be bigger or equal than the backgroundLineWidthRatio. 
 
 Default values are:
 
 backgroundLineWidthRatio = 4.0f
 colorLineWidthRatio = 6.0f
 */

@property (nonatomic) CGFloat backgroundLineWidthRatio;
@property (nonatomic) CGFloat colorLineWidthRatio;

/**
 The angle for the inner colored arc, expressed in degrees.
 */

@property (nonatomic) NSUInteger angle;

/**
 Sets the angle for the inner colored arc.
 
 @param angle The angle, expressed in degrees
 @param bouncing YES to animate the angle change bouncing, NO otherwise

 @warning The angle shouldn't be bigger than +maxAngle and smaller than 0. Values out of this range are ignored.
 @warning Layers by default animate their changes, so note that even with bouncing=NO the angle change will be animated.
 */

- (void)setAngle:(NSUInteger)angle bouncing:(BOOL)bouncing;

+ (NSUInteger)maxAngle;

@end
