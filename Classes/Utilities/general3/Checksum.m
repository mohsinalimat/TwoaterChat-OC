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

#include <CommonCrypto/CommonDigest.h>

#import "utilities.h"

@implementation Checksum

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)md5HashOfData:(NSData *)data
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (data != nil)
	{
		unsigned char digest[CC_MD5_DIGEST_LENGTH];
		NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

		CC_MD5(data.bytes, (CC_LONG)data.length, digest);

		for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++)
		{
			[output appendFormat:@"%02x", digest[i]];
		}
		return output;
	}
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)md5HashOfPath:(NSString *)path
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil])
	{
		NSData *data = [NSData dataWithContentsOfFile:path];
		return [self md5HashOfData:data];
	}
	return nil;
}
 
//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)md5HashOfString:(NSString *)string
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (string != nil)
	{
		NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
		return [self md5HashOfData:data];
	}
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)shaHashOfData:(NSData *)data
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (data != nil)
	{
		unsigned char digest[CC_SHA1_DIGEST_LENGTH];
		NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

		CC_SHA1(data.bytes, (CC_LONG)data.length, digest);

		for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++)
		{
			[output appendFormat:@"%02x", digest[i]];
		}
		return output;
	}
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)shaHashOfPath:(NSString *)path
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil])
	{
		NSData *data = [NSData dataWithContentsOfFile:path];
		return [self shaHashOfData:data];
	}
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)shaHashOfString:(NSString *)string
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (string != nil)
	{
		NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
		return [self shaHashOfData:data];
	}
	return nil;
}

@end

