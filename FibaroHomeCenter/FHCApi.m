//
//  FHCApi.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCApi.h"

#import "FHCConnectionData.h"
#import "FHCHomeCenter.h"
#import "FHCSection.h"
#import "FHCRoom.h"
#import "FHCDevice.h"
#import "FHCSystemStatus.h"

@interface FHCApi ()<NSURLSessionDataDelegate>

@property (nonatomic, readonly, strong) FHCConnectionData *connectionData;
@property (nonatomic, readwrite, strong) FHCHomeCenter *currentHomeCenter;

@property (nonatomic, strong) NSURLSession *session;

-(void)retrieveSectionsWithCompletion:(void(^)(NSArray *sections))completion andFailure:(void (^)(NSError *))failure;
-(void)retrieveRoomsWithCompletion:(void(^)(NSArray *rooms))completion andFailure:(void (^)(NSError *))failure;
-(void)retrieveDevicesWithCompletion:(void(^)(NSArray *devices))completion andFailure:(void (^)(NSError *))failure;
-(NSArray *)combineSections:(NSArray*)sections rooms:(NSArray*)rooms andDevices:(NSArray*)devices;

@end

@implementation FHCApi

+(instancetype)apiForConnection:(FHCConnectionData *)cd {
    FHCApi *api = [[self alloc] init];
    api->_connectionData = cd;
    return api;
}

-(instancetype)init {
    self = [super init];
    if(self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<%@ connection=%@>", [self class], self.connectionData];
}

-(NSString*)connectionName {
    return self.connectionData.friendlyName;
}

#pragma mark - API methods

-(void)retrieveHCInfoWithSuccess:(void (^)(FHCHomeCenter *))completion andFailure:(void (^)(NSError *))failure {

    NSURL *url = [NSURL URLWithString:@"/api/settings/info" relativeToURL:self.connectionData.url];

	__weak FHCApi *weakSelf = self;
	
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

		FHCApi *strongSelf = weakSelf;
		
        if(error) {
            if(failure) {
                failure(error);
            }

            return;
        }
        
        NSError *jsonParsingError;
        NSDictionary *objDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if(objDict) {
            FHCHomeCenter *device = [[FHCHomeCenter alloc] initWithDictionary:objDict];
			strongSelf.currentHomeCenter = device;
            if(completion) {
                completion(device);
                return;
            }
        } else {
            if(failure) {
                failure(jsonParsingError);
                return;
            }
        }

    }];
    
    [task resume];
}

-(void)updateDevicesForHomeCenter:(FHCHomeCenter *)hc withSuccess:(void (^)())success andFailure:(void (^)(NSError *))failure {

	if(!hc) {
		hc = self.currentHomeCenter;
	}
	
    __block int errorCount = 0;
    
    __block NSArray *retrievedSections;
    __block NSArray *retrievedRooms;
    __block NSArray *retrievedDevices;
    
    dispatch_group_t retrieveGroup = dispatch_group_create();

    dispatch_group_enter(retrieveGroup);
    [self retrieveSectionsWithCompletion:^(NSArray *sections) {
        
        retrievedSections = sections;
        dispatch_group_leave(retrieveGroup);
    } andFailure:^(NSError *error) {
        if(failure) {
            failure(error);
        }

        errorCount++;
        dispatch_group_leave(retrieveGroup);
    }];

    dispatch_group_enter(retrieveGroup);
    [self retrieveRoomsWithCompletion:^(NSArray *rooms) {
        
        retrievedRooms = rooms;
        dispatch_group_leave(retrieveGroup);
    } andFailure:^(NSError *error) {
        if(failure) {
            failure(error);
        }

        errorCount++;
        dispatch_group_leave(retrieveGroup);
    }];

    dispatch_group_enter(retrieveGroup);
    [self retrieveDevicesWithCompletion:^(NSArray *devices) {
        
        retrievedDevices = devices;
        dispatch_group_leave(retrieveGroup);
    } andFailure:^(NSError *error) {
        if(failure) {
            failure(error);
        }

        errorCount++;
        dispatch_group_leave(retrieveGroup);
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_group_wait(retrieveGroup, DISPATCH_TIME_FOREVER);
        NSLog(@"::>> 5 -> %d", errorCount);
        if(errorCount == 0) {
            
            hc.sections = [self combineSections:retrievedSections rooms:retrievedRooms andDevices:retrievedDevices];
            
            if(success) {
                success();
            }
        }
    });
    
}

