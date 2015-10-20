//
//  FHCRoom.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import Foundation;

@class FHCSection;

@interface FHCRoom : NSObject

@property (nonatomic, readonly, assign) int identifier;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) int sortOrder;
@property (nonatomic, weak) FHCSection *section;
@property (atomic, copy) NSArray *devices;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
