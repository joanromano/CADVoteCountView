//
//  CADVoteCountView.h
//  Gossip
//
//  Created by Joan Romano on 10/05/13.
//  Copyright (c) 2013 Oriol Blanc. All rights reserved.
//

@interface CADVoteCountView : UIView

/**
 The background color for the arc. Defaults to [UIColor darkGrayColor]
 */

@property (nonatomic, strong) UIColor *backgroundLayerColor;

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
