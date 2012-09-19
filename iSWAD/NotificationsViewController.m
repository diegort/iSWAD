//
//  NotificationsViewController.m
//  iSWAD
//
//  Created by Diego Montesinos on 01/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationDetailViewController.h"
#import "NotificationCell.h"
/*#import "swad.h"
#import "loginByUPOut.h"
#import "getNotificationsOutput.h"
#import "User.h"
#import "Login.h"*/
#import "WebCommunication.h"
#import "Literals.h"

/*#define TITLELABEL_TAG  2
#define DETAILTEXT_TAG  3
#define IMGTYPE_TAG     0
#define IMGACTION_TAG   1*/

#define COMMENT_LABEL_WIDTH			240
#define COMMENT_LABEL_MIN_HEIGHT	50
#define CELL_PADDING				2

#define NOTIFICATION_CELL_HEIGHT	130

BOOL showLoginError;
BOOL showError;

@implementation NotificationsViewController
@synthesize tvCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        myDB = [[DBManager alloc] init];
        notifications = [myDB getNotifications];
        [notifications retain];
          
        if(notifications.count == 0){
            noNotif = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            UITextView *myLabel2 = [[UITextView alloc] initWithFrame:noNotif.frame];
            myLabel2.text = NSLocalizedString(@"noNotifications", nil);
            myLabel2.textAlignment = UITextAlignmentLeft;
            myLabel2.font = [UIFont fontWithName:@"Helvetica" size:30];
            myLabel2.userInteractionEnabled = NO;
            
            [noNotif addSubview:myLabel2];
            [myLabel2 release];
            [self.view addSubview:noNotif];
            self.tableView.bounces = NO;
        }
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:Common object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationsDone:) name:Common object:nil];
		
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationsDone object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationsDone:) name:NotificationsDone object:nil];
		
        app = [UIApplication sharedApplication];
		
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
		[activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		activityIndicatorView.alpha = 0.7;
		activityIndicatorView.backgroundColor = [UIColor lightGrayColor];
		activityIndicatorView.center = CGPointMake(160, 180);
		//activityIndicatorView.center = self.view.center;
		activityIndicatorView.hidesWhenStopped = YES;
		activityIndicatorView.layer.cornerRadius = 10.0;		
		activityIndicatorView.layer.masksToBounds = YES;
		
		[self.view addSubview:activityIndicatorView];
    }

    return self;
}

-(void) updateNotificationsDone: (NSNotification *) value{
    app.networkActivityIndicatorVisible = NO;
	[activityIndicatorView stopAnimating];
	
    NSNumber* result = [value object];
	switch ([result intValue]) {
		case OK:
			[notifications release];
			notifications = nil;
			notifications = [myDB getNotifications];
			[notifications retain];
			
			if (notifications.count > 0) {
				if(noNotif){
					[noNotif removeFromSuperview];
					self.tableView.bounces = YES;
				}
			}
			
			[self.tableView reloadData];
			break;
		case SoapError:
		{
			UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"getNotificationsErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"getNotificationsErrorAlertMessage", nil)
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
			
		case DBError:
		{
			UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"getNotificationsDBErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"getNotificationsDBErrorAlertMessage", nil)
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

-(void) reloadNotifications{
    app.networkActivityIndicatorVisible = YES;
    
    [activityIndicatorView startAnimating];
	
    WebCommunication *myWB = [[WebCommunication alloc] init];
    [myWB updateNotifications];
	[myWB release];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //cellLoader = [[UINib nibWithNibName:@"NotificationCell" bundle:[NSBundle mainBundle]] retain];
        
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Refresh",nil) style:UIBarButtonItemStyleDone target:self action:@selector(reloadNotifications)];
    /*float r,g,b;
     r = 153./255;
     g = 204./255;
     b = 102./255;
     rigthBtn.tintColor = [UIColor colorWithRed:r green:g blue:b alpha:1];*/
    self.navigationItem.rightBarButtonItem = rigthBtn;
	[rigthBtn release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

//This just a convenience function to get the height of the label based on the comment text
-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    //NotificationCell *cell = [[NotificationCell alloc] init];
    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, 10000);
    NSString *tmp = ((notification *)[notifications objectAtIndex:index]).content;
    //UIFont *font = [UIFont fontWithName:@"System" size:17.0f];
    //UIFont *font = cell.detailText.font;
    CGSize labelHeighSize = [tmp sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0f]  constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
    //CGSize labelHeighSize = [tmp sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0f] forWidth:COMMENT_LABEL_WIDTH lineBreakMode:UILineBreakModeWordWrap];
    return labelHeighSize.height;
    
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    //return @"iSWAD";
    //return NSLocalizedString(@"Notifications", nil);
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return notifications.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*if(selectedIndex == indexPath.row)
    {
        CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];
        return NOTIFICATION_CELL_HEIGHT + labelHeight + CELL_PADDING * 2;
    }
    else {
        return NOTIFICATION_CELL_HEIGHT + CELL_PADDING * 2;
    }*/
    return NOTIFICATION_CELL_HEIGHT + CELL_PADDING * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationCell";
    
    NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[NotificationCell description] owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (NotificationCell *)currentObject;
                break;
            }
        }   
        
    }
    
       notification *notif = [notifications objectAtIndex:indexPath.row];
    
    [cell setData:notif selected:(selectedIndex == indexPath.row)];
    return cell;
}


-(NSString *) cleanNotificationContent:(NSString *) content{
    NSString *aux;
    aux = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    
    if ([aux    hasPrefix:@"<![CDATA["]){
        aux = [content substringFromIndex:9];
        aux = [aux substringToIndex:aux.length - 3];
    }
	//[aux retain];
    return aux;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationCell *cell;
    cell = (NotificationCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [cell userTouched];
    
    NotificationDetailViewController *notif = [[NotificationDetailViewController alloc] initWithNibName:[NotificationDetailViewController description] bundle:nil];
    notification *tmp = [notifications objectAtIndex:indexPath.row];
    //lg.title = [[tableView cellForRowAtIndexPath:indexPath].textLabel text];
    NSString *text = [self cleanNotificationContent:tmp.content];
    notif.Code = tmp.notificationCode;
    notif.Type = tmp.eventType;
    notif.Subject = tmp.summary;
    [self.navigationController pushViewController:notif animated:YES];
    [notif.wvDetails loadHTMLString:text baseURL:nil];
    [notif release];
}

- (void)dealloc {
    [super dealloc];
}
@end
