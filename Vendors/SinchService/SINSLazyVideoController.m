#import "SINSLazyVideoController.h"

#define WARN_AND_RETURN_ON_NO_PROXEE() \
if (![self proxee]) {                \
[self logNoProxeeAvailable];       \
return;                            \
}

@implementation SINSLazyVideoController

- (void)dealloc {
    if (self.proxee) {
        [self willSetProxeeToNil:self.proxee];
    }
}

- (void)willSetProxeeToNil:(id)proxee {
    if ([proxee respondsToSelector:@selector(invalidate)]) {
        [proxee invalidate];
    }
}

- (void)logNoProxeeAvailable {
    NSLog(@"WARNING: No underlying SINAudioController available");
}

#pragma mark - SINVideoController

- (UIView*) remoteView {
    if (![self proxee])
    {
        [self logNoProxeeAvailable];
        return nil;
    }
    return [self.proxee remoteView];
}

- (UIView*) localView {
    if (![self proxee])
    {
        [self logNoProxeeAvailable];
        return nil;
    }
    return [self.proxee localView];
}
@end
