//
//  FHCHomeSectionsTableViewController.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 07.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCHomeSectionsTableViewController.h"

#import "FHCApi.h"
#import "FHCHomeCenter.h"
#import "FHCSection.h"
#import "FHCRoom.h"

#import "FHCHomeCenterViewController.h"
#import "FHCRoomTableViewController.h"

@interface FHCHomeSectionsTableViewController ()

@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation FHCHomeSectionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)updateDevices {
    NSLog(@"update devices");
    
    [self.api updateDevicesForHomeCenter:nil withSuccess:^{
        NSLog(@"SECTIONS: %@", self.api.currentHomeCenter.sections);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } andFailure:^(NSError *error) {
        NSLog(@"FAILURE: %@", error);
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.api.currentHomeCenter.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FHCSection *sectionObj = self.api.currentHomeCenter.sections[section];
    return [sectionObj.rooms count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewRoomCell" forIndexPath:indexPath];

    FHCSection *sectionObj = self.api.currentHomeCenter.sections[indexPath.section];
    FHCRoom *roomObj = sectionObj.rooms[indexPath.row];
    
    UILabel *labelView = (UILabel*)[cell viewWithTag:990001];
    labelView.text = roomObj.name;

    UILabel *labelCountView = (UILabel*)[cell viewWithTag:990002];
    labelCountView.text = [NSString stringWithFormat:@"%lu", [roomObj.devices count]];

    return cell;
}

#pragma mark - Table view delegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"sectionHeader"];
    
    FHCSection *sectionObj = self.api.currentHomeCenter.sections[section];
    
    UILabel *labelView = (UILabel*)[headerView viewWithTag:990001];
    labelView.text = sectionObj.name;
    
    return headerView;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if([self.parentViewController isKindOfClass:[FHCHomeCenterViewController class]]) {
		[((FHCHomeCenterViewController*)self.parentViewController).viewControllers addObject:segue.destinationViewController];
	}
	
    if([segue.identifier isEqualToString:@"showDevicesSegue"]) {
		UITableViewCell *callingCell = sender;
		NSIndexPath *ip = [self.tableView indexPathForCell:callingCell];
		[self.tableView deselectRowAtIndexPath:ip animated:YES];

		FHCRoomTableViewController *dvc = segue.destinationViewController;
		dvc.api = self.api;
		
		FHCSection *section = [self.api.currentHomeCenter.sections objectAtIndex:ip.section];
		FHCRoom *room = [section.rooms objectAtIndex:ip.row];
		
		dvc.selectedRoom = room;
    }
}


@end
