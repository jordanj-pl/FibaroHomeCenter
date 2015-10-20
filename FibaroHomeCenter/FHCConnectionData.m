//
//  FHCConnectionData.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCConnectionData.h"

@implementation FHCConnectionData

+(instancetype)connectionDataForURL:(NSURL *)url withLogin:(NSString *)login andPassword:(NSString *)password {
    FHCConnectionData *cd = [[self alloc] init];
    cd->_url = url;
    cd->_login = login;
    cd->_password = password;
    return cd;
}

-(void)updateDataWithURL:(NSURL *)url andLogin:(NSString *)login {
    _url = url;
    _login = login;
}

-(void)setPassword:(NSString *)password {
    _password = password;
}

-(NSUInteger)hash {
    return [[NSString stringWithFormat:@"%@ %@ %@", self.friendlyName, self.url, self.login] hash];
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@: URL: %@, login: %@>", [self class], [self.url absoluteString], self.login];
}

#pragma mark - NSCoding methods

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        _friendlyName = [aDecoder decodeObjectForKey:@"friendlyName"];
        _url = [aDecoder decodeObjectForKey:@"url"];
        _login = [aDecoder decodeObjectForKey:@"login"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.friendlyName forKey:@"friendlyName"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.login forKey:@"login"];
}

@end
