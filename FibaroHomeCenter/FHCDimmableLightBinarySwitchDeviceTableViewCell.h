//
//  FHCDimmableLightBinarySwitchDeviceTableViewCell.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 16.10.2015.
//  Copyright © 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCBinarySwitchDeviceTableViewCell.h"

@interface FHCDimmableLightBinarySwitchDeviceTableViewCell : FHCBinarySwitchDeviceTableViewCell

@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, copy) void (^sliderAction)(int value);

@end
