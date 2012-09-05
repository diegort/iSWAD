//
//  NoticesViewController.m
//  iSWAD
//
//  Created by Diego Montesinos on 22/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoticesViewController.h"
#import "UIView+FormScroll.h"
#import "WebCommunication.h"

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
        rigthBtn.tintColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
        self.navigationItem.rightBarButtonItem = rigthBtn;
        
        app = [UIApplication sharedApplication];
		
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noticePosted" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendNoticeDone) name:@"noticePosted" object:nil];
		
		_courseCode = -1;
    }
    return self;
}

-(void) sendNoticeDone {
    app.networkActivityIndicatorVisible = NO;
    
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
        
		WebCommunication *myWB = [[WebCommunication alloc] init];
		[myWB sendNotice:body courseCode:_courseCode];
		[self.view scrollToY:0];
		
		[txtMessage resignFirstResponder];	
	}
}

- (void) courseSelectoCallback{
	_courseCode = [cs getSelectedCode];
	_courseName = [cs getSelectedName];
	
	txtCourse.text = _courseName;
	
	[txtMessage becomeFirstResponder];
	txtCourse.userInteractionEnabled = YES;
}

- (IBAction)txtEditingDidBegin:(UITextField *)sender {
    //[self.view scrollToView:sender];
	sender.userInteractionEnabled = NO;
	[sender resignFirstResponder];
	cs = [[CourseSelector alloc] initWithTarget:self selector:@selector(courseSelectoCallback)];
	
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

@end
