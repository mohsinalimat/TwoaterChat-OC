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

#import "ArchiveCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ArchiveCell()

@property (strong, nonatomic) IBOutlet UIImageView *imageUser;
@property (strong, nonatomic) IBOutlet UILabel *labelInitials;

@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UILabel *labelLastMessage;

@property (strong, nonatomic) IBOutlet UILabel *labelElapsed;
@property (strong, nonatomic) IBOutlet UILabel *labelCounter;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation ArchiveCell

@synthesize imageUser, labelInitials;
@synthesize labelDescription, labelLastMessage;
@synthesize labelElapsed, labelCounter;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindData:(DBRecent *)dbrecent
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	labelDescription.text = dbrecent.description;
	labelLastMessage.text = dbrecent.lastMessage;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSDate *lastMessageDate = [NSDate dateWithTimestamp:dbrecent.lastMessageDate];
	NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:lastMessageDate];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	labelElapsed.text = TimeElapsed(seconds);
	labelCounter.text = (dbrecent.counter != 0) ? [NSString stringWithFormat:@"%ld new", (long) dbrecent.counter] : nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadImage:(DBRecent *)dbrecent TableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	imageUser.layer.cornerRadius = imageUser.frame.size.width/2;
	imageUser.layer.masksToBounds = YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *path = [DownloadManager pathImage:dbrecent.picture];
	if (path == nil)
	{
		imageUser.image = [UIImage imageNamed:@"archive_blank"];
		labelInitials.text = dbrecent.initials;
		[self downloadImage:dbrecent TableView:tableView IndexPath:indexPath];
	}
	else
	{
		imageUser.image = [[UIImage alloc] initWithContentsOfFile:path];
		labelInitials.text = nil;
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)downloadImage:(DBRecent *)dbrecent TableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[DownloadManager image:dbrecent.picture completion:^(NSString *path, NSError *error, BOOL network)
	{
		if ((error == nil) && ([tableView.indexPathsForVisibleRows containsObject:indexPath]))
		{
			ArchiveCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			cell.imageUser.image = [[UIImage alloc] initWithContentsOfFile:path];
			cell.labelInitials.text = nil;
		}
		else if (error.code == 102)
		{
			dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
			dispatch_after(time, dispatch_get_main_queue(), ^(void){
				[self downloadImage:dbrecent TableView:tableView IndexPath:indexPath];
			});
		}
	}];
}

@end

