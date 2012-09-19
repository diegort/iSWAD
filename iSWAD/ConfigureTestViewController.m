#import "ConfigureTestViewController.h"
#import "WebCommunication.h"
#import "DBManager.h"
#import "getTestConfigOutput.h"
#import "tagsArray.h"
#import "tag.h"

@implementation ConfigureTestViewController
@synthesize courseCode = _courseCode;
@synthesize txtNumQuestions = _txtNumQuestions;
@synthesize lblNumQuestiones = _lblNumQuestiones;
@synthesize btnOK = _btnOK;
@synthesize lblTypeQuestion = _lblTypeQuestion;
@synthesize btonOkTypeQuestion = _btonOkTypeQuestion;
@synthesize lblQuestionsTags = _lblQuestionsTags;
@synthesize btnOkQuestionTags = _btnOkQuestionTags;

enum etapa{
	numQuestions = 1,
	questionsType,
	tags
};

enum etapa e;

NSString* questionTypes[] = {@"TF", @"uniqueChoice",@"multipleChoice",@"text",@"int",@"float"};
tagsArray* _tags;

BOOL types[6];


- (void) loadView{
	NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ConfigureTestViewController"
													  owner:self
													options:nil];
	int i;
	switch (e) {
		case numQuestions:
			[self configureNumQuestionsView];
			i = 0;
			break;
		case questionsType:
			[self configureQuestionsTypeView];
			i = 1;
			break;
		case tags:
			[self configureTagsView];
			i = 2;
			break;
		default:
			break;
	}
	//NSLog(@"%d", nibViews.count);
	UIView* v= [nibViews objectAtIndex: i];
	self.view = v;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil courseCode:(int)code
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		myDB = [[DBManager alloc] init];
		
		_courseCode = code;
		_config = [myDB getTestConfig:_courseCode];
		
		e = numQuestions;
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
    } else {
        // Not found, so remove keyboard.
        //[txtUser resignFirstResponder];
        //[txtPass resignFirstResponder];
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void) configureNumQuestionsView{
	//numQuestions = [[UIView alloc] initWithFrame:self.view.frame];
	
	NSMutableString* text = [[NSMutableString alloc] initWithString:NSLocalizedString(@"numQuestions", nil)];
	[text appendFormat:@" [%d - %d]", _config.minQuestions, _config.maxQuestions];
	
	_lblNumQuestiones.text = text;
	[_btnOK setTitle: NSLocalizedString(@"Accept", nil) forState:UIControlStateNormal];
	_txtNumQuestions.text = [[NSNumber numberWithInt:_config.defQuestions] stringValue];
}

- (void) configureTagsView{
	[_btnOkQuestionTags setTitle:NSLocalizedString(@"Accept", nil) forState:UIControlStateNormal];
	_lblQuestionsTags.text = NSLocalizedString(@"tagsQuestions", nil);
	_tags = [myDB courseTags:_courseCode];
}

- (void) configureQuestionsTypeView{
	[_btonOkTypeQuestion setTitle: NSLocalizedString(@"Accept", nil) forState:UIControlStateNormal];
	_lblTypeQuestion.text = NSLocalizedString(@"typeQuestions", nil);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	int r;
	switch (tableView.tag) {
		case 0:
			r = 6;
			break;
		case 1:
			r = _tags.count;
			break;
			
		default:
			r = 0;
			break;
	}
    return r;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    if( aCell == nil ) {
		aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitchCell"] autorelease];
        
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        aCell.accessoryView = switchView;
		switchView.tag = [indexPath row];
        [switchView setOn:NO animated:NO];
		switch (tableView.tag) {
			case 0:
				aCell.textLabel.text = NSLocalizedString(questionTypes[[indexPath row]],nil);
				[switchView addTarget:self action:@selector(switchTypeChanged:) forControlEvents:UIControlEventValueChanged];
				break;
			case 1:
			{
				tag* t = [_tags objectAtIndex:[indexPath row]];
				aCell.textLabel.text = t.tagText;
				[switchView addTarget:self action:@selector(switchTagChanged:) forControlEvents:UIControlEventValueChanged];
			}
				break;
				
		}
        
        [switchView release];
	}
    return aCell;
}

- (void) switchTypeChanged:(id)sender {
    UISwitch* switchControl = sender;
    //NSLog( @"The switch %@ is %@", questionTypes[switchControl.tag],  switchControl.on ? @"ON" : @"OFF" );
}

- (void) switchTagChanged:(id)sender {
    UISwitch* switchControl = sender;
    //NSLog( @"The switch %d is %@", switchControl.tag,  switchControl.on ? @"ON" : @"OFF" );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	[self setLblNumQuestiones:nil];
	[self setTxtNumQuestions:nil];
	[self setBtnOK:nil];
	[self setBtonOkTypeQuestion:nil];
	[self setBtnOkQuestionTags:nil];
	[self setLblQuestionsTags:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc{
	[myDB release];
	[_lblNumQuestiones release];
	[_txtNumQuestions release];
	[_btnOK release];
	[_btonOkTypeQuestion release];
	[_btnOkQuestionTags release];
	[_lblQuestionsTags release];
	[super dealloc];
}

- (IBAction)btnOk_click:(id)sender {
	UIButton* btn = sender;
	switch (btn.tag) {
		case numQuestions:
		case questionsType:
			e++;
			[self loadView];
			break;
		case tags:
			NSLog(@"%@", @"Tags");
			break;
	}
}
@end
