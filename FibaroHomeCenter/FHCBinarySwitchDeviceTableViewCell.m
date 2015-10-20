//
//  FHCBinarySwitchDeviceTableViewCell.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 16.10.2015.
//  Copyright © 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCBinarySwitchDeviceTableViewCell.h"

@implementation FHCBinarySwitchDeviceTableViewCell

-(IBAction)binarySwitchAction:(id)sender {
	if(self.binarySwitchAction) {
		self.binarySwitchAction(self.binarySwitch.on);
	}
}

-(void)changeLayoutActiveWithAnimation:(BOOL)animation {
	[super changeLayoutActiveWithAnimation:animation];
	
	self.binarySwitch.userInteractionEnabled = YES;
}

-(void)changeLayoutLockedWithAnimation:(BOOL)animation {
	[super changeLayoutLockedWithAnimation:animation];

	self.binarySwitch.userInteractionEnabled = NO;
}

-(void)prepareForReuse {
	[super prepareForReuse];
	
	self.binarySwitch.userInteractionEnabled = YES;
}

@end
