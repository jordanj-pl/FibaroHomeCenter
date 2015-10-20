//
//  FHCNewConnectionViewController.m
//  FibaroHomeCenter
//
//  Created by Jordan Jasinski on 02.10.2015.
//  Copyright (c) 2015 Jordan Jasinski. All rights reserved.
//

#import "FHCNewConnectionViewController.h"
#import "FHCConnectionData.h"

@interface FHCNewConnectionViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *friendlyNameField;
@property (nonatomic, weak) IBOutlet UITextField *urlField;
@property (nonatomic, weak) IBOutlet UITextField *loginField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@end

@implementation FHCNewConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.connectionData) {
        self.friendlyNameField.text = self.connectionData.friendlyName;
        self.urlField.text = [self.connectionData.url absoluteString];
        self.loginField.text = self.connectionData.login;
        self.passwordField.text = self.connectionData.password;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)connect:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if(!self.connectionData) {
            FHCConnectionData *cd = [FHCConnectionData connectionDataForURL:[NSURL URLWithString:self.urlField.text] withLogin:self.loginField.text andPassword:self.passwordField.text];
            cd.friendlyName = self.friendlyNameField.text;
            self.completionHandler(cd);
        } else {
            self.connectionData.friendlyName = self.friendlyNameField.text;
            [self.connectionData updateDataWithURL:[NSURL URLWithString:self.urlField.text] andLogin:self.loginField.text];
            self.connectionData.password = self.passwordField.text;
            self.completionHandler(self.connectionData);
        }
    }];
}

-(IBAction)dismiss:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if(textField == self.friendlyNameField) {
        [self.urlField becomeFirstResponder];
    } else if(textField == self.urlField) {
        [self.loginField becomeFirstResponder];
    } else if(textField == self.loginField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField) {
        [self connect:textField];
    }

    return YES;
}

@end
