//
//  FHCDevicesStore.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 01.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCDevicesStore.h"

@interface FHCDevicesStore () {
    NSMutableArray *_deviceList;
}

@end

@implementation FHCDevicesStore

+(instancetype)sharedStore {
    static FHCDevicesStore *sharedStore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

-(instancetype)init {
    [NSException raise:@"Singleton" format:@"Use + [FHCDeviceStore sharedStore]"];
    
    return nil;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        NSString *path = [self itemArchivePath];
        _deviceList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if(!_deviceList) {
            _deviceList = [NSMutableArray array];
        }

    }
    return self;
}

-(void)addDeviceWithConnectionData:(FHCConnectionData *)cd {
    [_deviceList addObject:cd];
}

-(void)removeDeviceWithConnectionData:(FHCConnectionData *)cd {
    [_deviceList removeObject:cd];
}

-(NSString*)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"DevicesStore.data"];
}

-(BOOL)save {
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.deviceList toFile:path];
}

@end
