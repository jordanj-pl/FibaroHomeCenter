//
//  FHCRoomTableViewController.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 09.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

@class FHCApi;
@class FHCRoom;

@interface FHCRoomTableViewController : UITableViewController

@property (nonatomic, weak) FHCApi *api;
@property (nonatomic, weak) FHCRoom *selectedRoom;

@end
