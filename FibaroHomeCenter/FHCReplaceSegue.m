//
//  FHCReplaceSegue.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 09.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCReplaceSegue.h"

@implementation FHCReplaceSegue

- (void)perform {

    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;
    UIViewController *container = source.parentViewController;
    
    [container addChildViewController:destination];
    destination.view.frame = source.view.frame;
    [source willMoveToParentViewController:nil];
    
    [container transitionFromViewController:source
                           toViewController:destination
                                   duration:0.5
                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                 animations:^{
                                 }
                                 completion:^(BOOL finished) {
                                     [source removeFromParentViewController];
                                     [destination didMoveToParentViewController:container];
                                 }];
}

@end