-(void)retrieveSectionsWithCompletion:(void (^)(NSArray *))completion andFailure:(void (^)(NSError *))failure {
    NSURL *url = [NSURL URLWithString:@"/api/sections" relativeToURL:self.connectionData.url];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if(error) {
            if(failure) {
                failure(error);
            }

            return;
        }

        NSError *jsonParsingError;
        NSArray *objDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if(objDict) {

            if(completion) {
                completion(objDict);
                return;
            }
        } else {

            if(failure) {
                failure(jsonParsingError);
                return;
            }
        }
    }];
    
    [task resume];
}

-(void)retrieveRoomsWithCompletion:(void (^)(NSArray *))completion andFailure:(void (^)(NSError *))failure {
    NSURL *url = [NSURL URLWithString:@"/api/rooms" relativeToURL:self.connectionData.url];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error) {
            if(failure) {
                failure(error);
            }
            
            return;
        }
        
        NSError *jsonParsingError;
        NSArray *objDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if(objDict) {
            if(completion) {
                completion(objDict);
                return;
            }
        } else {
            if(failure) {
                failure(jsonParsingError);
                return;
            }
        }
    }];
    
    [task resume];
}

-(void)retrieveDevicesWithCompletion:(void (^)(NSArray *))completion andFailure:(void (^)(NSError *))failure {
    NSURL *url = [NSURL URLWithString:@"/api/devices" relativeToURL:self.connectionData.url];
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error) {
            if(failure) {
                failure(error);
            }
            
            return;
        }
        
        NSError *jsonParsingError;
        NSArray *objDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if(objDict) {
/*
            NSMutableArray *sections = [NSMutableArray array];
            
            if([objDict isKindOfClass:[NSArray class]]) {
                for (NSDictionary *sectionDict in objDict) {
                    FHCDevice *section = [[FHCDevice alloc] initWithDictionary:sectionDict];
                    [sections addObject:section];
                }
            }
*/
            if(completion) {
                completion(objDict);
                return;
            }
        } else {
            if(failure) {
                failure(jsonParsingError);
                return;
            }
        }
    }];
    
    [task resume];    
}

-(NSArray*)combineSections:(NSArray *)sections rooms:(NSArray *)rooms andDevices:(NSArray *)devices {
    NSMutableArray *result = [NSMutableArray array];
    
    NSMutableDictionary *sectionsDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *sectionsRoomsArrayDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *roomsDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *roomsDevicesArrayDict = [NSMutableDictionary dictionary];
    
    for(NSDictionary *sectionDict in sections) {
        FHCSection *section = [[FHCSection alloc] initWithDictionary:sectionDict];
        [result addObject:section];
        
        [sectionsDict setObject:section forKey:@(section.identifier)];
        [sectionsRoomsArrayDict setObject:[NSMutableArray array] forKey:@(section.identifier)];
    }

    for(NSDictionary *roomDict in rooms) {
        FHCRoom *room = [[FHCRoom alloc] initWithDictionary:roomDict];
        NSNumber *sectionId = roomDict[@"sectionID"];
        room.section = sectionsDict[sectionId];
        [sectionsRoomsArrayDict[@(room.section.identifier)] addObject:room];
        
        [roomsDict setObject:room forKey:@(room.identifier)];
        [roomsDevicesArrayDict setObject:[NSMutableArray array] forKey:@(room.identifier)];
    }

    for (FHCSection *section in result) {
        section.rooms = sectionsRoomsArrayDict[@(section.identifier)];
    }

    for (NSDictionary *deviceDict in devices) {
        FHCDevice *device = [[FHCDevice alloc] initWithDictionary:deviceDict];
        NSNumber *roomId = deviceDict[@"roomID"];
        device.room =  roomsDict[roomId];
        
        [roomsDevicesArrayDict[@(device.room.identifier)] addObject:device];
    }
    
    [roomsDict enumerateKeysAndObjectsUsingBlock:^(id key, FHCRoom *room, BOOL *stop) {
        room.devices = roomsDevicesArrayDict[@(room.identifier)];
    }];
	
//    NSLog(@"SECTIONS: %@", result);
//    NSLog(@"ROOMS: %@", sectionsRoomsArrayDict);
//    NSLog(@"DEVICES: %@", roomsDevicesArrayDict);

    return [NSArray arrayWithArray:result];
}

