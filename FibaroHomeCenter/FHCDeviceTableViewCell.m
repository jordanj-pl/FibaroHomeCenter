//
//  FHCDeviceTableViewCell.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 15.10.2015.
//  Copyright © 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCDeviceTableViewCell.h"

@interface FHCDeviceTableViewCell ()

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *activityIndicatorLeftMarginConstraint;

@end

@implementation FHCDeviceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)changeLayoutActiveWithAnimation:(BOOL)animation {
	NSLog(@"::>> changeLayoutActive");
	self.nameLabel.textColor = [UIColor blackColor];
	[self.activityIndicator stopAnimating];
	
	self.activityIndicatorLeftMarginConstraint.constant = -28.0f;
	[self.contentView setNeedsUpdateConstraints];

	if(animation) {
		[UIView animateWithDuration:0.5 animations:^{
			[self.contentView layoutIfNeeded];
		}];		
	}
}

-(void)changeLayoutLockedWithAnimation:(BOOL)animation {
	NSLog(@"::>> changeLayoutLocked");
	self.nameLabel.textColor = [UIColor lightGrayColor];
	[self.activityIndicator startAnimating];
	
	self.activityIndicatorLeftMarginConstraint.constant = 8.0f;
	[self.contentView setNeedsUpdateConstraints];

	if(animation) {
		[UIView animateWithDuration:0.5 animations:^{
			[self.contentView layoutIfNeeded];
		}];
	}
}

-(void)prepareForReuse {
	self.nameLabel.textColor = [UIColor blackColor];
	self.activityIndicatorLeftMarginConstraint.constant = -28.0f;
}

@end
