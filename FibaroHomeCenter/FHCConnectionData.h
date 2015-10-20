//
//  FHCConnectionData.h
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

@import Foundation;

@interface FHCConnectionData : NSObject<NSCoding>

@property (nonatomic, readonly, copy) NSString *login;
@property (nonatomic, readonly, copy) NSString *password;
@property (nonatomic, readonly, copy) NSURL *url;
@property (nonatomic, copy) NSString *friendlyName;

+(instancetype)connectionDataForURL:(NSURL*)url withLogin:(NSString*)login andPassword:(NSString*)password;

-(void)updateDataWithURL:(NSURL*)url andLogin:(NSString*)login;

-(void)setPassword:(NSString *)password;

@end
