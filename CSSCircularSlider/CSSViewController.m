//
//  CSSViewController.m
//  CSSCircularSlider
//
//  Created by Cornelius Schiffer on 04.12.13.
//  Copyright (c) 2013 schiffr.de. All rights reserved.
//

#import "CSSViewController.h"
#import "CSSCircularSlider.h"

@interface CSSViewController ()

@property (weak, nonatomic) IBOutlet CSSCircularSlider *slider;

@end

@implementation CSSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.slider.thickness = 8.0f;
    self.slider.backgroundImage = [UIImage imageNamed:@"bg"];
    self.slider.layer.borderWidth = 1.0;
    self.slider.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
