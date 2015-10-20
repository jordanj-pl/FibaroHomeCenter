//
//  FHCDimmableLightBinarySwitchDeviceTableViewCell.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 16.10.2015.
//  Copyright © 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCDimmableLightBinarySwitchDeviceTableViewCell.h"

@implementation FHCDimmableLightBinarySwitchDeviceTableViewCell

-(IBAction)sliderAction:(id)sender {
	if(self.sliderAction) {
		self.sliderAction(((int)(self.slider.value*100)));
	}
}

-(void)changeLayoutActiveWithAnimation:(BOOL)animation {
	[super changeLayoutActiveWithAnimation:animation];
	
	self.slider.userInteractionEnabled = YES;
}

-(void)changeLayoutLockedWithAnimation:(BOOL)animation {
	[super changeLayoutLockedWithAnimation:animation];
	
	self.slider.userInteractionEnabled = NO;
}

-(void)prepareForReuse {
	[super prepareForReuse];
	
	self.slider.userInteractionEnabled = YES;
}

@end
