//
//  CSSCircularSlider.m
//  CSSCircularSlider
//
//  Created by Cornelius Schiffer on 04.12.13.
//  Copyright (c) 2013 schiffr.de. All rights reserved.
//

#import "CSSCircularSlider.h"

@interface CSSCircularSlider()

/// -----------------------
/// @name Private Properties
/// -----------------------

/**
View for the circle so that we can put the thumb image on top of it
 */
@property (nonatomic, strong) UIImageView *circleView;

/**
 The layer used for the circle
 */
@property (nonatomic, assign) CAShapeLayer *circleLayer;

/**
 Current position of the slider
 */
@property (nonatomic, assign) float value;

/**
 ImageView for the thumb control
 */
@property (nonatomic, strong) UIImageView *thumbImageView;

/**
 ImageView for the zero position indicator image
 */
@property (nonatomic, strong) UIImageView *zeroIndicatorImageView;

@property (nonatomic, assign) CGFloat lastAngle;


/// -----------------------
/// @name Initialisation and setup
/// -----------------------

/**
 Common setup method
 */
- (void)setup;


/// -----------------------
/// @name Calculation
/// -----------------------

/**
 The radius calculated by the view frame minus 
 thickness of the circle
 
 @return Radius of the circle
 */
- (float)radius;


/// -----------------------
/// @name Drawing
/// -----------------------

/**
 Calculate the circle path and set it
 */
- (void)drawCircle;

/**
 Position the thumb image according to the slider value
 */
- (void)positionThumbImage;

/**
 Position the thumb image according to the specified value with optional animation
 
 @param value Slider value to move the thumb image to
 @param animationDuration Duration of the animation, 0 to disable animation
 */
- (void)positionThumbImageWithValue:(float)value duration:(float)animationDuration;

/**
 Update the position of the zero indicator image view
 */
- (void)positionZeroIndicator;


/// -----------------------
/// @name Gesture recognizer
/// -----------------------

- (void)panGestureHappened:(UIPanGestureRecognizer *)sender;


/// -----------------------
/// @name Utility functions
/// -----------------------

/**
 Translate a value in a source interval to a destination interval
 
 This function uses the linear function method, a.k.a. resolves the y=ax+b equation where y is a destination value and x a source value
 Formulas :	a = (dMax - dMin) / (sMax - sMin)
            b = dMax - a*sMax = dMin - a*sMin
 
 @param sourceValue					The source value to translate
 @param sourceIntervalMinimum		The minimum value in the source interval
 @param sourceIntervalMaximum		The maximum value in the source interval
 @param destinationIntervalMinimum	The minimum value in the destination interval
 @param destinationIntervalMaximum	The maximum value in the destination interval
 
 @return	The value in the destination interval
 */
float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, float sourceIntervalMinimum, float sourceIntervalMaximum, float destinationIntervalMinimum, float destinationIntervalMaximum);

/**
 Returns the smallest angle between three points, one of them clearly indicated as the "junction point" or "center point".
 
 This function uses the properties of the triangle and arctan (atan2f) function to calculate the angle.
 
 @param centerPoint	The "center point" or "junction point"
 @param p1			The first point, member of the [centerPoint p1] segment
 @param p2			The second point, member of the [centerPoint p2] segment
 
 @return			The angle between those two segments
 */
CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2);

@end




@implementation CSSCircularSlider

#pragma mark - View Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - Initialisation and setup

- (void)setup
{
    // Background image
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.backgroundImageView];
    
    self.circleView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.circleView.contentMode = UIViewContentModeScaleAspectFill;
    self.circleView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.circleView];
    
    _thickness = 8.0;
    _minimumValue = 0.0;
    _maximumValue = 1.0;
    _continuous = YES;
    
    self.thumbImageView = [[UIImageView alloc] initWithImage:[CSSCircularSlider defaultThumbImage]];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    self.circleLayer = layer;
    self.circleLayer.lineWidth = self.thickness;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleLayer.strokeColor = [UIColor blackColor].CGColor;
    self.circleLayer.frame = CGRectMake(self.thickness / 2,
                                        self.thickness / 2,
                                        self.bounds.size.width - self.thickness,
                                        self.bounds.size.height - self.thickness);
    

    [self.circleLayer setStrokeEnd:_value];
    
    [self.circleView.layer addSublayer:self.circleLayer];
    [self drawCircle];
    
    [self addSubview:self.thumbImageView];
    [self positionThumbImage];
    
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHappened:)];
	panGestureRecognizer.maximumNumberOfTouches = panGestureRecognizer.minimumNumberOfTouches;
	[self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Getter & Setter

+ (UIImage *)defaultThumbImage {
    static UIImage *defaultThumbImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 20.f), NO, 0.0f);
        
        [[UIColor blackColor] setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)] fill];
        
        [[UIColor whiteColor] setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, 18, 18)] fill];
        
        defaultThumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    
    return defaultThumbImage;
}

