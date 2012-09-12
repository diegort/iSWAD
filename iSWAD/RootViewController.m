#import "RootViewController.h"
#import "iSWADAppDelegate.h"
#import "LoginViewController.h"
#import "MessagesViewController.h"
#import "AboutViewController.h"
#import "NotificationsViewController.h"
#import "NoticesViewController.h"
#import "ConfigureTestViewController.h"
#import "Literals.h"
#import "User.h"

#define NotificationsKey    @"Notifications"
#define NoticesKey			@"Notices"
#define TestsKey			@"Tests"

NSMutableArray *elementsList;

bool showError;

@implementation RootViewController

-(void) loadMenu{
    int userType = [[NSUserDefaults standardUserDefaults] integerForKey:UserTypeKey];
    if (userType > 2){
        elementsList = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         NotificationsKey,@"key",
                         @"notif.png",@"icon",
                         nil],
                        /*[NSDictionary dictionaryWithObjectsAndKeys:
                         TestsKey,@"key",
                         @"test.png",@"icon",
                         nil],*/
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         NoticesKey,@"key",
                         @"note.png",@"icon",
                         nil],
                        nil];
    }else{
        elementsList = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         NotificationsKey,@"key",
                         @"notif.png",@"icon",
                         nil],
                        /*[NSDictionary dictionaryWithObjectsAndKeys:
                         TestsKey,@"key",
                         @"test.png",@"icon",
                         nil],*/
                        nil];
    }
    [elementsList retain];
}

-(void) loadData{
    
    //[self loadMenu];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;
    
    /* Para poner imagen de usuario en el boton derecho*/
    /*UIView *logoView = [[UIView alloc] init];
     UIImageView *logoHolder = [[UIImageView alloc]init];
     UIImage *logoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loakelLogo" ofType:@"png"]];
     logoHolder.image = logoImage;
     [logoView addSubview:logoHolder];
     
     UIBarButtonItem *logoIcon = [[UIBarButtonItem alloc]initWithCustomView:logoView]; 
     self.navigationItem.rightBarButtonItem = logoIcon;
     */
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)                                                               style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = backBtn;
    [backBtn release];
    
    // Show toolbar
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] 
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                      target:nil 
                                      action:nil];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] 
                              initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
                              target:self 
                              action:@selector(newMessage)];
    
    // Initialize the UIButton
    UIImage *buttonImage = [UIImage imageNamed:@"info.png"];
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:buttonImage forState:UIControlStateNormal];
    aButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    
    // Initialize the UIBarButtonItem
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *items = [NSArray arrayWithObjects:item1, flexibleSpace, item2, nil];
    
    self.toolbarItems = items;
    
    [flexibleSpace release];
    [item1 release];
    [item2 release];
    
    double lastVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:AppVersionKEy];
    double currentVersion = [(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] doubleValue];
	NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:UserKey];
    
    [[NSUserDefaults standardUserDefaults] setDouble:currentVersion forKey:AppVersionKEy];
    
    if ((lastVersion == 0) || ([user isEqualToString:@""])){
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:NSLocalizedString(@"initAlertTitle", nil) 
                              message:NSLocalizedString(@"initAlertMessage", nil) 
                              delegate:self 
                              cancelButtonTitle:NSLocalizedString(@"No", nil) 
                              otherButtonTitles:NSLocalizedString(@"Yes", nil) , nil];
        [alert show];
        
        [alert release];
    }
    if (lastVersion < currentVersion){
        //mostrar novedades
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Show activiy indicator in system bar
    //app.networkActivityIndicatorVisible = YES;
    
    /*activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	activityIndicatorView.center = CGPointMake(160, 180);
	activityIndicatorView.hidesWhenStopped = YES;
    
    [self.view addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];  */
 
    //[self loadData];
	
	//app.networkActivityIndicatorVisible = NO;
    //[activityIndicatorView stopAnimating];
}

/*
 * Actions for buttons events
 */
-(void)login
{
    LoginViewController *lg = [[LoginViewController alloc] initWithNibName:[LoginViewController description] bundle:nil];
    //lg.title = @"Login";
    
    self.navigationController.navigationBarHidden = YES;
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.65];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    //self.navigationController.toolbarHidden = YES;
    [self.navigationController pushViewController:lg animated:YES];
    [UIView commitAnimations];
    [lg release];
}

-(void) about{
    AboutViewController *info = [[AboutViewController alloc] initWithNibName:[AboutViewController description] bundle:nil];
    //lg.title = @"Login";
    
    //self.navigationController.navigationBarHidden = YES;
    //self.navigationController.toolbarHidden = YES;
    [self.navigationController pushViewController:info animated:YES];
    [info release];
}

-(void) newMessage{
    MessagesViewController *msg = [[MessagesViewController alloc] initWithNibName:[MessagesViewController description] bundle:nil];

    [self.navigationController pushViewController:msg animated:YES];
    [msg release];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *rigthBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil) style:0 target:self action:@selector(login)];
    self.navigationItem.rightBarButtonItem = rigthBtn;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    
	[rigthBtn release];
	[self loadData];
    [self loadMenu];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        //NSLog(@"ok");
        [self login];
    }
    else
    {
        //NSLog(@"cancel");
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	/*return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);*/
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return elementsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    //return @"iSWAD";
    return @"";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                     initWithStyle:UITableViewCellStyleDefault 
                     reuseIdentifier:MyIdentifier] 
                    autorelease];
    }
    NSDictionary *tmp = [elementsList objectAtIndex:(int)indexPath.section];
    
    cell.textLabel.text = NSLocalizedString([tmp objectForKey:@"key"],nil);
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];

    UIImage *theImage = [UIImage imageNamed:[tmp objectForKey:@"icon"]];
    
    cell.imageView.image = theImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSDictionary *tmp = [elementsList objectAtIndex:(int)indexPath.section];
    
    NSString *key = [tmp objectForKey:@"key"];
    
    UIViewController *view = NULL;
    
    if ([key isEqualToString:NotificationsKey]){
        view = [[NotificationsViewController alloc] initWithNibName:[NotificationsViewController description] bundle:nil];
    } else if([key isEqualToString:NoticesKey]){
        view = [[NoticesViewController alloc] initWithNibName: [NoticesViewController description] bundle:nil];
    } else if([key isEqualToString:TestsKey]){
		view = [[ConfigureTestViewController alloc] initWithNibName: [ConfigureTestViewController description] bundle:nil];
	}
    
    if (view != NULL) {
        [self.navigationController pushViewController:view animated:YES];
        [view release];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}
@end
