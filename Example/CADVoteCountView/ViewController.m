//
//  ViewController.m
//  TopicRaterDemo
//
//  Created by Joan Romano on 30/08/13.
//  Copyright (c) 2013 Joan Romano. All rights reserved.
//

#import "ViewController.h"

#import "CADVoteCountView.h"

@interface ViewController ()

@property (nonatomic, strong) CADVoteCountView *countView;
@property (nonatomic, strong) UIButton *animateButton;
@property (nonatomic, strong) UIButton *animateWithBounceButton;
@property (nonatomic, strong) UIButton *changeBackgroundButton;

- (void)animateButtonPressed:(id)sender;
- (void)changeBackgoundColorButtonPressed:(id)sender;

- (void)animateVoteCountViewBouncing:(BOOL)bouncing;
- (void)setRandomBackgrounColor;
- (UIColor *)randomColor;

@end

@implementation ViewController

#pragma mark - Overridden

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [@[self.countView, self.animateButton, self.animateWithBounceButton, self.changeBackgroundButton]
     enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [self.view addSubview:subview];
    }];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.countView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.countView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_countView(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countView)]];
    [self.countView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_countView(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_countView]-80-[_animateButton]-[_changeBackgroundButton]-(>=0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countView, _animateButton, _changeBackgroundButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_animateButton(==100)]-[_animateWithBounceButton(==100)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_animateButton, _animateWithBounceButton)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.changeBackgroundButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
}

#pragma mark - Lazy

- (CADVoteCountView *)countView
{
    if (!_countView)
    {
        _countView = [[CADVoteCountView alloc] init];
        _countView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _countView;
}

- (UIButton *)animateButton
{
    if (!_animateButton)
    {
        _animateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _animateButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_animateButton addTarget:self action:@selector(animateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_animateButton setTitle:@"Animate" forState:UIControlStateNormal];
    }
    
    return _animateButton;
}

- (UIButton *)animateWithBounceButton
{
    if (!_animateWithBounceButton)
    {
        _animateWithBounceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _animateWithBounceButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_animateWithBounceButton addTarget:self action:@selector(animateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_animateWithBounceButton setTitle:@"Bounce" forState:UIControlStateNormal];
    }
    
    return _animateWithBounceButton;
}

- (UIButton *)changeBackgroundButton
{
    if (!_changeBackgroundButton)
    {
        _changeBackgroundButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _changeBackgroundButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_changeBackgroundButton addTarget:self action:@selector(changeBackgoundColorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_changeBackgroundButton setTitle:@"Change Background Color" forState:UIControlStateNormal];
    }
    
    return _changeBackgroundButton;
}

#pragma mark - Actions

- (void)animateButtonPressed:(id)sender
{
    [self animateVoteCountViewBouncing:(sender == self.animateWithBounceButton)];
}

- (void)changeBackgoundColorButtonPressed:(id)sender
{
    [self setRandomBackgrounColor];
}

#pragma mark - Private Methods

- (void)animateVoteCountViewBouncing:(BOOL)bouncing
{
    [self.countView setAngle:arc4random_uniform(360) bouncing:bouncing];
}

- (void)setRandomBackgrounColor
{
    
    self.countView.backgroundLayerColor = [self randomColor];
}

- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
