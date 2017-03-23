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

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface Messages()
{
	NSString *groupId;

	NSTimer *timer;
	BOOL refreshUserInterface1;
	BOOL refreshUserInterface2;
	BOOL playMessageReceivedSound;

	FIRDatabaseReference *firebase;
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation Messages

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(NSString *)groupId_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	groupId = groupId_;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(refreshUserInterface) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self createObservers];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return self;
}

#pragma mark - Cleanup methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCleanup
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[timer invalidate]; timer = nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[firebase removeAllObservers]; firebase = nil;
}

#pragma mark - Backend methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)createObservers
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	long long lastUpdatedAt = [DBMessage lastUpdatedAt:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	firebase = [[[FIRDatabase database] referenceWithPath:FMESSAGE_PATH] child:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[firebase observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot)
	{
		NSDictionary *message = snapshot.value;
		if ([message[FMESSAGE_UPDATEDAT] longLongValue] > lastUpdatedAt)
		{
			[self updateIncoming:message];
			dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL), ^{
				[self updateRealm:message];
				refreshUserInterface1 = YES;
			});
		}
	}];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[firebase observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot *snapshot)
	{
		NSDictionary *message = snapshot.value;
		dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL), ^{
			[self updateRealm:message];
			refreshUserInterface2 = YES;
		});
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateRealm:(NSDictionary *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:message];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (message[FMESSAGE_GROUPID] != nil)
		temp[FMESSAGE_TEXT] = [Cryptor decryptText:message[FMESSAGE_TEXT] groupId:message[FMESSAGE_GROUPID]];
 	//---------------------------------------------------------------------------------------------------------------------------------------------
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm beginWriteTransaction];
	[DBMessage createOrUpdateInRealm:realm withValue:temp];
	[realm commitWriteTransaction];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateIncoming:(NSDictionary *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([message[FMESSAGE_SENDERID] isEqualToString:[FUser currentId]] == NO)
	{
		if ([message[FMESSAGE_STATUS] isEqualToString:TEXT_SENT])
		{
			NSString *messageId = message[FMESSAGE_OBJECTID];
			[Message updateStatus:groupId messageId:messageId];
			playMessageReceivedSound = YES;
		}
	}
}

#pragma mark - Notification methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)refreshUserInterface
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (refreshUserInterface1)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[NotificationCenter post:NOTIFICATION_REFRESH_MESSAGES1];
			refreshUserInterface1 = NO;
		});
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (refreshUserInterface2)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[NotificationCenter post:NOTIFICATION_REFRESH_MESSAGES2];
			refreshUserInterface2 = NO;
		});
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (playMessageReceivedSound)
	{
		[JSQSystemSoundPlayer jsq_playMessageReceivedSound];
		playMessageReceivedSound = NO;
	}
}

@end

