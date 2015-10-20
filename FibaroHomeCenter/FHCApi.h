//
//  FHCApi.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import Foundation;

@class FHCConnectionData;
@class FHCHomeCenter;
@class FHCDevice;
@class FHCSystemStatus;

@interface FHCApi : NSObject

@property (nonatomic, strong, readonly) FHCHomeCenter *currentHomeCenter;

+(instancetype)apiForConnection:(FHCConnectionData*)cd;

-(NSString*)connectionName;

-(void)retrieveHCInfoWithSuccess:(void(^)(FHCHomeCenter *device))completion andFailure:(void(^)(NSError *error))failure;

-(void)updateDevicesForHomeCenter:(FHCHomeCenter*)hc withSuccess:(void(^)())success andFailure:(void (^)(NSError *))failure;

-(void)retrieveStatusUpdateWithLastId:(int)lastId completion:(void(^)(FHCSystemStatus *status))completion andFailure:(void(^)(NSError *error))failure;

-(void)turnOnDevice:(FHCDevice*)device;
-(void)turnOffDevice:(FHCDevice*)device;
-(void)setValue:(int)value forDevice:(FHCDevice*)device;

@end
