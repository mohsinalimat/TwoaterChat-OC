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

@implementation Recent

#pragma mark - Fetch methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)fetchRecents:(NSString *)groupId completion:(void (^)(NSMutableArray *recents))completion
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FIRDatabaseReference *firebase = [[FIRDatabase database] referenceWithPath:FRECENT_PATH];
	FIRDatabaseQuery *query = [[firebase queryOrderedByChild:FRECENT_GROUPID] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
	{
		NSMutableArray *recents = [[NSMutableArray alloc] init];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if (snapshot.exists)
		{
			for (NSDictionary *dictionary in [snapshot.value allValues])
			{
				FObject *recent = [FObject objectWithPath:FRECENT_PATH dictionary:dictionary];
				[recents addObject:recent];
			}
		}
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if (completion != nil) completion(recents);
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)fetchMembers:(NSString *)groupId completion:(void (^)(NSMutableArray *userIds))completion
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FIRDatabaseReference *firebase = [[FIRDatabase database] referenceWithPath:FRECENT_PATH];
	FIRDatabaseQuery *query = [[firebase queryOrderedByChild:FRECENT_GROUPID] queryEqualToValue:groupId];
	[query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
	{
		NSMutableArray *userIds = [[NSMutableArray alloc] init];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if (snapshot.exists)
		{
			for (NSDictionary *dictionary in [snapshot.value allValues])
			{
				[userIds addObject:dictionary[FRECENT_USERID]];
			}
		}
		//-----------------------------------------------------------------------------------------------------------------------------------------
		if (completion != nil) completion(userIds);
	}];
}

#pragma mark - Create methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)createPrivate:(NSString *)userId groupId:(NSString *)groupId initials:(NSString *)initials picture:(NSString *)picture
		  description:(NSString *)description members:(NSArray *)members
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self createItem:userId groupId:groupId initials:initials picture:picture description:description members:members type:CHAT_PRIVATE];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)createMultiple:(NSString *)groupId members:(NSArray *)members
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self fetchMembers:groupId completion:^(NSMutableArray *userIds)
	{
		NSMutableArray *createIds = [[NSMutableArray alloc] initWithArray:members];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		for (NSString *userId in userIds)
			[createIds removeObject:userId];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		for (NSString *userId in createIds)
		{
			NSString *description = UserNamesFor(members, userId);
			[self createItem:userId groupId:groupId initials:[FUser initials] picture:[FUser picture] description:description
					 members:members type:CHAT_MULTIPLE];
		}
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)createGroup:(NSString *)groupId picture:(NSString *)picture description:(NSString *)description members:(NSArray *)members
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self fetchMembers:groupId completion:^(NSMutableArray *userIds)
	{
		NSMutableArray *createIds = [[NSMutableArray alloc] initWithArray:members];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		for (NSString *userId in userIds)
			[createIds removeObject:userId];
		//-----------------------------------------------------------------------------------------------------------------------------------------
		for (NSString *userId in createIds)
		{
			[self createItem:userId groupId:groupId initials:[FUser initials] picture:picture description:description
					 members:members type:CHAT_GROUP];
		}
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)createItem:(NSString *)userId groupId:(NSString *)groupId initials:(NSString *)initials picture:(NSString *)picture
	   description:(NSString *)description members:(NSArray *)members type:(NSString *)type
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FObject *recent = [FObject objectWithPath:FRECENT_PATH];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *temp = [NSString stringWithFormat:@"%@%@", groupId, userId];
	recent[FRECENT_OBJECTID] = [Checksum md5HashOfString:temp];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	recent[FRECENT_USERID] = userId;
	recent[FRECENT_GROUPID] = groupId;

	recent[FRECENT_INITIALS] = initials;
	recent[FRECENT_PICTURE] = (picture != nil) ? picture : @"";
	recent[FRECENT_DESCRIPTION] = description;
	recent[FRECENT_MEMBERS] = members;
	recent[FRECENT_PASSWORD] = [Password get:groupId];
	recent[FRECENT_TYPE] = type;

	recent[FRECENT_COUNTER] = @0;
	recent[FRECENT_LASTMESSAGE] = @"";
	recent[FRECENT_LASTMESSAGEDATE] = [FIRServerValue timestamp];

	recent[FRECENT_ISARCHIVED] = @NO;
	recent[FRECENT_ISDELETED] = @NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[recent saveInBackground];
}

