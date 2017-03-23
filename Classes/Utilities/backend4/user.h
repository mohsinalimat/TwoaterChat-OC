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

//-------------------------------------------------------------------------------------------------------------------------------------------------
void			LogoutUser				(NSInteger delAccount);
void			LoginUser				(id target);

//-------------------------------------------------------------------------------------------------------------------------------------------------
void			OnboardUser				(id target);

//-------------------------------------------------------------------------------------------------------------------------------------------------
void			UserLoggedIn			(NSString *loginMethod);
void			UpdateUserSettings		(NSString *loginMethod);

//-------------------------------------------------------------------------------------------------------------------------------------------------
void			UpdateOneSignalId		(void);
void			AssignOneSignalId		(void);
void			ResignOneSignalId		(void);

//-------------------------------------------------------------------------------------------------------------------------------------------------
void			UpdateLastActive		(void);
void			UpdateLastTerminate		(BOOL fetch);

//-------------------------------------------------------------------------------------------------------------------------------------------------
NSString*		UserLastActive			(DBUser *dbuser);
NSString*		UserNamesFor			(NSArray *members, NSString *userId);
