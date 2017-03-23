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

#import "CacheView.h"
#import "KeepMediaView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface CacheView()

@property (strong, nonatomic) IBOutlet UITableViewCell *cellKeepMedia;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellDescription;

@property (strong, nonatomic) IBOutlet UITableViewCell *cellClearCache;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellCacheSize;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation CacheView

@synthesize cellKeepMedia, cellDescription;
@synthesize cellClearCache, cellCacheSize;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	self.title = @"Cache Settings";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:backButton];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self updateViewDetails];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	ActionPremium();
}

#pragma mark - Backend methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadUser
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSInteger keepMedia = [FUser keepMedia];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (keepMedia == KEEPMEDIA_WEEK)	cellKeepMedia.detailTextLabel.text = @"1 week";
	if (keepMedia == KEEPMEDIA_MONTH)	cellKeepMedia.detailTextLabel.text = @"1 month";
	if (keepMedia == KEEPMEDIA_FOREVER)	cellKeepMedia.detailTextLabel.text = @"Forever";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.tableView reloadData];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionKeepMedia
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	KeepMediaView *keepMediaView = [[KeepMediaView alloc] init];
	[self.navigationController pushViewController:keepMediaView animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionClearCache
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[CacheManager cleanupManual];
	[self updateViewDetails];
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateViewDetails
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	long long total = [CacheManager total];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (total < 1000 * 1024)
		cellCacheSize.textLabel.text = [NSString stringWithFormat:@"Cache size: %lld Kbytes", total / 1024];
	else cellCacheSize.textLabel.text = [NSString stringWithFormat:@"Cache size: %lld Mbytes", total / (1000 * 1024)];
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 2;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (section == 0) return 2;
	if (section == 1) return 2;
	return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ((indexPath.section == 0) && (indexPath.row == 1)) return 160;
	return 50;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ((indexPath.section == 0) && (indexPath.row == 0)) return cellKeepMedia;
	if ((indexPath.section == 0) && (indexPath.row == 1)) return cellDescription;
	if ((indexPath.section == 1) && (indexPath.row == 0)) return cellClearCache;
	if ((indexPath.section == 1) && (indexPath.row == 1)) return cellCacheSize;
	return nil;
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((indexPath.section == 0) && (indexPath.row == 0)) [self actionKeepMedia];
	if ((indexPath.section == 1) && (indexPath.row == 0)) [self actionClearCache];
}

@end