-(void)turnOnDevice:(FHCDevice*)device {
	
	[self sendAction:@"turnOn" forDevice:device withArguments:nil andCompletionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		NSLog(@"::>> (turnOn) response: %@", response);
	}];
	
}

-(void)turnOffDevice:(FHCDevice*)device {
	
	[self sendAction:@"turnOff" forDevice:device withArguments:nil andCompletionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		NSLog(@"::>> (turnOff) response: %@", response);
	}];
	
}

-(void)setValue:(int)value forDevice:(FHCDevice *)device {
	
	[self sendAction:@"setValue" forDevice:device withArguments:@[@(value)] andCompletionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		NSLog(@"::>> (setValue) response: %@", response);
	}];
}

-(void)sendAction:(NSString*)actionName forDevice:(FHCDevice*)device withArguments:(NSArray*)arguments andCompletionHandler:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))cp {
	NSMutableString *urlString = [NSMutableString stringWithFormat:@"/api/callAction?deviceID=%d&name=%@", device.identifier, actionName];
	
	if(arguments) {
		NSUInteger numberOfArguments = [arguments count];
		for (NSUInteger i=0; i<numberOfArguments; i++) {
			id argValue = arguments[i];

			if([argValue isKindOfClass:[NSString class]]) {
				[urlString appendFormat:@"&arg%lu=%@", i, argValue];
			} else if([argValue isKindOfClass:[NSNumber class]]) {
				[urlString appendFormat:@"&arg%lu=%d", i, [argValue intValue]];
			}
		}
		
	}
	
	NSURL *url = [NSURL URLWithString:urlString relativeToURL:self.connectionData.url];
	
	NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if(cp) {
			cp(data, response, error);
		}
		
	}];
	
	[task resume];
}

-(void)retrieveStatusUpdateWithLastId:(int)lastId completion:(void (^)(FHCSystemStatus *))completion andFailure:(void (^)(NSError *))failure {
	
	NSString *urlString = [NSString stringWithFormat:@"/api/refreshStates?last=%d", lastId];
	NSURL *url = [NSURL URLWithString:urlString relativeToURL:self.connectionData.url];
	
	NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		if(!error) {
			NSError *parsingError;
			NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
			if(result) {
				if(completion) {
					completion([[FHCSystemStatus alloc] initWithDictionary:result]);
				}
			} else {
				if(failure) {
					failure(parsingError);
				}
			}
		} else {
			if(failure) {
				failure(error);
			}
		}
	}];
	
	[task resume];
	
	
}

#pragma mark - NSURLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    
    NSURLCredential *credentials = [NSURLCredential credentialWithUser:self.connectionData.login password:self.connectionData.password persistence:NSURLCredentialPersistenceForSession];
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, credentials);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {

    NSURLCredential *credentials = [NSURLCredential credentialWithUser:self.connectionData.login password:self.connectionData.password persistence:NSURLCredentialPersistenceForSession];
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, credentials);
}

@end
