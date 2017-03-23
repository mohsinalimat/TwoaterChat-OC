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

#import "WelcomeView.h"
#import "EditProfileView.h"
#import "NavigationController.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
void LogoutUser(NSInteger delAccount)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	ResignOneSignalId();
	UpdateLastTerminate(NO);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (delAccount == DEL_ACCOUNT_ONE) [Account delOne];
	if (delAccount == DEL_ACCOUNT_ALL) [Account delAll];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([[FUser loginMethod] isEqualToString:LOGIN_GOOGLE])
		[[GIDSignIn sharedInstance] signOut];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([FUser logOut])
	{
		[CacheManager cleanupManual];
		[RealmManager cleanupDatabase];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		[NotificationCenter post:NOTIFICATION_USER_LOGGED_OUT];
	}
	else [ProgressHUD showError:@"Logout error."];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void LoginUser(id target)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	WelcomeView *welcomeView = [[WelcomeView alloc] init];
	[target presentViewController:welcomeView animated:YES completion:^{
		UIViewController *view = (UIViewController *)target;
		[view.tabBarController setSelectedIndex:DEFAULT_TAB];
	}];
}

#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------------------------
void OnboardUser(id target)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NavigationController *navController = [[NavigationController alloc] initWithRootViewController:[[EditProfileView alloc] initWith:YES]];
	[target presentViewController:navController animated:YES completion:nil];
}

#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------------------------
void UserLoggedIn(NSString *loginMethod)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UpdateUserSettings(loginMethod);
	UpdateOneSignalId();
	UpdateLastActive();
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([FUser isOnboardOk])
		[ProgressHUD showSuccess:@"Welcome back!"];
	else [ProgressHUD showSuccess:@"Welcome!"];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[NotificationCenter post:NOTIFICATION_USER_LOGGED_IN];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void UpdateUserSettings(NSString *loginMethod)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	BOOL update = NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	FUser *user = [FUser currentUser];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (user[FUSER_LOGINMETHOD] == nil)		{	update = YES;	user[FUSER_LOGINMETHOD] = loginMethod;			}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (user[FUSER_KEEPMEDIA] == nil)		{	update = YES;	user[FUSER_KEEPMEDIA] = @(KEEPMEDIA_FOREVER);	}
	if (user[FUSER_NETWORKIMAGE] == nil)	{	update = YES;	user[FUSER_NETWORKIMAGE] = @(NETWORK_ALL);		}
	if (user[FUSER_NETWORKVIDEO] == nil)	{	update = YES;	user[FUSER_NETWORKVIDEO] = @(NETWORK_ALL);		}
	if (user[FUSER_NETWORKAUDIO] == nil)	{	update = YES;	user[FUSER_NETWORKAUDIO] = @(NETWORK_ALL);		}
	if (user[FUSER_AUTOSAVEMEDIA] == nil)	{	update = YES;	user[FUSER_AUTOSAVEMEDIA] = @NO;				}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (user[FUSER_LASTACTIVE] == nil)		{	update = YES;	user[FUSER_LASTACTIVE] = @0;					}
	if (user[FUSER_LASTTERMINATE] == nil)	{	update = YES;	user[FUSER_LASTTERMINATE] = @0;					}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (update) [user saveInBackground];
}

#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------------------------
void UpdateOneSignalId(void)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([FUser currentId] != nil)
	{
		if ([UserDefaults stringForKey:ONESIGNALID] != nil)
			AssignOneSignalId();
		else ResignOneSignalId();
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void AssignOneSignalId(void)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *oneSignalId = [UserDefaults stringForKey:ONESIGNALID];
	if ([[FUser oneSignalId] isEqualToString:oneSignalId] == NO)
	{
		FUser *user = [FUser currentUser];
		user[FUSER_ONESIGNALID] = oneSignalId;
		[user saveInBackground];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void ResignOneSignalId(void)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([[FUser oneSignalId] isEqualToString:@""] == NO)
	{
		FUser *user = [FUser currentUser];
		user[FUSER_ONESIGNALID] = @"";
		[user saveInBackground];
	}
}

#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------------------------
void UpdateLastActive(void)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void UpdateLastTerminate(BOOL fetch)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------------------------
NSString* UserLastActive(DBUser *dbuser)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return @"";
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
NSString* UserNamesFor(NSArray *members, NSString *userId)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSMutableArray *names = [[NSMutableArray alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	for (DBUser *dbuser in [[DBUser allObjects] sortedResultsUsingProperty:FUSER_FULLNAME ascending:YES])
	{
		if ([members containsObject:dbuser.objectId])
		{
			if ([dbuser.objectId isEqualToString:userId] == NO)
				[names addObject:dbuser.fullname];
		}
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return [names componentsJoinedByString:@", "];
}

