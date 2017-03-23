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

#import <UIKit/UIKit.h>

#import "AudioMediaItem.h"
#import "PhotoMediaItem.h"
#import "VideoMediaItem.h"

#import "DBMessage.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface MediaManager : NSObject
//-------------------------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Picture

+ (void)loadPicture:(PhotoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
	 collectionView:(UICollectionView *)collectionView;

+ (void)loadPictureManual:(PhotoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		   collectionView:(UICollectionView *)collectionView;

#pragma mark - Video

+ (void)loadVideo:(VideoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
   collectionView:(UICollectionView *)collectionView;

+ (void)loadVideoManual:(VideoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		 collectionView:(UICollectionView *)collectionView;

#pragma mark - Audio

+ (void)loadAudio:(AudioMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
   collectionView:(UICollectionView *)collectionView;

+ (void)loadAudioManual:(AudioMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		 collectionView:(UICollectionView *)collectionView;

@end

