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

@implementation DBUser

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)primaryKey
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return FUSER_OBJECTID;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (long long)lastUpdatedAt
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	DBUser *dbuser = [[[DBUser allObjects] sortedResultsUsingProperty:@"updatedAt" ascending:YES] lastObject];
	return dbuser.updatedAt;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)initials
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (([self.firstname length] != 0) && ([self.lastname length] == 0)) return [self.firstname substringToIndex:1];
	if (([self.firstname length] == 0) && ([self.lastname length] != 0)) return [self.lastname substringToIndex:1];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (([self.firstname length] != 0) && ([self.lastname length] != 0))
		return [NSString stringWithFormat:@"%@%@", [self.firstname substringToIndex:1], [self.lastname substringToIndex:1]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return nil;
}

@end

