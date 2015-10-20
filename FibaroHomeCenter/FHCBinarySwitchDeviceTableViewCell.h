//
//  FHCBinarySwitchDeviceTableViewCell.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 16.10.2015.
//  Copyright © 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCDeviceTableViewCell.h"

@interface FHCBinarySwitchDeviceTableViewCell : FHCDeviceTableViewCell

@property (nonatomic, weak) IBOutlet UISwitch *binarySwitch;
@property (nonatomic, copy) void (^binarySwitchAction)(BOOL state);


@end
