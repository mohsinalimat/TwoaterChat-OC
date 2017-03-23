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

#import "utilities.h"

@implementation DBMessage

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)primaryKey
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return FMESSAGE_OBJECTID;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (long long)lastUpdatedAt:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupId == %@", groupId];
	DBMessage *dbmessage = [[[DBMessage objectsWithPredicate:predicate] sortedResultsUsingProperty:@"updatedAt" ascending:YES] lastObject];
	return dbmessage.updatedAt;
}

@end

