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

#import <Foundation/Foundation.h>

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface DownloadManager : NSObject
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (void)image:(NSString *)link completion:(void (^)(NSString *path, NSError *error, BOOL network))completion;

+ (void)image:(NSString *)link md5:(NSString *)md5 completion:(void (^)(NSString *path, NSError *error, BOOL network))completion;
+ (void)video:(NSString *)link md5:(NSString *)md5 completion:(void (^)(NSString *path, NSError *error, BOOL network))completion;
+ (void)audio:(NSString *)link md5:(NSString *)md5 completion:(void (^)(NSString *path, NSError *error, BOOL network))completion;

+ (void)start:(NSString *)link ext:(NSString *)ext md5:(NSString *)md5 manual:(BOOL)checkManual
   completion:(void (^)(NSString *path, NSError *error, BOOL network))completion;

+ (NSString *)fileImage:(NSString *)link;
+ (NSString *)fileVideo:(NSString *)link;
+ (NSString *)fileAudio:(NSString *)link;

+ (NSString *)pathImage:(NSString *)link;
+ (NSString *)pathVideo:(NSString *)link;
+ (NSString *)pathAudio:(NSString *)link;

+ (void)clearManualImage:(NSString *)link;
+ (void)clearManualVideo:(NSString *)link;
+ (void)clearManualAudio:(NSString *)link;

@end

