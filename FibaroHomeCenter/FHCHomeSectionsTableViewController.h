//
//  FHCHomeSectionsTableViewController.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 07.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

@class FHCApi;
@class FHCHomeCenter;

@interface FHCHomeSectionsTableViewController : UITableViewController

@property (nonatomic, weak) FHCApi *api;

-(void)updateDevices;

@end
