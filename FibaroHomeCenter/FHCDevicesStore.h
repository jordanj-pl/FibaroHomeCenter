//
//  FHCDevicesStore.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 01.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import Foundation;

@class FHCConnectionData;

@interface FHCDevicesStore : NSObject

@property (atomic, readonly, strong) NSArray *deviceList;

+(instancetype)sharedStore;

-(void)addDeviceWithConnectionData:(FHCConnectionData*)cd;
-(void)removeDeviceWithConnectionData:(FHCConnectionData*)cd;

-(BOOL)save;

@end
