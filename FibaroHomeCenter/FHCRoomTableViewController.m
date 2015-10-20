//
//  FHCRoomTableViewController.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 09.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCRoomTableViewController.h"

#import "FHCApi.h"

#import "FHCRoom.h"
#import "FHCDevice.h"

#import "FHCDeviceTableViewCell.h"
#import "FHCBinarySwitchDeviceTableViewCell.h"
#import "FHCDimmableLightBinarySwitchDeviceTableViewCell.h"

@interface FHCRoomTableViewController ()

@end

@implementation FHCRoomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.selectedRoom.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectedRoom.devices count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FHCDevice *device = [self.selectedRoom.devices objectAtIndex:indexPath.row];
	
	NSLog(@"::>> Device: %@ (%d)", device, device.propertyValue);
	FHCDeviceTableViewCell *cell;
	
	if([device.type isEqualToString:@"binary_light"]) {
		FHCBinarySwitchDeviceTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"devicesTableViewOnOff" forIndexPath:indexPath];
		
		switchCell.binarySwitch.on = (bool)device.propertyValue;
		
		if(device.changeInProgress) {
			[switchCell changeLayoutLockedWithAnimation:NO];
		}
		
		switchCell.binarySwitchAction = ^(BOOL status) {
			NSLog(@"SWITCH: %d", status);

			device.changeInProgress = YES;
			[switchCell changeLayoutLockedWithAnimation:YES]; //TODO consider if it really leads retain-cycle.
			
			if(status) {
				[self.api turnOnDevice:device];
			} else {
				[self.api turnOffDevice:device];
			}
		};
		
		cell = switchCell;
	} else if([device.type isEqualToString:@"dimmable_light"]) {
		FHCDimmableLightBinarySwitchDeviceTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:@"devicesTableViewDimmable" forIndexPath:indexPath];
		
		sliderCell.binarySwitch.on = (bool)device.propertyValue;
		sliderCell.slider.value = (float)(((float)device.propertyValue)/100.0f);
		
		if(device.changeInProgress) {
			[sliderCell changeLayoutLockedWithAnimation:YES];
		}

		sliderCell.binarySwitchAction = ^(BOOL status) {
			NSLog(@"SWITCH: %d", status);
			
			device.changeInProgress = YES;
			[sliderCell changeLayoutLockedWithAnimation:YES];

			if(status) {
				[self.api turnOnDevice:device];
			} else {
				[self.api turnOffDevice:device];
			}
		};
		
		sliderCell.sliderAction = ^(int value) {
			NSLog(@"SLIDER: %d", value);

			device.changeInProgress = YES;
			[sliderCell changeLayoutLockedWithAnimation:YES];

			[self.api setValue:value forDevice:device];
		};
		
		cell = sliderCell;
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"devicesTableViewUnsupported" forIndexPath:indexPath];
	}

	cell.nameLabel.text = device.name;
    
    return cell;
}


@end
