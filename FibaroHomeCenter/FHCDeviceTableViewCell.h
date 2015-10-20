//
//  FHCDeviceTableViewCell.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 15.10.2015.
//  Copyright © 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

@interface FHCDeviceTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

-(void)changeLayoutLockedWithAnimation:(BOOL)animation;
-(void)changeLayoutActiveWithAnimation:(BOOL)animation;

@end
