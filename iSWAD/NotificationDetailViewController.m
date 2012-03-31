//
//  NotificationDetailViewController.m
//  iSWAD
//
//  Created by Diego Montesinos on 10/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import "MessagesViewController.h"

@implementation NotificationDetailViewController
@synthesize wvDetails;
@synthesize Code;
@synthesize Type;
@synthesize Subject;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) answerMessage{
    MessagesViewController *msg = [[MessagesViewController alloc] initWithNibName:@"MessagesViewController" bundle:nil];
    
    //lg.title = @"Login";
    [msg setSubject:Subject messageCode:Code];
    //self.navigationController.navigationBarHidden = YES;
    //self.navigationController.toolbarHidden = YES;
    [self.navigationController pushViewController:msg animated:YES];
    [msg release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([Type isEqualToString:@"message"]) {
        UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc] initWithTitle:@"Responder" style:UIBarButtonItemStyleDone target:self action:@selector(answerMessage)];
    /*float r,g,b;
     r = 153./255;
     g = 204./255;
     b = 102./255;
     rigthBtn.tintColor = [UIColor colorWithRed:r green:g blue:b alpha:1];*/
        self.navigationItem.rightBarButtonItem = rigthBtn;
    }
}

- (void)viewDidUnload
{
    [self setWvDetails:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [wvDetails release];
    [super dealloc];
}
@end
