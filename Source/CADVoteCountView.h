//
//  CADVoteCountView.h
//  Gossip
//
//  Created by Joan Romano on 10/05/13.
//  Copyright (c) 2013 Oriol Blanc. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CADVoteCountViewType){
    CADVoteCountViewTypeCircular,
    CADVoteCountViewTypeLinear
};

typedef NS_ENUM(NSUInteger, CADVoteCountViewAnimationType){
    /**
     No animation are applied to the angle change.
     */
    CADVoteCountViewAnimationTypeNone,
    
    /**
     Default CALayer implicit animations are applied to the angle change.
     */
    CADVoteCountViewAnimationTypeDefault,
    
    /**
     Special bounce animations are applied to the angle change.
     */
    CADVoteCountViewAnimationTypeBouncing
};

@interface CADVoteCountView : UIView

+ (CADVoteCountView *)voteCountViewWithType:(CADVoteCountViewType)type;

/**
 The angle for the inner colored arc, expressed in degrees.
 */
@property (nonatomic) NSUInteger angle;

/**
 Sets the angle for the inner colored arc.
 
 @param angle The angle to animate
 @param animationType The kind of animation you want to apply

 @warning The angle shouldn't be bigger than +maxAngle and smaller than 0. Values out of this range are ignored.
 */
- (void)setAngle:(NSUInteger)angle animationType:(CADVoteCountViewAnimationType)animationType;

- (NSUInteger)maxAngle;
- (NSUInteger)defaultAngle;

@end
