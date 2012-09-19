//
//  NoticesViewController.m
//  iSWAD
//
//  Created by Diego Montesinos on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoticesViewController.h"
#import "UIView+FormScroll.h"
#import "Literals.h"

@implementation NoticesViewController
@synthesize txtCourse;
@synthesize txtMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send",nil) style:UIBarButtonItemStyleDone target:self action:@selector(sendNotice)];
        float r,g,b;
        r = 153./255;
        g = 204./255;
        b = 102./255;
		if ([rigthBtn respondsToSelector:@selector(setTintColor:)])
			rigthBtn.tintColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
		
        self.navigationItem.rightBarButtonItem = rigthBtn;
		[rigthBtn release];
		
		app = [UIApplication sharedApplication];
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
		
		_courseCode = -1;
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:Common object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendNoticeDone:) name:Common object:nil];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NoticePosted object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendNoticeDone:) name:NoticePosted object:nil];
		
		cs = [[CourseSelector alloc] initWithTarget:self selector:@selector(courseSelectorCallback:)];
		myWB = [[WebCommunication alloc] init];
    }
	
    return self;
}

-(void) sendNoticeDone:(NSNotification *)notif {
    app.networkActivityIndicatorVisible = NO;
    [activityIndicatorView stopAnimating];
	NSNumber * res = [notif object];
	
	switch ([res intValue]) {
		case OK:
		{
			NSString *msg = [NSLocalizedString(@"sentNoticeAlertMessage", nil) stringByAppendingString:_courseName];
			
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: NSLocalizedString(@"sentNoticeAlertTitle", nil)
								  message: msg
								  delegate: nil
								  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			txtCourse.text = @"";
			txtMessage.text = @"";
		}
			break;
		case SoapError:
		{
			UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"sendNoticeErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"sendNoticeErrorAlertMessage", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
		}
			break;
		case ConnectivityError:
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

-(void) sendNotice{
    NSString *body = txtMessage.text;
	
	if ((_courseCode == -1) || ([body isEqualToString:@""])) {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: NSLocalizedString(@"sendNoticeConstraintAlertTitle", nil)
							  message: NSLocalizedString(@"sendNoticeConstraintAlertMessage", nil)
							  delegate: nil
							  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}else{

		app.networkActivityIndicatorVisible = YES;
        [activityIndicatorView startAnimating];
		
		[myWB sendNotice:body courseCode:_courseCode];
		[self.view scrollToY:0];
		
		[txtMessage resignFirstResponder];	
		[myWB release];
	}
}

- (void) courseSelectorCallback:(NSNumber*) status{
	txtCourse.userInteractionEnabled = YES;
	if([status intValue] == 0){
		_courseCode = [cs getSelectedCode];
		_courseName = [cs getSelectedName];
		txtCourse.text = _courseName;
	
		[txtMessage becomeFirstResponder];
	}

	
}

- (IBAction)txtEditingDidBegin:(UITextField *)sender {
    //[self.view scrollToView:sender];
	sender.userInteractionEnabled = NO;
	[sender resignFirstResponder];
	
	[cs showSelector:3];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view scrollToY:(-1 * textView.frame.origin.y + 5)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[cs release];
	[myWB release];
	[super dealloc];
}

@end
