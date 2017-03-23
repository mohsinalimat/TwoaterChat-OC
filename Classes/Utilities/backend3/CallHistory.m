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

@implementation CallHistory

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)createItem:(NSString *)userId recipientId:(NSString *)recipientId name:(NSString *)name details:(id<SINCallDetails>)details
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *orientation = [userId isEqualToString:recipientId] ? @"↘️" : @"↗️";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *type = details.isVideoOffered ? @"Video" : @"Audio";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *status = @"None";
	if (details.endCause == SINCallEndCauseTimeout)		status = @"Unreachable";
	if (details.endCause == SINCallEndCauseDenied)		status = @"Rejected";
	if (details.endCause == SINCallEndCauseNoAnswer)	status = @"No answer";
	if (details.endCause == SINCallEndCauseError)		status = @"Error";
	if (details.endCause == SINCallEndCauseHungUp)		status = @"Succeed";
	if (details.endCause == SINCallEndCauseCanceled)	status = @"Canceled";
	if (details.endCause == SINCallEndCauseOtherDeviceAnswered) status = @"Other device answered";
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSInteger duration = (NSInteger) [details.endedTime timeIntervalSinceDate:details.establishedTime];
	if (details.endCause != SINCallEndCauseHungUp) duration = 0;
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	FObject *object = [FObject objectWithPath:FCALLHISTORY_PATH Subpath:userId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	object[FCALLHISTORY_INITIATORID] = [FUser currentId];
	object[FCALLHISTORY_RECIPIENTID] = recipientId;

	object[FCALLHISTORY_TYPE] = details.isVideoOffered ? CALLHISTORY_VIDEO : CALLHISTORY_AUDIO;
	object[FCALLHISTORY_TEXT] = name;

	object[FCALLHISTORY_STATUS] = [NSString stringWithFormat:@"%@ %@ - %@", orientation, type, status];
	object[FCALLHISTORY_DURATION] = @(duration);

	object[FCALLHISTORY_STARTEDAT] = @([details.startedTime timestamp]);
	object[FCALLHISTORY_ESTABLISHEDAT] = @([details.establishedTime timestamp]);
	object[FCALLHISTORY_ENDEDAT] = @([details.endedTime timestamp]);

	object[FCALLHISTORY_ISDELETED] = @NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[object saveInBackground:^(NSError *error)
	{
		if (error != nil) [ProgressHUD showError:@"Network error."];
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)deleteItem:(NSString *)objectId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	FObject *object = [FObject objectWithPath:FCALLHISTORY_PATH Subpath:[FUser currentId]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	object[FCALLHISTORY_OBJECTID] = objectId;
	object[FCALLHISTORY_ISDELETED] = @YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[object updateInBackground];
}

@end

