//
//  LoginViewController.m
//  iSWAD
//
//  Created by Diego Montesinos on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define kOFFSET_FOR_KEYBOARD 60.0

#import "LoginViewController.h"
#import "UIView+FormScroll.h"
#import "Literals.h"

UITextField * activeField;


@implementation LoginViewController
@synthesize txtUser;
@synthesize txtPass;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        //[txtUser resignFirstResponder];
        //[txtPass resignFirstResponder];
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    txtUser.text = [[NSUserDefaults standardUserDefaults] stringForKey:UserKey];
    txtPass.text = [[NSUserDefaults standardUserDefaults] stringForKey:PassKey];
    //[self registerForKeyboardNotifications];
}

- (void)viewDidUnload
{
    [self setTxtUser:nil];
    [self setTxtPass:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    /*return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);*/
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc {
    [txtUser release];
    [txtPass release];
    [super dealloc];
}

- (IBAction)TextFielDidBeginEditing:(UITextField *)textField
{
    //activeField = textField;
    //[textField scrollToView:self.view];
}

- (IBAction)TextFieldDidEndEditing:(UITextField *)textField
{
    //activeField = nil;
    [textField resignFirstResponder];
    //[textField scrollToY:0];
}


- (IBAction)btnSave_Click:(id)sender {
    //[txtUser resignFirstResponder];
    [txtPass resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setValue:txtUser.text forKey:UserKey];
    [[NSUserDefaults standardUserDefaults] setValue:txtPass.text forKey:PassKey];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.65];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];
}
@end