- (void)setCircleBackgroundImage:(UIImage *)backgroundImage
{
    if (![backgroundImage isEqual:_circleBackgroundImage]) {
        _circleBackgroundImage = backgroundImage;
        self.circleView.image = backgroundImage;
        [self.circleView.layer setMask:self.circleLayer];
        
        [self drawCircle];
    }
}

- (void)setThickness:(float)thickness
{
    if (thickness != _thickness) {
        _thickness = thickness;
        self.circleLayer.lineWidth = thickness;
        
        [self drawCircle];
        [self positionThumbImage];
        [self positionZeroIndicator];
    }
}

- (void)setPadding:(float)padding
{
    if (padding != _padding) {
        _padding = padding;
        
        [self drawCircle];
        [self positionThumbImage];
        [self positionZeroIndicator];
    }
}

- (void)setMinimumValue:(float)minimumValue
{
	if (minimumValue != _minimumValue) {
		_minimumValue = minimumValue;
		if (self.maximumValue < self.minimumValue)	{ self.maximumValue = self.minimumValue; }
		if (self.value < self.minimumValue)			{ self.value = self.minimumValue; }
	}
}

- (void)setMaximumValue:(float)maximumValue
{
	if (maximumValue != _maximumValue) {
		_maximumValue = maximumValue;
		if (self.minimumValue > self.maximumValue)	{ self.minimumValue = self.maximumValue; }
		if (self.value > self.maximumValue)			{ self.value = self.maximumValue; }
	}
}

- (void)setThumbPadding:(float)thumbPadding
{
    if (thumbPadding != _thumbPadding) {
        _thumbPadding = thumbPadding;
        
        [self positionThumbImage];
    }
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    if (thumbImage != _thumbImage) {
        _thumbImage = thumbImage;
        
        CGRect bounds;
        bounds.origin = CGPointZero;
        bounds.size = thumbImage.size;
        
        self.thumbImageView.bounds = bounds;
        self.thumbImageView.image = thumbImage;
    }
}

- (void)setZeroIndicatorImage:(UIImage *)zeroIndicatorImage
{
    if (_zeroIndicatorImage != zeroIndicatorImage) {
        _zeroIndicatorImage = zeroIndicatorImage;
        
        self.zeroIndicatorImageView = nil;
        self.zeroIndicatorImageView = [[UIImageView alloc] initWithImage:zeroIndicatorImage];
        [self insertSubview:self.zeroIndicatorImageView belowSubview:self.thumbImageView];
        [self positionZeroIndicator];
    }
}

- (void)setZeroIndicatorPadding:(float)zeroIndicatorPadding
{
    if (_zeroIndicatorPadding != zeroIndicatorPadding) {
        _zeroIndicatorPadding = zeroIndicatorPadding;
        
        [self positionZeroIndicator];
    }
}

#pragma mark - Setting the slider value

