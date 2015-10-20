//
//  FHCHomeCenter.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCHomeCenter.h"

@implementation FHCHomeCenter

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        _mac = dictionary[@"mac"];
        _serialNumber = dictionary[@"serialNumber"];
        _softwareVersion = dictionary[@"softVersion"];
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@ mac=%@ serialNumber=%@>", [self class], self.mac, self.serialNumber];
}

@end
