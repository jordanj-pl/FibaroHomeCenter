//
//  FHCApiStatusMonitor.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 16.10.2015.
//  Copyright © 2015 Jordan Jasinski. All rights reserved.
//

@import Foundation;

@class FHCApi;

@interface FHCApiStatusMonitor : NSObject

-(instancetype)initWithApi:(FHCApi*)api;

-(void)start;
-(void)stop;

@end
