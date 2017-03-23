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

#import "LoginGoogleView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface LoginGoogleView()
{
	BOOL initialized;
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation LoginGoogleView

@synthesize delegate;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	self.title = @"Google login";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[GIDSignIn sharedInstance].uiDelegate = self;
	[GIDSignIn sharedInstance].delegate = self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (initialized == NO)
	{
		initialized = YES;
		[self actionGoogle];
	}
}

#pragma mark - Google login methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionGoogle
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[[GIDSignIn sharedInstance] signIn];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)googleUser withError:(NSError *)error
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (googleUser != nil)
	{
		[self signinWithGoogle:googleUser];
	}
	else [self dismissViewControllerAnimated:YES completion:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)signinWithGoogle:(GIDGoogleUser *)googleUser
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[ProgressHUD show:nil Interaction:NO];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	GIDAuthentication *authentication = googleUser.authentication;
	FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[FUser signInWithCredential:credential completion:^(FUser *user, NSError *error)
	{
		if (error == nil)
		{
			[self dismissViewControllerAnimated:YES completion:^{
				if (delegate != nil) [delegate didLoginGoogle];
			}];
		}
		else [ProgressHUD showError:[error description]];
	}];
}

@end