- (void)setValue:(float)value animated:(BOOL)animated
{
    if (value != _value) {
        float currentValue = _value;
        
		if (value > self.maximumValue) {
            value = self.maximumValue;
        }
        
		if (value < self.minimumValue) {
            value = self.minimumValue;
        }

        _value = value;
        
        float delta = fabs(_value - currentValue);
        float duration = MAX(0.2, delta * 1.0);
        
        // Update the thumb image
        [self positionThumbImageWithValue:_value duration:duration];
        
        // Update the circle
        [CATransaction begin];
        if (animated) {
            [CATransaction setAnimationDuration:duration];
        } else {
            [CATransaction setDisableActions:YES];
        }
        
        [self.circleLayer setStrokeEnd:_value];
        [CATransaction commit];

        if (self.isContinuous ) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)setValue:(float)value
{
    [self setValue:value animated:NO];
}


#pragma mark - Calculation

- (float)radius
{
    CGRect bounds = CGRectInset(self.bounds, self.thickness / 2.0 + self.padding, self.thickness / 2.0 + self.padding);
    float width = bounds.size.width;
    float height = bounds.size.height;
    
    return (width > height) ? height / 2.0 : width / 2.0;
}


#pragma mark - Gesture recognizer callbacks

- (void)panGestureHappened:(UIPanGestureRecognizer *)sender
{
    if (!self.enabled) {
        return;
    }
    
	CGPoint tapLocation = [sender locationInView:self];
    CGPoint sliderCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGPoint sliderStartPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - [self radius]);

    CGFloat angle = angleBetweenThreePoints(sliderCenter, sliderStartPoint, tapLocation);
    
    if (angle < 0) {
        angle = -angle;
    } else {
        angle = 2 * M_PI - angle;
    }

	switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.lastAngle = angle;
            break;
            
		case UIGestureRecognizerStateChanged:
        {
            // Prevent the jump from max value to zero value
            if (self.lastAngle > 5 && angle < 2) {
                angle = 2 * M_PI;
            } else if (angle > 5 && self.lastAngle < 2) {
                angle = 0;
            }
            
            [self setValue:translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2 * M_PI, self.minimumValue, self.maximumValue)];
            self.lastAngle = angle;
			break;
		}
            
        case UIGestureRecognizerStateEnded:
            if (!self.isContinuous) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        break;
            
		default:
			break;
	}
}


#pragma mark - Drawing

- (void)drawCircle
{
    float quarterThickness = self.thickness / 4;
    UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.padding + quarterThickness,
                                                                              self.padding + quarterThickness,
                                                                              2.0 * [self radius],
                                                                              2.0 * [self radius]) cornerRadius:[self radius]];
    self.circleLayer.path = circle.CGPath;
}

- (void)positionThumbImage
{
    [self positionThumbImageWithValue:self.value duration:0];
}

- (void)positionThumbImageWithValue:(float)value duration:(float)animationDuration
{
    // Angle for thumb image
    // (x + r * sin(a), y + r * cos(a))
    float angleFromTrack = translateValueFromSourceIntervalToDestinationInterval(value, self.minimumValue, self.maximumValue, 0, 2 * M_PI);
    float radiusWithThumbPadding = [self radius] - self.thumbPadding;

    if (animationDuration) {
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseInOut animations:^{
            self.thumbImageView.center = CGPointMake(CGRectGetMidX(self.bounds) + radiusWithThumbPadding * sinf(angleFromTrack),
                                                     CGRectGetMidY(self.bounds) - radiusWithThumbPadding * cosf(angleFromTrack));
        } completion:NULL];
    } else {
        self.thumbImageView.center = CGPointMake(CGRectGetMidX(self.bounds) + radiusWithThumbPadding * sinf(angleFromTrack),
                                                 CGRectGetMidY(self.bounds) - radiusWithThumbPadding * cosf(angleFromTrack));
    }
}

- (void)positionZeroIndicator
{
    if (self.zeroIndicatorImageView) {
        self.zeroIndicatorImageView.center = CGPointMake(CGRectGetMidX(self.bounds), self.padding + self.thickness / 2 + self.zeroIndicatorPadding);
    }
}

#pragma mark - Utility Functions

float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, float sourceIntervalMinimum, float sourceIntervalMaximum, float destinationIntervalMinimum, float destinationIntervalMaximum)
{
	float a;
    float b;
    float destinationValue;
	
	a = (destinationIntervalMaximum - destinationIntervalMinimum) / (sourceIntervalMaximum - sourceIntervalMinimum);
	b = destinationIntervalMaximum - a * sourceIntervalMaximum;
	
	destinationValue = a * sourceValue + b;
    
    
    
	return destinationValue;
}

CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2)
{
	CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
	CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
	
	CGFloat angle = atan2f(v2.x * v1.y - v1.x * v2.y, v1.x * v2.x + v1.y * v2.y);
	
	return angle;
}

@end
