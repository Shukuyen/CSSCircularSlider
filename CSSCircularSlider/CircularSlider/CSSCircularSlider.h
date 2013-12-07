//
//  CSSCircularSlider.h
//  CSSCircularSlider
//
//  Created by Cornelius Schiffer on 04.12.13.
//  Copyright (c) 2013 schiffr.de. All rights reserved.
//
//  Uses code from the following MIT licensed projects:
//  - UICircularSlider by Zouhair Mahieddine (http://www.zedenem.com)
//  - STKViewController by Joe Conway

#import <UIKit/UIKit.h>

/**
 CSSCircularSlider is a round slider control with an image mask as the slider track.
 This enables you to display a round slider with nice background graphics.
 */
@interface CSSCircularSlider : UIControl

/// -----------------------
/// @name Configuration
/// -----------------------

/**
 Width of the circle
 */
@property (nonatomic, assign) float thickness;

/**
 Amount of padding the circle slider should have to the edges of the
 control
 */
@property (nonatomic, assign) float padding;

/**
 Amount of padding the thumb image center should have to the edges of the 
 control
 */
@property (nonatomic, assign) float thumbPadding;

/**
 Amount of padding the zero indicator image should have to the top edge
 of the control
 */
@property (nonatomic, assign) float zeroIndicatorPadding;

/**
 An image view that is in the background of the control.
 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

/**
 The background image for the slider track.
 
 This image will be masked by the circle, so that it can be used to display
 a fancy gradient as the circle background or something like that. It can be
 as big as the control, only the active part of the slider will be visible.
 */
@property (nonatomic, strong) UIImage *circleBackgroundImage;

/**
 An image to use as the knob where the user can drag the slider.
 If nil a default, single colored knob will be used.
 */
@property (nonatomic, strong) UIImage *thumbImage;

/**
 An image marking the zero value (12 o'clock)
 */
@property (nonatomic, strong) UIImage *zeroIndicatorImage;

/**
 * The minimum value of the receiver.
 *
 * If you change the value of this property, and the current value of the receiver is below the new minimum, the current value is adjusted to match the new minimum value automatically.
 * The default value of this property is 0.0.
 */
@property (nonatomic, assign) float minimumValue;

/**
 * The maximum value of the receiver.
 *
 * If you change the value of this property, and the current value of the receiver is above the new maximum, the current value is adjusted to match the new maximum value automatically.
 * The default value of this property is 1.0.
 */
@property (nonatomic, assign) float maximumValue;

/**
 * Contains a Boolean value indicating whether changes in the sliders value generate continuous update events.
 *
 * If YES, the slider sends update events continuously to the associated target’s action method.
 * If NO, the slider only sends an action event when the user releases the slider’s thumb control to set the final value.
 * The default value of this property is YES.
 */
@property (nonatomic, assign, getter=isContinuous) BOOL continuous;



/// -----------------------
/// @name Setting and getting the slider value
/// -----------------------

/**
 Current position of the slider
 */
@property (nonatomic, assign, readonly) float value;

/**
 Set the current slider position.
 
 @param value The slider value to set
 @param animated `YES` if the slider change should be animated
 */
- (void)setValue:(float)value animated:(BOOL)animated;

/**
 Set the slider value without animation
 
 @param value The slider value to set
 */
- (void)setValue:(float)value;


@end
