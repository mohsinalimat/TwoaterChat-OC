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
@interface DBCallHistory : RLMObject
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (long long)lastUpdatedAt;

@property NSString *objectId;

@property NSString *initiatorId;
@property NSString *recipientId;
@property NSString *phoneNumber;

@property NSString *type;
@property NSString *text;

@property NSString *status;
@property NSInteger duration;

@property long long startedAt;
@property long long establishedAt;
@property long long endedAt;

@property BOOL isDeleted;

@property long long createdAt;
@property long long updatedAt;

@end

