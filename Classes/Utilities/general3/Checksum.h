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
@interface Checksum : NSObject
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (NSString *)md5HashOfData:(NSData *)data;
+ (NSString *)md5HashOfPath:(NSString *)path;
+ (NSString *)md5HashOfString:(NSString *)string;

+ (NSString *)shaHashOfData:(NSData *)data;
+ (NSString *)shaHashOfPath:(NSString *)path;
+ (NSString *)shaHashOfString:(NSString *)string;

@end

