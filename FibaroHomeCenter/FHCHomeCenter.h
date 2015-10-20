//
//  FHCHomeCenter.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import Foundation;

@interface FHCHomeCenter : NSObject

@property (nonatomic, readonly, copy) NSString *mac;
@property (nonatomic, readonly, copy) NSString *serialNumber;
@property (nonatomic, readonly, copy) NSString *softwareVersion;
@property (copy) NSArray *sections;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