#pragma mark - Update methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)updateLastMessage:(FObject *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self fetchRecents:message[FMESSAGE_GROUPID] completion:^(NSMutableArray *recents)
	{
		for (FObject *recent in recents)
		{
			[self updateLastMessage:recent LastMessage:message[FMESSAGE_TEXT]];
		}
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)updateLastMessage:(FObject *)recent LastMessage:(NSString *)lastMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSInteger counter = [recent[FRECENT_COUNTER] integerValue];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([recent[FRECENT_USERID] isEqualToString:[FUser currentId]] == NO) counter++;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	recent[FRECENT_COUNTER] = @(counter);
	recent[FRECENT_LASTMESSAGE] = lastMessage;
	recent[FRECENT_LASTMESSAGEDATE] = [FIRServerValue timestamp];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	BOOL activate = [recent[FRECENT_MEMBERS] containsObject:recent[FRECENT_USERID]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (activate) recent[FRECENT_ISARCHIVED] = @NO;
	if (activate) recent[FRECENT_ISDELETED] = @NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[recent saveInBackground];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)updateMembers:(FObject *)group
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self fetchRecents:[group objectId] completion:^(NSMutableArray *recents)
	{
		for (FObject *recent in recents)
		{
			NSSet *set1 = [NSSet setWithArray:group[FGROUP_MEMBERS]];
			NSSet *set2 = [NSSet setWithArray:recent[FRECENT_MEMBERS]];
			if ([set1 isEqualToSet:set2] == NO)
			{
				[self updateMembers:recent Members:group[FGROUP_MEMBERS]];
			}
		}
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)updateMembers:(FObject *)recent Members:(NSArray *)members
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([members containsObject:recent[FRECENT_USERID]] == NO)
		recent[FRECENT_ISDELETED] = @YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	recent[FRECENT_MEMBERS] = members;
	[recent saveInBackground];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)updateDescription:(FObject *)group
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self fetchRecents:[group objectId] completion:^(NSMutableArray *recents)
	{
		for (FObject *recent in recents)
		{
			recent[FRECENT_DESCRIPTION] = group[FGROUP_NAME];
			[recent saveInBackground];
		}
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)updatePicture:(FObject *)group
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self fetchRecents:[group objectId] completion:^(NSMutableArray *recents)
	{
		for (FObject *recent in recents)
		{
			recent[FRECENT_PICTURE] = group[FGROUP_PICTURE];
			[recent saveInBackground];
		}
	}];
}

#pragma mark - Delete/Archive methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)deleteItem:(NSString *)objectId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FObject *object = [FObject objectWithPath:FRECENT_PATH];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	object[FRECENT_OBJECTID] = objectId;
	object[FRECENT_ISDELETED] = @YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[object updateInBackground];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)archiveItem:(NSString *)objectId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FObject *object = [FObject objectWithPath:FRECENT_PATH];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	object[FRECENT_OBJECTID] = objectId;
	object[FRECENT_ISARCHIVED] = @YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[object updateInBackground];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)unarchiveItem:(NSString *)objectId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FObject *object = [FObject objectWithPath:FRECENT_PATH];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	object[FRECENT_OBJECTID] = objectId;
	object[FRECENT_ISARCHIVED] = @NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[object updateInBackground];
}

#pragma mark - Clear methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)clearCounter:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self fetchRecents:groupId completion:^(NSMutableArray *recents)
	{
		for (FObject *recent in recents)
		{
			if ([recent[FRECENT_USERID] isEqualToString:[FUser currentId]])
			{
				recent[FRECENT_COUNTER] = @0;
				[recent saveInBackground];
			}
		}
	}];
}

@end

