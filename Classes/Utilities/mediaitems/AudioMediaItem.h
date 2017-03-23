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

#import "JSQMediaItem.h"
#import "JSQAudioMediaViewAttributes.h"

#import <AVFoundation/AVFoundation.h>

@class AudioMediaItem;

NS_ASSUME_NONNULL_BEGIN

//-------------------------------------------------------------------------------------------------------------------------------------------------
@protocol AudioMediaItemDelegate <NSObject>
//-------------------------------------------------------------------------------------------------------------------------------------------------

- (void)audioMediaItem:(AudioMediaItem *)audioMediaItem didChangeAudioCategory:(NSString *)category
			   options:(AVAudioSessionCategoryOptions)options error:(nullable NSError *)error;

@end

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface AudioMediaItem : JSQMediaItem <JSQMessageMediaData, AVAudioPlayerDelegate, NSCoding, NSCopying>
//-------------------------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, assign) int status;

@property (nonatomic, weak, nullable) id<AudioMediaItemDelegate> delegate;

@property (nonatomic, strong, readonly) JSQAudioMediaViewAttributes *audioViewAttributes;

@property (nonatomic, strong, nullable) NSData *audioData;

- (instancetype)initWithData:(nullable NSData *)audioData
         audioViewAttributes:(JSQAudioMediaViewAttributes *)audioViewAttributes NS_DESIGNATED_INITIALIZER;

- (instancetype)init;

- (instancetype)initWithAudioViewAttributes:(JSQAudioMediaViewAttributes *)audioViewAttributes;

- (instancetype)initWithData:(nullable NSData *)audioData;

- (void)setAudioDataWithUrl:(nonnull NSURL *)audioURL;

- (void)stopAudioPlayer;

@end

NS_ASSUME_NONNULL_END

