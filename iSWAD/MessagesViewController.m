//
//  MessagesViewController.m
//  iSWAD
//
//  Created by Diego Montesinos on 14/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MessagesViewController.h"
#import "UIView+FormScroll.h"
#import "swad.h"
#import "User.h"
#import "sendMessageOutput.h"
#import "Login.h"

bool showError, showLoginError;

@implementation MessagesViewController
@synthesize txtMessage;
@synthesize txtTo;
@synthesize txtSubject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationController.navigationBarHidden = YES;
        
        UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send",nil) style:UIBarButtonItemStyleDone target:self action:@selector(send)];
        float r,g,b;
        r = 153./255;
        g = 204./255;
        b = 102./255;
        rigthBtn.tintColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
        self.navigationItem.rightBarButtonItem = rigthBtn;
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        return NO;
    } else {
        // Not found, so remove keyboard.
        
        //[textField resignFirstResponder];
        return YES;
    }
     // We do not want UITextField to insert line-breaks.
}

- (void) setSubject:(NSString *) subject messageCode:(int)code{
    _messageCode = code;
    NSString *tmp = [@"RE:" stringByAppendingString:subject];
    _subject = tmp;
    [tmp retain];
}

- (bool) checkReceivers:(NSString*) receivers{
    return YES;
}

-(void) sendMessage{
    swad* service = [swad service];
    NSString *subject = txtSubject.text;
    NSString *receivers = txtTo.text;
    NSString *body = txtMessage.text;
    
    //Check receivers
    if (![self checkReceivers:receivers]){
    }else{
        showError = YES;
        UIApplication* app = [UIApplication sharedApplication];
        //to show it, set it to YES
        app.networkActivityIndicatorVisible = YES;
        [service sendMessage:self action:@selector(sendMessageHandler:) wsKey:User.wsKey messageCode:_messageCode to:receivers subject:subject body:body];
    }
}

-(void) send{
    [txtMessage resignFirstResponder];
    
    //[activityIndicatorView startAnimating];
    NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    //time_t time = (time_t) [now timeIntervalSince1970];
    int timeDif = [now timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[User loginTime]]];
    if (![User loged] || timeDif > 3600) {
        showLoginError = YES;
        [Login loginTarget:self action:@selector(loginHandler:)];
    } else {
        [self sendMessage];
    }
}

- (void) sendMessageHandler: (id) value {   
    UIApplication* app = [UIApplication sharedApplication];
	//to show it, set it to YES
	app.networkActivityIndicatorVisible = NO;
    
	if((showError)&&([value isKindOfClass:[NSError class]])) { // Handle errors
		//NSLog(@"%@", value);
        //NSError *err = (NSError *) value;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
                              message: NSLocalizedString(@"noConnectionAlertMessage", nil)
                              delegate: nil
                              cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        showError = NO;
        
	} else if([value isKindOfClass:[SoapFault class]]) { // Handle faults
        SoapFault *err = (SoapFault *) value;
        
        if ([[err faultString] hasPrefix:@"Bad l"]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"loginErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"loginErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
	} else if ([value isKindOfClass:[sendMessageOutput class]]){ //All is OK
        
        //[self.navigationController popViewControllerAnimated:YES];
        sendMessageOutput *tmp = (sendMessageOutput *)value;
        NSMutableString *msg = [[NSMutableString alloc] initWithString:@""];
        
        for (user *u in tmp.users){
            [msg appendString:[[[[[u.userFirstname stringByAppendingString: @" "] stringByAppendingString: u.userSurname1] stringByAppendingString: @" ("] stringByAppendingString: u.userNickname] stringByAppendingString: @")\n"]];
        }
        UIAlertView *alert = [[UIAlertView alloc]
                              /*initWithTitle: NSLocalizedString(@"loginErrorAlertTitle", nil)
                              message: NSLocalizedString(@"loginErrorAlertMessage", nil)*/
                              initWithTitle: NSLocalizedString(@"sentMessageAlertTitle", nil)
                              message: msg
                              delegate: nil
                              cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        //usersArray *uA = (usersArray *)value;
        txtTo.text = @"";
        txtSubject.text = @"";
        txtMessage.text = @"";
        
    }
    [self.view scrollToY:0];
}

- (void) loginHandler: (id) value { 
    UIApplication* app = [UIApplication sharedApplication];
	if(showLoginError){
        showLoginError = NO;
        if ([value isKindOfClass:[NSError class]]) { // Handle errors
            //NSLog(@"%@", value);
            //NSError *err = (NSError *) value;
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
                                  message: NSLocalizedString(@"noConnectionAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            app.networkActivityIndicatorVisible = NO;
        } else if([value isKindOfClass:[SoapFault class]]) { // Handle faults
            SoapFault *err = (SoapFault *) value;
            
            if ([[err faultString] hasPrefix:@"Bad l"]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: NSLocalizedString(@"loginErrorAlertTitle", nil)
                                      message: NSLocalizedString(@"loginErrorAlertMessage", nil)
                                      delegate: nil
                                      cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                app.networkActivityIndicatorVisible = NO;
            }
        } else if ([value isKindOfClass:[loginByUserPasswordKeyOutput class]]){ //All went OK
            loginByUserPasswordKeyOutput* tmp = (loginByUserPasswordKeyOutput*)value;
            NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
            [User initWithLoginOutput:tmp time:[now timeIntervalSince1970]];
            
            [self sendMessage];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    txtSubject.text = _subject;
}

- (void)viewDidUnload
{
    [self setTxtMessage:nil];
    [self setTxtTo:nil];
    [self setTxtSubject:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations 
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    //return YES;
}

- (IBAction)txtEditingDidBegin:(UITextField *)sender {
    [self.view scrollToView:sender];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view scrollToY:(-1 * textView.frame.origin.y + 5)];
}

- (void)dealloc {
    [txtMessage release];
    [txtTo release];
    [txtSubject release];
    [super dealloc];
}
@end
