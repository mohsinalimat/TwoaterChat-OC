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

@implementation Message

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)updateStatus:(NSString *)groupId messageId:(NSString *)messageId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FObject *object = [FObject objectWithPath:FMESSAGE_PATH Subpath:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	object[FMESSAGE_OBJECTID] = messageId;
	object[FMESSAGE_STATUS] = TEXT_READ;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[object updateInBackground];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)deleteItem:(NSString *)groupId messageId:(NSString *)messageId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FObject *object = [FObject objectWithPath:FMESSAGE_PATH Subpath:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	object[FMESSAGE_OBJECTID] = messageId;
	object[FMESSAGE_ISDELETED] = @YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[object updateInBackground];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)deleteItem:(DBMessage *)dbmessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([dbmessage.status isEqualToString:TEXT_QUEUED])
	{
		RLMRealm *realm = [RLMRealm defaultRealm];
		[realm beginWriteTransaction];
		[realm deleteObject:dbmessage];
		[realm commitWriteTransaction];
		[NotificationCenter post:NOTIFICATION_REFRESH_MESSAGES1];
	}
	else [self deleteItem:dbmessage.groupId messageId:dbmessage.objectId];
}

@end

