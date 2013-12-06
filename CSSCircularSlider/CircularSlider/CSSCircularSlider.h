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
 CSSCircularSlider is a round slider control. 
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
 An image view that is in the background of the control.
 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

/**
 You can specify a background image for the slider track.
 
 This image will be masked by the circle, so that it can be used to display
 a fancy gradient as the circle background or something like that.
 
 When circleBackgroundImage is not nil the circleColor will be ignored.
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
 * The color used to tint the standard thumb.
 */
@property (nonatomic, strong) UIColor *thumbTintColor;

/**
 Background color of the circle.
 This has no effect if a circleBackgroundImage is set.
 */
@property (nonatomic, strong) UIColor *circleBackgroundColor;

/**
 Color of the active part of the circle (zero to where the thumb knob is).
 This has no effect if a background image is set.
 */
@property (nonatomic, strong) UIColor *circleActiveColor;

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
 *
 * @warning Not implemented Yet.
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
