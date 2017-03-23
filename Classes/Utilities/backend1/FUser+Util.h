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

#import "FUser.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface FUser (Util)
//-------------------------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Class methods

+ (NSString *)fullname;
+ (NSString *)initials;
+ (NSString *)picture;
+ (NSString *)status;
+ (NSString *)loginMethod;
+ (NSString *)oneSignalId;

+ (NSInteger)keepMedia;
+ (NSInteger)networkImage;
+ (NSInteger)networkVideo;
+ (NSInteger)networkAudio;
+ (NSString *)wallpaper;

+ (BOOL)autoSaveMedia;
+ (BOOL)isOnboardOk;

#pragma mark - Instance methods

- (NSString *)initials;

@end

