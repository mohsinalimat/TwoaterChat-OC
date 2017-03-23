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

#import "DBUser.h"
#import "DBGroup.h"
#import "DBRecent.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface Chat : NSObject
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (NSString *)groupId:(NSArray *)members;

+ (NSDictionary *)startPrivate:(DBUser *)dbuser2;

+ (NSDictionary *)startMultiple:(NSArray *)userIds;

+ (NSDictionary *)startGroup1:(FObject *)group;
+ (NSDictionary *)startGroup2:(DBGroup *)dbgroup;

+ (NSDictionary *)restartRecent:(DBRecent *)dbrecent;

@end

