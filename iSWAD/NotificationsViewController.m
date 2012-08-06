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
#import "swad.h"
#import "loginByUPOut.h"
#import "getNotificationsOutput.h"
#import "User.h"
#import "Login.h"
#import "WebCommunication.h"

#define TITLELABEL_TAG  2
#define DETAILTEXT_TAG  3
#define IMGTYPE_TAG     0
#define IMGACTION_TAG   1

#define COMMENT_LABEL_WIDTH 240
#define COMMENT_LABEL_MIN_HEIGHT 50
#define CELL_PADDING 2

#define NOTIFICATION_CELL_HEIGHT 130

BOOL showLoginError;
BOOL showError;

@implementation NotificationsViewController
@synthesize tvCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedIndex = -1;
        
        myDB = [[DBManager alloc] init];
        notifications = [myDB getNotifications];
        [notifications retain];
        
        /*activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
         
         activityIndicatorView.center = CGPointMake(160, 180);
         activityIndicatorView.hidesWhenStopped = YES;
         
         [self.view addSubview:activityIndicatorView];*/
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationsDone) name:@"updateNotificationsDone" object:nil];
        
        app = [UIApplication sharedApplication];
    }

    return self;
}

-(void) updateNotificationsDone{
    app.networkActivityIndicatorVisible = NO;
    
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
}

-(void) reloadNotifications{
    app.networkActivityIndicatorVisible = YES;
    
    WebCommunication *myWB = [[WebCommunication alloc] init];
    [myWB updateNotifications];
}

/*- (void) notificationsHandler: (id) value { 
    
	if(showError){
        showError = NO;
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
        } else if([value isKindOfClass:[SoapFault class]]) { // Handle faults
            SoapFault *err = (SoapFault *) value;
            
            if ([[err faultString] hasPrefix:@"Bad l"]) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: NSLocalizedString(@"getNotificationsErrorAlertTitle", nil)
                                      message: NSLocalizedString(@"getNotificationsErrorAlertMessage", nil)
                                      delegate: nil
                                      cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        } else if ([value isKindOfClass:[getNotificationsOutput class]]){ //All went OK
            getNotificationsOutput* tmp = (getNotificationsOutput*)value;
            if ([myDB saveNotifications:tmp.notifications.items]){
                
                //currentTime = ((notification*)[notifications objectAtIndex:0]).eventTime;
                NSNumber *temp = [NSNumber numberWithLong:currentTime];
                [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"notificationsUpdateTime"];

                if(noNotif){
                    [noNotif removeFromSuperview];
                    self.tableView.bounces = YES;
                }
                
                [notifications release];
                notifications = nil;
                notifications = [myDB getNotifications];
                [notifications retain];
                [self.tableView reloadData];
            }else{
                //Error
            }
            
        }
        app.networkActivityIndicatorVisible = NO;
        
        //[activityIndicatorView stopAnimating];
    }
}

- (void) loginHandler: (id) value { 
    
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
            
            [self getNotifications];
        }
    }
}*/

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
    /*static NSString *MyIdentifier = @"NotificationCell";
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
        cell = (NotificationCell *)tvCell;
        self.tvCell = nil;
    }*/
    
    static NSString *CellIdentifier = @"NotificationCell";
    
    NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (NotificationCell *)currentObject;
                break;
            }
        }   
        
    }
    
    //If this is the selected index then calculate the height of the cell based on the amount of text we have
    /*if(selectedIndex == indexPath.row){
        CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];
        labelHeight = MAX(labelHeight, COMMENT_LABEL_MIN_HEIGHT);
        cell.detailText.frame = CGRectMake(cell.detailText.frame.origin.x, 
                                                 cell.detailText.frame.origin.y, 
                                                 cell.detailText.frame.size.width, 
                                                 labelHeight);
        
        cell.frame = CGRectMake(cell.frame.origin.x, 
                                cell.frame.origin.y, 
                                cell.frame.size.width, 
                                NOTIFICATION_CELL_HEIGHT + labelHeight);
    }
    else {
        //Otherwise just return the minimum height for the label.
        cell.detailText.frame = CGRectMake(cell.detailText.frame.origin.x, 
                                                 cell.detailText.frame.origin.y, 
                                                 cell.detailText.frame.size.width, 
                                                 COMMENT_LABEL_MIN_HEIGHT);
        cell.frame = CGRectMake(cell.frame.origin.x, 
                                cell.frame.origin.y, 
                                cell.frame.size.width, 
                                130);
    }*/
    
    //cell.detailText.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    //cell.commentTextLabel.text = [textArray objectAtIndex:indexPath.row];
    notification *notif = [notifications objectAtIndex:indexPath.row];
    
    [cell setData:notif selected:(selectedIndex == indexPath.row)];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(NSString *) cleanNotificationContent:(NSString *) content{
    NSString *aux;
    aux = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    
    if ([aux    hasPrefix:@"<![CDATA["]){
        aux = [content substringFromIndex:9];
        aux = [aux substringToIndex:aux.length - 3];
    }
    return aux;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
    */
    
    //The user is selecting the cell which is currently expanded
    //we want to minimize it back
    
    /*if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }*/
    NotificationCell *cell;
    cell = (NotificationCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [cell userTouched];
    
    NotificationDetailViewController *notif = [[NotificationDetailViewController alloc] initWithNibName:@"NotificationDetailViewController" bundle:nil];
    notification *tmp = [notifications objectAtIndex:indexPath.row];
    //lg.title = [[tableView cellForRowAtIndexPath:indexPath].textLabel text];
    NSString *text = [self cleanNotificationContent:tmp.content];
    notif.Code = tmp.notificationCode;
    notif.Type = tmp.eventType;
    notif.Subject = tmp.summary;
    [self.navigationController pushViewController:notif animated:YES];
    [notif.wvDetails loadHTMLString:text baseURL:nil];
    [notif release];
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    /*if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        
        cell = (NotificationCell *)[self.tableView cellForRowAtIndexPath:previousPath];
        cell.selected = NO;
        [cell userTouched];
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];        
    }
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     */
}

- (void)dealloc {
    [super dealloc];
}
@end
