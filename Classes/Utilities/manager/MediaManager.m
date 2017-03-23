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

@implementation MediaManager

#pragma mark - Picture public

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadPicture:(PhotoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
	 collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *path = [DownloadManager pathImage:dbmessage.picture];
	NSString *localIdentifier = [UserDefaults stringForKey:dbmessage.objectId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((path == nil) && (localIdentifier == nil))
	{
		[self loadPictureMedia:mediaItem dbmessage:dbmessage collectionView:collectionView];
	}
	else if (path != nil)
	{
		[self showPictureFile:mediaItem Path:path collectionView:collectionView];
	}
	else if (localIdentifier != nil)
	{
		[self loadPictureAlbum:mediaItem dbmessage:dbmessage collectionView:collectionView];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadPictureManual:(PhotoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		   collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark - Picture private

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadPictureMedia:(PhotoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		  collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self downloadPictureMedia:mediaItem dbmessage:dbmessage collectionView:collectionView];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)downloadPictureMedia:(PhotoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
			  collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	mediaItem.status = STATUS_LOADING;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[DownloadManager image:dbmessage.picture md5:dbmessage.picture_md5 completion:^(NSString *path, NSError *error, BOOL network)
	{
		if (error == nil)
		{
			if (network) [Cryptor decryptFile:path groupId:dbmessage.groupId];
			//-------------------------------------------------------------------------------------------------------------------------------------
			[self showPictureFile:mediaItem Path:path collectionView:collectionView];
			//-------------------------------------------------------------------------------------------------------------------------------------
			if ([FUser autoSaveMedia]) [self savePictureAlbum:mediaItem dbmessage:dbmessage path:path];
		}
		else mediaItem.status = STATUS_MANUAL;
		[collectionView reloadData];
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadPictureAlbum:(PhotoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		  collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)savePictureAlbum:(PhotoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage path:(NSString *)path
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showPictureImage:(PhotoMediaItem *)mediaItem Image:(UIImage *)image
		  collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	mediaItem.image = image;
	mediaItem.status = STATUS_SUCCEED;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_async(dispatch_get_main_queue(), ^{
		[collectionView reloadData];
	});
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showPictureFile:(PhotoMediaItem *)mediaItem Path:(NSString *)path
		 collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	mediaItem.image = [[UIImage alloc] initWithContentsOfFile:path];
	mediaItem.status = STATUS_SUCCEED;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_async(dispatch_get_main_queue(), ^{
		[collectionView reloadData];
	});
}

#pragma mark - Video public

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadVideo:(VideoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
   collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *path = [DownloadManager pathVideo:dbmessage.video];
	NSString *localIdentifier = [UserDefaults stringForKey:dbmessage.objectId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((path == nil) && (localIdentifier == nil))
	{
		[self loadVideoMedia:mediaItem dbmessage:dbmessage collectionView:collectionView];
	}
	else if (path != nil)
	{
		[self showVideoFile:mediaItem Path:path collectionView:collectionView];
	}
	else if (localIdentifier != nil)
	{
		[self loadVideoAlbum:mediaItem dbmessage:dbmessage collectionView:collectionView];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadVideoManual:(VideoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		 collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark - Video private

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadVideoMedia:(VideoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self downloadVideoMedia:mediaItem dbmessage:dbmessage collectionView:collectionView];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)downloadVideoMedia:(VideoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
   collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	mediaItem.status = STATUS_LOADING;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[DownloadManager video:dbmessage.video md5:dbmessage.video_md5 completion:^(NSString *path, NSError *error, BOOL network)
	{
		if (error == nil)
		{
			if (network) [Cryptor decryptFile:path groupId:dbmessage.groupId];
			//-------------------------------------------------------------------------------------------------------------------------------------
			[self showVideoFile:mediaItem Path:path collectionView:collectionView];
			//-------------------------------------------------------------------------------------------------------------------------------------
			if ([FUser autoSaveMedia]) [self saveVideoAlbum:mediaItem dbmessage:dbmessage path:path collectionView:collectionView];
		}
		else mediaItem.status = STATUS_MANUAL;
		[collectionView reloadData];
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadVideoAlbum:(VideoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)saveVideoAlbum:(VideoMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage path:(NSString *)path1
		collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showVideoFile:(VideoMediaItem *)mediaItem Path:(NSString *)path
	   collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UIImage *picture = [Video thumbnail:path];
	mediaItem.image = [Image square:picture size:320];
	mediaItem.fileURL = [NSURL fileURLWithPath:path];
	mediaItem.status = STATUS_SUCCEED;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_async(dispatch_get_main_queue(), ^{
		[collectionView reloadData];
	});
}

#pragma mark - Audio public

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadAudio:(AudioMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
   collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *path = [DownloadManager pathAudio:dbmessage.audio];
	NSString *localIdentifier = [UserDefaults stringForKey:dbmessage.objectId];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((path == nil) && (localIdentifier == nil))
	{
		[self loadAudioMedia:mediaItem dbmessage:dbmessage collectionView:collectionView];
	}
	else if (path != nil)
	{
		[self showAudioFile:mediaItem Path:path collectionView:collectionView];
	}
	else if (localIdentifier != nil)
	{
		[self loadAudioAlbum:mediaItem dbmessage:dbmessage collectionView:collectionView];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadAudioManual:(AudioMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		 collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

#pragma mark - Audio private

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadAudioMedia:(AudioMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self downloadAudioMedia:mediaItem dbmessage:dbmessage collectionView:collectionView];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)downloadAudioMedia:(AudioMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
   collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	mediaItem.status = STATUS_LOADING;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[DownloadManager audio:dbmessage.audio md5:dbmessage.audio_md5 completion:^(NSString *path, NSError *error, BOOL network)
	{
		if (error == nil)
		{
			if (network) [Cryptor decryptFile:path groupId:dbmessage.groupId];
			//-------------------------------------------------------------------------------------------------------------------------------------
			[self showAudioFile:mediaItem Path:path collectionView:collectionView];
			//-------------------------------------------------------------------------------------------------------------------------------------
			if ([FUser autoSaveMedia]) [self saveAudioAlbum:mediaItem dbmessage:dbmessage path:path collectionView:collectionView];
		}
		else mediaItem.status = STATUS_MANUAL;
		[collectionView reloadData];
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)loadAudioAlbum:(AudioMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage
		collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)saveAudioAlbum:(AudioMediaItem *)mediaItem dbmessage:(DBMessage *)dbmessage path:(NSString *)path1
		collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showAudioFile:(AudioMediaItem *)mediaItem Path:(NSString *)path
	   collectionView:(UICollectionView *)collectionView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[mediaItem setAudioDataWithUrl:[NSURL fileURLWithPath:path]];
	mediaItem.status = STATUS_SUCCEED;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_async(dispatch_get_main_queue(), ^{
		[collectionView reloadData];
	});
}

@end

