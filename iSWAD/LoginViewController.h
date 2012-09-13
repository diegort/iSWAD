//
//  LoginViewController.h
//  iSWAD
//
//  Created by Diego Montesinos on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    UITextField *txtUser;
    UITextField *txtPass;
}

@property (nonatomic, retain) IBOutlet UITextField *txtUser;

@property (nonatomic, retain) IBOutlet UITextField *txtPass;


- (IBAction)TextFielDidBeginEditing:(UITextField *)textField;

- (IBAction)TextFieldDidEndEditing:(UITextField *)textField;

- (IBAction)btnSave_Click:(id)sender;

@end
