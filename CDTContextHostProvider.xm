#import "CDTContextHostProvider.h"

@implementation CDTContextHostProvider

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (id)init {
	if ((self = [super init])) {
		_hostedApplications = [[NSMutableDictionary alloc] init];
		_currentAppHasFinishedLaunching = NO;
	}
	return self;
}

- (UIView *)hostViewForApplication:(SBApplication*)sbapplication {
	NSString* bundleIdentifier = sbapplication.bundleIdentifier;

	if ([_hostedApplications objectForKey:bundleIdentifier]) {
		return [_hostedApplications objectForKey:bundleIdentifier];
	}
	[self enableBackgroundingForApplication:sbapplication];
	[self launchSuspendedApplicationWithBundleID:[(SBApplication *)sbapplication bundleIdentifier]];
	[[self contextManagerForApplication:sbapplication] enableHostingForRequester:[(SBApplication *)sbapplication bundleIdentifier] orderFront:YES];
	UIView *hostView = [[self contextManagerForApplication:sbapplication] hostViewForRequester:[(SBApplication *)sbapplication bundleIdentifier] enableAndOrderFront:YES];
	hostView.accessibilityHint = bundleIdentifier;
	return hostView;
}

- (NSString*)bundleIDFromHostView:(UIView*)hostView {
	return hostView.accessibilityHint;
}

- (UIView *)hostViewForApplicationWithBundleID:(NSString *)bundleID {
	SBApplication *appToHost = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
	return [self hostViewForApplication:appToHost];
}

- (void)launchSuspendedApplicationWithBundleID:(NSString *)bundleID {
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleID suspended:YES];
}

- (void)disableBackgroundingForApplication:(id)sbapplication {
	FBSMutableSceneSettings *sceneSettings = [self sceneSettingsForApplication:sbapplication];
	[sceneSettings setBackgrounded:YES];
	[[self FBSceneForApplication:sbapplication] _applyMutableSettings:sceneSettings withTransitionContext:nil completion:nil];

}

- (void)enableBackgroundingForApplication:(id)sbapplication {
	FBSMutableSceneSettings *sceneSettings = [self sceneSettingsForApplication:sbapplication];
	[sceneSettings setBackgrounded:NO];
	[[self FBSceneForApplication:sbapplication] _applyMutableSettings:sceneSettings withTransitionContext:nil completion:nil];
}

- (FBScene *)FBSceneForApplication:(id)sbapplication {
	return [(SBApplication *)sbapplication mainScene];
}

- (FBWindowContextHostManager *)contextManagerForApplication:(id)sbapplication {
	return [[self FBSceneForApplication:sbapplication] contextHostManager];
}

- (FBSMutableSceneSettings *)sceneSettingsForApplication:(id)sbapplication {
	return [[[self FBSceneForApplication:sbapplication] mutableSettings] mutableCopy];
}

- (BOOL)isHostViewHosting:(UIView *)hostView {
    if (hostView && [[hostView subviews] count] >= 1)
        return [(FBWindowContextHostView *)[hostView subviews][0] isHosting];
    return NO;
}

- (void)forceRehostingOnBundleID:(NSString *)bundleID {
    SBApplication *appToForce = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
    [self launchSuspendedApplicationWithBundleID:bundleID];
    [self enableBackgroundingForApplication:appToForce];
    FBWindowContextHostManager *manager = [self contextManagerForApplication:appToForce];
    [manager enableHostingForRequester:bundleID priority:1];
}

- (void)stopHostingForBundleID:(NSString *)bundleID {
	SBApplication *appToHost = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
	FBWindowContextHostManager *contextManager = [self contextManagerForApplication:appToHost];
	[contextManager disableHostingForRequester:bundleID];
    [self disableBackgroundingForApplication:appToHost];
    [_hostedApplications removeObjectForKey:bundleID];
}

- (void)sendLandscapeRotationNotificationToBundleID:(NSString *)bundleID {
	NSString *rotateNotification = [NSString stringWithFormat:@"%@LamoLandscapeRotate", bundleID];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)rotateNotification, NULL, NULL, YES);
}

- (void)sendPortraitRotationNotificationToBundleID:(NSString *)bundleID {
	NSString *rotateNotification = [NSString stringWithFormat:@"%@LamoPortraitRotate", bundleID];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)rotateNotification, NULL, NULL, YES);
}

- (void)setStatusBarHidden:(NSNumber *)hidden onApplicationWithBundleID:(NSString *)bundleID {
    NSString *changeStatusBarNotification = [NSString stringWithFormat:@"%@LamoStatusBarChange", bundleID];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)changeStatusBarNotification, NULL, (__bridge CFDictionaryRef) @{@"isHidden" : hidden } , YES);
}

@end
