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
void PresentAudioRecorder(id target)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	IQAudioRecorderViewController *controller = [[IQAudioRecorderViewController alloc] init];
	controller.delegate = target;
	controller.title = @"Recorder";
	controller.maximumRecordDuration = AUDIO_LENGTH;
	controller.allowCropping = NO;
	[target presentBlurredAudioRecorderViewControllerAnimated:controller];
}

#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------------------------
NSString* Filename(NSString *type, NSString *ext)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	long long timestamp = [[NSDate date] timestamp];
	return [NSString stringWithFormat:@"%@/%@/%lld.%@", [FUser currentId], type, timestamp, ext];
}

