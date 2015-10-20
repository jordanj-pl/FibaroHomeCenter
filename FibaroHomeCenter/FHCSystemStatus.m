//
//  FHCSystemStatus.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCSystemStatus.h"

@implementation FHCSystemStatus

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        _identifier = [dictionary[@"last"] intValue];
        _status = dictionary[@"status"];
        _date = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"timestamp"] integerValue]];
        
        _changes = [NSSet setWithArray:dictionary[@"changes"]];
    }
    return self;
}

-(NSString*)description {
	return [NSString stringWithFormat:@"<%@: %@ (%@) last=%d>", [self class], self.status, self.date, self.identifier];
}

@end
