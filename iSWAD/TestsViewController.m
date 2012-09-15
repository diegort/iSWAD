#import "TestsViewController.h"
#import "Literals.h"
#import "CourseSelector.h"
#import "WebCommunication.h"
#import "DBManager.h"

@implementation TestsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[[NSNotificationCenter defaultCenter] removeObserver:self name:Common object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testConfigDownloaded:) name:Common object:nil];
		
        [[NSNotificationCenter defaultCenter] removeObserver:self name:TestConfigReady object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testConfigDownloaded:) name:TestConfigReady object:nil];
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:TestReady object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testConfigDownloaded:) name:TestReady object:nil];
		
		cs = [[CourseSelector alloc] initWithTarget:self selector:@selector(courseCallback:)];
		wc = [[WebCommunication alloc] init];
		myDB = [[DBManager alloc] init];
		
		app = [UIApplication sharedApplication];
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
		[activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		
		activityIndicatorView.alpha = 0.7;
		activityIndicatorView.backgroundColor = [UIColor lightGrayColor];
		activityIndicatorView.center = CGPointMake(160, 180);
		activityIndicatorView.hidesWhenStopped = YES;
		activityIndicatorView.layer.cornerRadius = 10.0;
		activityIndicatorView.layer.masksToBounds = YES;
		
		[self.view addSubview:activityIndicatorView];
		[activityIndicatorView release];
		
    }
    return self;
}

- (void) testDownloaded: (NSNotification*)n{
	app.networkActivityIndicatorVisible = NO;
	[activityIndicatorView stopAnimating];
	NSNumber* res=[n object];
	switch ([res intValue]) {
		case 0:
		{
			UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"testDownloadedAlertTitle", nil)
                                  message: NSLocalizedString(@"testDownloadedAlertTitle", nil)
                                  delegate: nil
                                  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
		}
			break;
		case -1:
		{
			UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: NSLocalizedString(@"testDownloadErrorAlertTitle", nil)
                                  message: NSLocalizedString(@"testDownloadErrorAlertMessage", nil)
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

- (void) testConfigDownloaded: (NSNotification*) n{
	if ([[n object] isKindOfClass:[getTestConfigOutput class]]) {
		getTestConfigOutput* tmp = [n object];
		if (tmp.pluggable != 0){
			long _time;
			_time = [myDB getLastTestDownload:_courseCode];
			[wc getTests:_courseCode beginTime:_time];
		}else{
			app.networkActivityIndicatorVisible = NO;
			[activityIndicatorView stopAnimating];
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle: NSLocalizedString(@"noDownloadAlertTitle", nil)
								  message: NSLocalizedString(@"noDownloadAlertMessage", nil)
								  delegate: nil
								  cancelButtonTitle:NSLocalizedString(@"Accept", nil)
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}else{
		app.networkActivityIndicatorVisible = NO;
		[activityIndicatorView stopAnimating];
		NSNumber* res=[n object];
		switch ([res intValue]) {
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
			case -1:
			{
				UIAlertView *alert = [[UIAlertView alloc]
									  initWithTitle: NSLocalizedString(@"testConfigErrorAlertTitle", nil)
									  message: NSLocalizedString(@"testConfigErrorAlertMessage", nil)
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	[self setBtnDownload:nil];
	[self setBtnMake:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) courseCallback:(NSNumber*) status{
	self.btnDownload.userInteractionEnabled = true;
	self.btnMake.userInteractionEnabled = true;
	if ([status intValue] == 0){
		_courseCode = [cs getSelectedCode];
		app.networkActivityIndicatorVisible = YES;
		[activityIndicatorView startAnimating];
		[wc getTestConfig:_courseCode];		
	}else{
		[activityIndicatorView stopAnimating];
	}
}

- (IBAction)btnDownload_clic:(id)sender {
	self.btnDownload.userInteractionEnabled = false;
	self.btnMake.userInteractionEnabled = false;
	
	[cs showSelector:2];
}

- (IBAction)btnMake_clic:(id)sender {
}
- (void)dealloc {
	[_btnDownload release];
	[_btnMake release];
	[cs release];
	[wc release];
	[myDB release];
	[super dealloc];
}
@end
