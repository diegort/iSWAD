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
#import "WebCommunication.h"
#import "Literals.h"

UIResponder *activeTextBox;

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
        
		UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send",nil) style:UIBarButtonItemStyleDone target:self action:@selector(sendMessage)];
        float r,g,b;
        r = 153./255;
        g = 204./255;
        b = 102./255;
		
		if ([rigthBtn respondsToSelector:@selector(setTintColor:)])
			rigthBtn.tintColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
		
        self.navigationItem.rightBarButtonItem = rigthBtn;
        [rigthBtn release];
        app = [UIApplication sharedApplication];
        
		[[NSNotificationCenter defaultCenter] removeObserver:self name:Common object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageDone:) name:Common object:nil];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MessageSent object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageDone:) name:MessageSent object:nil];
		
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
		[activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		activityIndicatorView.alpha = 0.7;
		activityIndicatorView.backgroundColor = [UIColor lightGrayColor];
		activityIndicatorView.center = CGPointMake(160, 180);
		//activityIndicatorView.center = self.view.center;
		activityIndicatorView.hidesWhenStopped = YES;
		activityIndicatorView.layer.cornerRadius = 10.0;		
		activityIndicatorView.layer.masksToBounds = YES;
		
		[self.view addSubview:activityIndicatorView];
		[activityIndicatorView release];
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
        activeTextBox = nextResponder;
        [nextResponder becomeFirstResponder];
        return NO;
    } else {
        // Not found, so remove keyboard.
        
        //[textField resignFirstResponder];
        return YES;
    }
	// We do not want UITextField to insert line-breaks.
}

-(void) sendMessageDone: (NSNotification *) notification{
    app.networkActivityIndicatorVisible = NO;
	[activityIndicatorView stopAnimating];
    
	
	if ([[notification object] isKindOfClass:[sendMessageOutput class]]) {
		sendMessageOutput *tmp = (sendMessageOutput *)[notification object] ;
		NSMutableString *msg = [[NSMutableString alloc] initWithString:@""];
		
		for (user *u in tmp.users){
			[msg appendString:[[[[[u.userFirstname stringByAppendingString: @" "] stringByAppendingString: u.userSurname1] stringByAppendingString: @" ("] stringByAppendingString: u.userNickname] stringByAppendingString: @")\n"]];
		}
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: NSLocalizedString(@"sentMessageAlertTitle",nil)
							  message: msg
							  delegate: nil
							  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		[msg release];
		
		//usersArray *uA = (usersArray *)value;
		txtTo.text = @"";
		txtSubject.text = @"";
		txtMessage.text = @"";
	}else{
		NSNumber * res = [notification object];
		
		switch ([res intValue]) {
			case -1:
			{
				UIAlertView *alert = [[UIAlertView alloc]
									  initWithTitle: NSLocalizedString(@"sendMessageErrorAlertTitle", nil)
									  message: NSLocalizedString(@"sendMessageErrorAlertMessage", nil)
									  delegate: nil
									  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
									  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
				break;
			case 400:
			{
				UIAlertView *alert = [[UIAlertView alloc]
									  initWithTitle: NSLocalizedString(@"noConnectionAlertTitle", nil)
									  message: NSLocalizedString(@"noConnectionAlertMessage", nil)
									  delegate: nil
									  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
									  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
				break;
			default:
				break;
		}
	}
    
}

- (void) setSubject:(NSString *) subject messageCode:(long)code{
    _messageCode = code;
    NSString *tmp = [@"RE:" stringByAppendingString:subject];
    _subject = tmp;
    [tmp retain];
}

- (bool) checkReceivers:(NSString*) receivers{
    NSArray *tmp = [receivers componentsSeparatedByString: @","];
	NSString *aux;
	for (int i=0; i<tmp.count; i++) {
		aux = [tmp objectAtIndex:i];
		if ((aux.length < 3) && (aux.length > 0)){
			return NO;
		}
	}
	return YES;
}

-(void) sendMessage{
    NSString *subject = txtSubject.text;
    NSString *receivers = txtTo.text;
    NSString *body = txtMessage.text;
    
	[txtTo resignFirstResponder];
	[txtSubject resignFirstResponder];
	[txtMessage resignFirstResponder];
	[self.view scrollToY:0];  
	
	if ((_messageCode == 0) && (receivers.length == 0)) {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: NSLocalizedString(@"noReceiversTitle", nil)
							  message: NSLocalizedString(@"noReceiversMessage", nil)
							  delegate: nil
							  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else{
		//Check receivers
		if (![self checkReceivers:receivers]){
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: NSLocalizedString(@"badReceiversTitle", nil)
								  message: NSLocalizedString(@"badReceiversMessage", nil)
								  delegate: nil
								  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}else{
			app.networkActivityIndicatorVisible = YES;
			[activityIndicatorView startAnimating];
			WebCommunication *myWB = [[WebCommunication alloc] init];
			[myWB sendMessage:body subject:subject to:receivers code:_messageCode];
			[myWB release];
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
