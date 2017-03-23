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

#import "VideoView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface VideoView()
{
	NSURL *url;
	AVPlayerViewController *controller;
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation VideoView

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(NSURL *)url_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	url = url_;
	return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[NotificationCenter addObserver:self selector:@selector(actionDone) name:AVPlayerItemDidPlayToEndTimeNotification];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	controller = [[AVPlayerViewController alloc] init];
	controller.player = [AVPlayer playerWithURL:url];
	[controller.player play];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self addChildViewController:controller];
	[self.view addSubview:controller.view];
	controller.view.frame = self.view.frame;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillDisappear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[NotificationCenter removeObserver:self];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionDone
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end

