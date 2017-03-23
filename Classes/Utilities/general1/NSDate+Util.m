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

#import "NSDate+Util.h"

@implementation NSDate (Util)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (long long)timestamp
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [self timeIntervalSince1970] * 1000;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDate *)dateWithTimestamp:(long long)timestamp
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSTimeInterval interval = (NSTimeInterval) timestamp / 1000;
	return [NSDate dateWithTimeIntervalSince1970:interval];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDate *)dateWithNumberTimestamp:(NSNumber *)number
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [self dateWithTimestamp:[number longLongValue]];
}

@end

