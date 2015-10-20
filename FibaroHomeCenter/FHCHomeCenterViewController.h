//
//  FHCHomeCenterViewController.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 06.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import UIKit;

@class FHCApi;

@interface FHCHomeCenterViewController : UIViewController

@property (nonatomic, strong) FHCApi *api;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@end
