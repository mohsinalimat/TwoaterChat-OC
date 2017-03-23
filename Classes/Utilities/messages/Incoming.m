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

#import "Incoming.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface Incoming()
{
	NSString *senderId;
	NSString *senderName;
	NSDate *date;

	BOOL maskOutgoing;

	DBMessage *dbmessage;
	JSQMessagesCollectionView *collectionView;
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation Incoming

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(DBMessage *)dbmessage_ CollectionView:(JSQMessagesCollectionView *)collectionView_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dbmessage = dbmessage_;
	collectionView = collectionView_;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSQMessage *)createMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	senderId = dbmessage.senderId;
	senderName = dbmessage.senderName;
	date = [NSDate dateWithTimestamp:dbmessage.createdAt];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	maskOutgoing = [senderId isEqualToString:[FUser currentId]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([dbmessage.type isEqualToString:MESSAGE_TEXT])		return [self createTextMessage];
	if ([dbmessage.type isEqualToString:MESSAGE_EMOJI])		return [self createEmojiMessage];
	if ([dbmessage.type isEqualToString:MESSAGE_PICTURE])	return [self createPictureMessage];
	if ([dbmessage.type isEqualToString:MESSAGE_VIDEO])		return [self createVideoMessage];
	if ([dbmessage.type isEqualToString:MESSAGE_AUDIO])		return [self createAudioMessage];
	if ([dbmessage.type isEqualToString:MESSAGE_LOCATION])	return [self createLocationMessage];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return nil;
}

#pragma mark - Text message

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSQMessage *)createTextMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderName date:date text:dbmessage.text];
}

#pragma mark - Emoji message

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSQMessage *)createEmojiMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	EmojiMediaItem *mediaItem = [[EmojiMediaItem alloc] initWithText:dbmessage.text];
	mediaItem.appliesMediaViewMaskAsOutgoing = maskOutgoing;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderName date:date media:mediaItem];
}

#pragma mark - Picture message

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSQMessage *)createPictureMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PhotoMediaItem *mediaItem = [[PhotoMediaItem alloc] initWithImage:nil Width:@(dbmessage.picture_width) Height:@(dbmessage.picture_height)];
	mediaItem.appliesMediaViewMaskAsOutgoing = maskOutgoing;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[MediaManager loadPicture:mediaItem dbmessage:dbmessage collectionView:collectionView];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderName date:date media:mediaItem];
}

#pragma mark - Video message

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSQMessage *)createVideoMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	VideoMediaItem *mediaItem = [[VideoMediaItem alloc] initWithMaskAsOutgoing:maskOutgoing];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[MediaManager loadVideo:mediaItem dbmessage:dbmessage collectionView:collectionView];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderName date:date media:mediaItem];
}

#pragma mark - Audio message

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSQMessage *)createAudioMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	AudioMediaItem *mediaItem = [[AudioMediaItem alloc] initWithData:nil];
	mediaItem.appliesMediaViewMaskAsOutgoing = maskOutgoing;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[MediaManager loadAudio:mediaItem dbmessage:dbmessage collectionView:collectionView];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderName date:date media:mediaItem];
}

#pragma mark - Location message

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSQMessage *)createLocationMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQLocationMediaItem *mediaItem = [[JSQLocationMediaItem alloc] initWithLocation:nil];
	mediaItem.appliesMediaViewMaskAsOutgoing = maskOutgoing;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CLLocation *location = [[CLLocation alloc] initWithLatitude:dbmessage.latitude longitude:dbmessage.longitude];
	[mediaItem setLocation:location withCompletionHandler:^{
		[collectionView reloadData];
	}];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderName date:date media:mediaItem];
}

@end

