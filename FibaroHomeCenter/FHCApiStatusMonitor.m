//
//  FHCApiStatusMonitor.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 16.10.2015.
//  Copyright © 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCApiStatusMonitor.h"

#import "FHCApi.h"
#import "FHCSystemStatus.h"

const char *kSyncQueueIdentifier = "aero.skyisthelimit.FHCApiStatusMonitorSyncQueue";

@interface FHCApiStatusMonitor () {
	BOOL _isRunning;
	int _lastCheckId;
	
	dispatch_queue_t _syncQueue;
}

@property (nonatomic, strong, readonly) FHCApi *api;
@property (atomic, assign) BOOL isRunning;

@property (atomic, assign) int lastCheckId;

@end

@implementation FHCApiStatusMonitor

-(instancetype)initWithApi:(FHCApi *)api {
	self = [super init];
	if(self) {
		_api = api;
		_syncQueue = dispatch_queue_create(kSyncQueueIdentifier, nil);
	}
	return self;
}

-(BOOL)isRunning {
	__block BOOL result;
	dispatch_sync(_syncQueue, ^{
		result = _isRunning;
	});
	return result;
}

-(void)setIsRunning:(BOOL)isRunning {
	dispatch_sync(_syncQueue, ^{
		_isRunning = isRunning;
	});
}

-(int)lastCheckId {
	__block int result;
	dispatch_sync(_syncQueue, ^{
		result = _lastCheckId;
	});
	return result;
}

-(void)setLastCheckId:(int)lastCheckId {
	dispatch_sync(_syncQueue, ^{
		if(lastCheckId >= _lastCheckId) {
			_lastCheckId = lastCheckId;
		} else {
#if DEBUG
			[NSException raise:NSInternalInconsistencyException format:@"Last check Id must not be lower then currently stored value."];
#endif
		}
	});
	
}

-(void)loop {
	
	while (self.isRunning) {
		
		dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
		
		[self.api retrieveStatusUpdateWithLastId:self.lastCheckId completion:^(FHCSystemStatus *status) {
			NSLog(@"STATUS: %@", status);
			NSLog(@"CHANGES: %@", status.changes);
			
			self.lastCheckId = status.identifier;
			
			dispatch_semaphore_signal(semaphore);
		} andFailure:^(NSError *error) {
			NSLog(@"ERROR: %@", error);
			
			dispatch_semaphore_signal(semaphore);
		}];
		
		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
	}
}

#pragma mark - public methods

-(void)start {
	self.isRunning = YES;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		[self loop];
	});
}

-(void)stop {
	self.isRunning = NO;
}

@end
