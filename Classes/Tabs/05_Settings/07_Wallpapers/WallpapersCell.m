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

#import "WallpapersCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface WallpapersCell()

@property (strong, nonatomic) IBOutlet UIImageView *imageItem;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation WallpapersCell

@synthesize imageItem;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindData:(NSString *)file
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	imageItem.image = [UIImage imageNamed:file];
}

@end

