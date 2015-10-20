//
//  FHCNewConnectionViewController.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 02.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

@class FHCConnectionData;

@interface FHCNewConnectionViewController : UIViewController

@property (nonatomic, assign) FHCConnectionData *connectionData;
@property (nonatomic, copy) void (^completionHandler)(FHCConnectionData *cd);

@end
