//
// Copyright (c) 2017 Love Mob
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CallsView.h"
#import "CallAudioView.h"
#import "CallVideoView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface CallsView()
{
	RLMResults *dbcallhistories;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation CallsView

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	{
		[self.tabBarItem setImage:[UIImage imageNamed:@"tab_calls"]];
		self.tabBarItem.title = @"Calls";
		//-----------------------------------------------------------------------------------------------------------------------------------------
		[NotificationCenter addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT];
		[NotificationCenter addObserver:self selector:@selector(refreshTableView) name:NOTIFICATION_REFRESH_CALLHISTORIES];
	}
	return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	self.title = @"Calls";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear all" style:UIBarButtonItemStylePlain target:self
																						   action:@selector(actionClearAll)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.tableView.tableFooterView = [[UIView alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self loadCallHistories];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([FUser currentId] != nil)
	{
		if ([FUser isOnboardOk])
		{

		}
		else OnboardUser(self);
	}
	else LoginUser(self);
}

#pragma mark - Realm methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadCallHistories
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDeleted == NO"];
	dbcallhistories = [[DBCallHistory objectsWithPredicate:predicate] sortedResultsUsingProperty:FCALLHISTORY_CREATEDAT ascending:NO];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self refreshTableView];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)deleteCallHistory:(DBCallHistory *)dbcallhistory
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm beginWriteTransaction];
	dbcallhistory.isDeleted = YES;
	[realm commitWriteTransaction];
}

#pragma mark - Backend methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)deleteCallHistories
//-----------------------------------------------------------------------------------------------------------------------------------------------
{
	for (DBCallHistory *dbcallhistory in dbcallhistories)
	{
		[CallHistory deleteItem:dbcallhistory.objectId];
	}
}

#pragma mark - Refresh methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)refreshTableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.tableView reloadData];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionClearAll
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

	UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Clear all" style:UIAlertActionStyleDestructive
													handler:^(UIAlertAction *action) { [self deleteCallHistories]; }];
	UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

	[alert addAction:action1]; [alert addAction:action2];
	[self presentViewController:alert animated:YES completion:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCallAudio:(NSString *)userId
//-----------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCallVideo:(NSString *)userId
//-----------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark - Cleanup methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCleanup
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self refreshTableView];
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return MIN([dbcallhistories count], 25);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	DBCallHistory *dbcallhistory = dbcallhistories[indexPath.row];
	cell.textLabel.text = dbcallhistory.text;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	cell.detailTextLabel.text = dbcallhistory.status;
	cell.detailTextLabel.textColor = [UIColor grayColor];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSDate *date = [NSDate dateWithTimestamp:dbcallhistory.startedAt];
	NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:date];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
	label.text = TimeElapsed(seconds);
	label.textAlignment = NSTextAlignmentRight;
	label.textColor = [UIColor grayColor];
	label.font = [UIFont systemFontOfSize:12];
	cell.accessoryView = label;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	DBCallHistory *dbcallhistory = dbcallhistories[indexPath.row];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self deleteCallHistory:dbcallhistory];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self performSelector:@selector(deleteCallHistoryDelayed:) withObject:dbcallhistory afterDelay:0.25];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)deleteCallHistoryDelayed:(DBCallHistory *)dbcallhistory
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[CallHistory deleteItem:dbcallhistory.objectId];
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	DBCallHistory *dbcallhistory = dbcallhistories[indexPath.row];
	NSString *userId = [dbcallhistory.recipientId isEqualToString:[FUser currentId]] ? dbcallhistory.initiatorId : dbcallhistory.recipientId;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([dbcallhistory.type isEqualToString:CALLHISTORY_AUDIO]) [self actionCallAudio:userId];
	if ([dbcallhistory.type isEqualToString:CALLHISTORY_VIDEO]) [self actionCallVideo:userId];
}

@end

