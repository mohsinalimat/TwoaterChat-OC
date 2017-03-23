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

#import <Realm/Realm.h>

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface DBMessage : RLMObject
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (long long)lastUpdatedAt:(NSString *)groupId;

@property NSString *objectId;

@property NSString *groupId;
@property NSString *senderId;
@property NSString *senderName;
@property NSString *senderInitials;

@property NSString *type;
@property NSString *text;

@property NSString *picture;
@property NSInteger picture_width;
@property NSInteger picture_height;
@property NSString *picture_md5;

@property NSString *video;
@property NSInteger video_duration;
@property NSString *video_md5;

@property NSString *audio;
@property NSInteger audio_duration;
@property NSString *audio_md5;

@property CLLocationDegrees latitude;
@property CLLocationDegrees longitude;

@property NSString *status;
@property BOOL isDeleted;

@property long long createdAt;
@property long long updatedAt;

@end

