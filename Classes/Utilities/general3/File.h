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
@interface File : NSObject
//-------------------------------------------------------------------------------------------------------------------------------------------------

+ (NSString *)temp:(NSString *)ext;

+ (BOOL)exist:(NSString *)path;

+ (BOOL)remove:(NSString *)path;

+ (void)copy:(NSString *)src dest:(NSString *)dest overwrite:(BOOL)overwrite;

+ (NSDate *)created:(NSString *)path;

+ (NSDate *)modified:(NSString *)path;

+ (long long)size:(NSString *)path;

+ (long long)diskFree;

@end

