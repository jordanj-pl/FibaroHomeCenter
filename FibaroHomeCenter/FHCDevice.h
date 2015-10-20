//
//  FHCDevice.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import Foundation;

@class FHCRoom;

@interface FHCDevice : NSObject

@property (nonatomic, readonly, assign) int identifier;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *type;
@property (nonatomic, readonly, assign) int sortOrder;
@property (nonatomic, readonly, assign) int propertyValue;

@property (nonatomic, assign) BOOL changeInProgress;

@property (nonatomic, weak) FHCRoom *room;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
