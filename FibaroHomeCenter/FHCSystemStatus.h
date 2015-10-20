//
//  FHCSystemStatus.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import Foundation;

@interface FHCSystemStatus : NSObject

@property (nonatomic, readonly, assign) int identifier;
@property (nonatomic, readonly, copy) NSString *status;
@property (nonatomic, readonly, copy) NSDate *date;
@property (nonatomic, readonly, strong) NSSet *changes;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
