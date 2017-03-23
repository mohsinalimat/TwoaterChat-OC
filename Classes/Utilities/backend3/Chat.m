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

@implementation Chat

#pragma mark - GroupId methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)groupId:(NSArray *)members
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSArray *sorted = [members sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	return [Checksum md5HashOfString:[sorted componentsJoinedByString:@""]];
}

#pragma mark - Private Chat methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDictionary *)startPrivate:(DBUser *)dbuser2
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FUser *user1 = [FUser currentUser];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *userId1 = [user1 objectId];
	NSString *userId2 = dbuser2.objectId;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *initials1 = [user1 initials];
	NSString *initials2 = [dbuser2 initials];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *picture1 = user1[FUSER_PICTURE];
	NSString *picture2 = dbuser2.picture;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *name1 = user1[FUSER_FULLNAME];
	NSString *name2 = dbuser2.fullname;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSArray *members = @[userId1, userId2];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *groupId = [self groupId:members];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Password init:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Recent fetchMembers:groupId completion:^(NSMutableArray *userIds)
	{
		if ([userIds containsObject:userId1] == NO)
			[Recent createPrivate:userId1 groupId:groupId initials:initials2 picture:picture2 description:name2 members:members];
		if ([userIds containsObject:userId2] == NO)
			[Recent createPrivate:userId2 groupId:groupId initials:initials1 picture:picture1 description:name1 members:members];
	}];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return @{@"groupId":groupId, @"members":members, @"type":CHAT_PRIVATE};
}

#pragma mark - Multiple Chat methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDictionary *)startMultiple:(NSArray *)userIds
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSMutableArray *members = [NSMutableArray arrayWithArray:userIds];
	[members addObject:[FUser currentId]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *groupId = [self groupId:members];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Password init:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Recent createMultiple:groupId members:members];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return @{@"groupId":groupId, @"members":members, @"type":CHAT_MULTIPLE};
}

#pragma mark - Group Chat methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDictionary *)startGroup1:(FObject *)group
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSArray *members = group[FGROUP_MEMBERS];
	NSString *groupId = [group objectId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *picture = (group[FGROUP_PICTURE] != nil) ? group[FGROUP_PICTURE] : [FUser picture];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Password init:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Recent createGroup:groupId picture:picture description:group[FGROUP_NAME] members:members];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return @{@"groupId":groupId, @"members":members, @"type":CHAT_GROUP};
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDictionary *)startGroup2:(DBGroup *)dbgroup
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSArray *members = [dbgroup.members componentsSeparatedByString:@","];
	NSString *groupId = dbgroup.objectId;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *picture = (dbgroup.picture != nil) ? dbgroup.picture : [FUser picture];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Password init:groupId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[Recent createGroup:groupId picture:picture description:dbgroup.name members:members];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return @{@"groupId":groupId, @"members":members, @"type":CHAT_GROUP};
}

#pragma mark - Restart Recent Chat methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (NSDictionary *)restartRecent:(DBRecent *)dbrecent
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSArray *members = [dbrecent.members componentsSeparatedByString:@","];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return @{@"groupId":dbrecent.groupId, @"members":members, @"type":dbrecent.type};
}

@end

