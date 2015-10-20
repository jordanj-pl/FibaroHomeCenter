//
//  FHCDevice.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCDevice.h"

@implementation FHCDevice

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        _identifier = [dictionary[@"id"] intValue];
        _name = dictionary[@"name"];
		_type = dictionary[@"type"];
        _sortOrder = [dictionary[@"sortOrder"] intValue];
		
		_propertyValue = [dictionary[@"properties"][@"value"] intValue];
    }
    return self;
}

-(NSUInteger)hash {
    return [[NSString stringWithFormat:@"%@ %d", [self class], self.identifier] hash];
}

-(BOOL)isEqual:(id)object {
    if([object isMemberOfClass:[self class]]) {
        if(self.identifier == ((FHCDevice*)object).identifier) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@ id=%d name=%@ type=%@>", [self class], self.identifier, self.name, self.type];
}

@end
