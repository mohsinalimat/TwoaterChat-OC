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

#import "AllMediaCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface AllMediaCell()

@property (strong, nonatomic) IBOutlet UIImageView *imageItem;
@property (strong, nonatomic) IBOutlet UIImageView *imageVideo;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation AllMediaCell

@synthesize imageItem, imageVideo;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindData:(DBMessage *)dbmessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	imageItem.image = [UIImage imageNamed:@"allmedia_blank"];
	imageVideo.hidden = [dbmessage.type isEqualToString:MESSAGE_PICTURE];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([dbmessage.type isEqualToString:MESSAGE_PICTURE])
	{
		[self bindPicture:dbmessage];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([dbmessage.type isEqualToString:MESSAGE_VIDEO])
	{
		[self bindVideo:dbmessage];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindPicture:(DBMessage *)dbmessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *path = [DownloadManager pathImage:dbmessage.picture];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (path != nil)
	{
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
		imageItem.image = [Image square:image size:320];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindVideo:(DBMessage *)dbmessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *path = [DownloadManager pathVideo:dbmessage.video];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (path != nil)
	{
		UIImage *image = [Video thumbnail:path];
		imageItem.image = [Image square:image size:320];
	}
}

@end

