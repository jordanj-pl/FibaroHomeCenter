//
//  FHCHomeCenterViewController.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 06.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCHomeCenterViewController.h"

#import "FHCApi.h"
#import "FHCHomeCenter.h"

#import "FHCHomeSectionsTableViewController.h"

@interface FHCHomeCenterViewController ()

@property (nonatomic, weak) IBOutlet UILabel *connectionNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *macLabel;
@property (nonatomic, weak) IBOutlet UILabel *snLabel;
@property (nonatomic, weak) IBOutlet UILabel *svLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *deviceDetailsHeight;

@property (nonatomic, weak) IBOutlet UIView *embeddedView;

@property (nonatomic, weak) FHCHomeSectionsTableViewController *sectionsViewController;
@property (nonatomic, strong) FHCHomeCenter *homeCenter;

@end

@implementation FHCHomeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     NSLog(@"Connect to: %@", self.api);

    self.connectionNameLabel.text = self.api.connectionName;

     [self.api retrieveHCInfoWithSuccess:^(FHCHomeCenter *device) {
         self.homeCenter = device;

         dispatch_async(dispatch_get_main_queue(), ^{
             self.macLabel.text = self.homeCenter.mac;
             self.snLabel.text = self.homeCenter.serialNumber;
             self.svLabel.text = self.homeCenter.softwareVersion;
         });

         [self.sectionsViewController updateDevices];
         
     } andFailure:^(NSError *error) {
         NSLog(@"ERROR: %@", error);
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*)viewControllers {
	if(!_viewControllers) {
		_viewControllers = [NSMutableArray array];
	}
	
	return _viewControllers;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"sectionsViewControllerEmbedSegue"]) {
        self.sectionsViewController = segue.destinationViewController;
        self.sectionsViewController.api = self.api;

		[self.viewControllers addObject:self.sectionsViewController];
    }
}

-(IBAction)toggleDeviceInfo:(id)sender {
    if (self.deviceDetailsHeight.constant == 0.0f) {
        self.deviceDetailsHeight.constant = 100.0f;
    } else {
        self.deviceDetailsHeight.constant = 0.0f;
    }
    
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(IBAction)close:(id)sender {
	NSLog(@"VIEW CONTROLLERS: %@", self.viewControllers);
	
	if(self.viewControllers.count > 1) {
		UIViewController *previousVC = [self.viewControllers lastObject];
		UIViewController *newVC = self.viewControllers[self.viewControllers.count-2];
		
		newVC.view.frame = previousVC.view.frame;
		
		[previousVC willMoveToParentViewController:nil];
		[self addChildViewController:newVC];
		
		[self transitionFromViewController:previousVC
						  toViewController:newVC
								  duration:0.5
								   options:UIViewAnimationOptionTransitionCrossDissolve
								animations:nil
								completion:^(BOOL finished) {
									[previousVC removeFromParentViewController];
									[newVC didMoveToParentViewController:self];
									
									[self.viewControllers removeLastObject];
								}];
	} else {
		[self.presentingViewController dismissViewControllerAnimated:YES completion:^{
			[self.viewControllers removeAllObjects];
		}];
	}
}

@end
