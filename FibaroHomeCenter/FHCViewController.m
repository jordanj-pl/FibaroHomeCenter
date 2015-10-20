//
//  FHCViewController.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 30.09.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCViewController.h"
#import "FHCDevicesStore.h"
#import "FHCNewConnectionViewController.h"
#import "FHCHomeCenterViewController.h"
#import "FHCConnectionData.h"

#import "FHCApi.h"
#import "FHCApiStatusMonitor.h"

@interface FHCViewController ()

@property (nonatomic, strong) FHCApi *api;
@property (nonatomic, strong) FHCApiStatusMonitor *apiStatusMonitor;

@end

@implementation FHCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"newConnectionSegue"]) {
        FHCNewConnectionViewController *ncvc = segue.destinationViewController;
        ncvc.completionHandler = ^(FHCConnectionData *cd) {
            FHCDevicesStore *ds = [FHCDevicesStore sharedStore];
            [ds addDeviceWithConnectionData:cd];
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:[ds.deviceList count]-1 inSection:0];
            
            [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationBottom];

            self.api = [FHCApi apiForConnection:cd];
			
			if(self.apiStatusMonitor) {
				[self.apiStatusMonitor stop];
			}
			
			self.apiStatusMonitor = [[FHCApiStatusMonitor alloc] initWithApi:self.api];
			[self.apiStatusMonitor start];

            [self performSegueWithIdentifier:@"deviceManagementSegue" sender:self];
        };
    } else if([segue.identifier isEqualToString:@"connectionSegue"]) {
        UITableViewCell *callingCell = sender;
        NSIndexPath *ip = [self.tableView indexPathForCell:callingCell];
        FHCDevicesStore *ds = [FHCDevicesStore sharedStore];
        
        FHCNewConnectionViewController *ncvc = segue.destinationViewController;
        
        ncvc.connectionData = [ds.deviceList objectAtIndex:ip.row];
        
        ncvc.completionHandler = ^(FHCConnectionData *cd) {
            
            self.api = [FHCApi apiForConnection:cd];
			
			if(self.apiStatusMonitor) {
				[self.apiStatusMonitor stop];
			}
			
			self.apiStatusMonitor = [[FHCApiStatusMonitor alloc] initWithApi:self.api];
			[self.apiStatusMonitor start];
			
            [self performSegueWithIdentifier:@"deviceManagementSegue" sender:self];
        };
    } else if([segue.identifier isEqualToString:@"deviceManagementSegue"]) {
        FHCHomeCenterViewController *dvc = segue.destinationViewController;
        dvc.api = self.api;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FHCDevicesStore *ds = [FHCDevicesStore sharedStore];
    return [ds.deviceList count]+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    FHCDevicesStore *ds = [FHCDevicesStore sharedStore];
    
    if(indexPath.row == [ds.deviceList count]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"newConnectionCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
        
        FHCConnectionData *cd = [ds.deviceList objectAtIndex:indexPath.row];
        cell.textLabel.text = cd.friendlyName;
        cell.detailTextLabel.text = cd.url.absoluteString;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *devices = [[FHCDevicesStore sharedStore] deviceList];
        FHCConnectionData *device = devices[indexPath.row];
        [[FHCDevicesStore sharedStore] removeDeviceWithConnectionData:device];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    FHCDevicesStore *ds = [FHCDevicesStore sharedStore];

    if(indexPath.row == [ds.deviceList count]) {
        return NO;
    }
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
