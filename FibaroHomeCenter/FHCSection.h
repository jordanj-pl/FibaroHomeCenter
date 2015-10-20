//
//  FHCSection.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FHCSection : NSObject

@property (nonatomic, readonly, assign) int identifier;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) int sortOrder;
@property (atomic, copy) NSArray *rooms;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
