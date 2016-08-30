#import "Keek.h"
#import "KeekCardView.h"
#import "KNCViewController.h"
#import "KCCIconListView.h"
#import "KCCCardListView.h"
#import <notify.h>
#import "rocketbootstrap/rocketbootstrap.h"
#import <Cephei/HBPreferences.h>
#import "CDTContextHostProvider.h"
#import <SpringBoard/SBDockIconListView.h>

HBPreferences *preferences;

///////////NOTIFICATIONCENTER GROUP//////////////

%group NC

KNCViewController *ncAppViewController;

%hook SBNotificationCenterLayoutViewController
- (void)_loadContentViewControllers{
	%orig;
	SBModeViewController* modeVC = MSHookIvar<id>(self, "_modeViewController");
	if (ncAppViewController == nil)	ncAppViewController = [[KNCViewController alloc] init];
	[modeVC _addBulletinObserverViewController:ncAppViewController];
}
%end

%hook SBModeViewController
- (void)_layoutHeaderViewIfNecessary{
	%orig;
	for (UIView *view in MSHookIvar<UIView*>(self, "_headerView").subviews)
	{
		if ([view isKindOfClass:[UISegmentedControl class]])
		{
			UISegmentedControl *segment = (UISegmentedControl*)view;
			if (segment.numberOfSegments > 2)	[segment setTitle:@"Keek" forSegmentAtIndex:2];
		}
	}
}
%end
%end
///////////NOTIFICATIONCENTER END//////////////

///////////CONTROLCENTER GROUP//////////////
%group CC

/////////////////////////////
UIScrollView *appsScrollView;
UIView *ccContextHostView;
NSString *openIdentifier;
CGPoint oldCenter;
int tries;
BOOL ccShouldReload;
/////////////////////

static CPDistributedMessagingCenter *c;
static KCCCardListView *cardListView;
static UIView *contextHostView;
static UIScrollView *musicScrollView;
static UIScrollView *quickLaunchScrollView;
static KCCIconListView *iconListView;
static SBAppSwitcherSnapshotView *appSnapshotPreview;
static BOOL isCCOpen = NO;
static UIButton *closeButton;

%hook SBControlCenterContentContainerView

- (id)initWithFrame:(struct CGRect)frame{
	self = %orig;
	container = self;
	if(self){
		SBControlCenterContentView 			 *contentView 			= MSHookIvar<SBControlCenterContentView *>(self, "_contentView");
		SBControlCenterSectionViewController *mediaControlsSection  = MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_mediaControlsSection");
		SBCCQuickLaunchSectionController 	 *quickLaunchSection 	= MSHookIvar<SBCCQuickLaunchSectionController *>(contentView, "_quickLaunchSection");

		CGSize mediaSectionSize = mediaControlsSection.view.frame.size;
		CGSize quickLaunchSectionSize = quickLaunchSection.view.frame.size;
		[mediaControlsSection.view removeFromSuperview];
		[quickLaunchSection.view removeFromSuperview];

		if(musicScrollView == nil){
			musicScrollView = [[UIScrollView alloc]initWithFrame:mediaControlsSection.view.frame];
			musicScrollView.showsVerticalScrollIndicator = NO;
			musicScrollView.showsHorizontalScrollIndicator = NO;
			musicScrollView.scrollEnabled = YES;
			musicScrollView.pagingEnabled = YES;
			musicScrollView.userInteractionEnabled = YES;
			musicScrollView.delegate = self;
			[self addSubview:musicScrollView];
		}

		if(quickLaunchScrollView == nil){
			quickLaunchScrollView = [[UIScrollView alloc]initWithFrame:quickLaunchSection.view.frame];
			quickLaunchScrollView.showsVerticalScrollIndicator = NO;
			quickLaunchScrollView.showsHorizontalScrollIndicator = NO;
			quickLaunchScrollView.scrollEnabled = YES;
			quickLaunchScrollView.pagingEnabled = YES;
			quickLaunchScrollView.userInteractionEnabled = YES;
			quickLaunchScrollView.delegate = self;
			[self addSubview:quickLaunchScrollView];
		}

		if(cardListView == nil){
			cardListView = [[KCCCardListView alloc] initWithFrame:CGRectMake(musicScrollView.frame.size.width,0,musicScrollView.frame.size.width,musicScrollView.frame.size.height)];
			[musicScrollView addSubview:cardListView];
		}

		if(iconListView == nil){
			iconListView = [[KCCIconListView alloc] initWithFrame:CGRectMake(quickLaunchSectionSize.width, 0, quickLaunchSectionSize.width, quickLaunchSectionSize.height)];
			[quickLaunchScrollView addSubview:iconListView];
		}

		if (closeButton == nil) {
			closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[closeButton setTitle:@"X" forState:UIControlStateNormal];
			[closeButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
			closeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
			[closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
			closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
			closeButton.alpha = 0.0;
			closeButton.layer.cornerRadius = 15;
			closeButton.clipsToBounds = YES;
			closeButton.userInteractionEnabled = YES;
			closeButton.tag = 961;
			[self addSubview:closeButton];
		}

	}
	return self;
}

- (void)layoutSubviews {
	%orig;

	SBControlCenterContentView *contentView = MSHookIvar<SBControlCenterContentView *>(self, "_contentView");
	SBControlCenterSectionViewController *mediaControlsSection  = MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_mediaControlsSection");
	SBControlCenterSectionViewController *brightnessSection 	= MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_brightnessSection");
	SBCCQuickLaunchSectionController 	 *quickLaunchSection 	= MSHookIvar<SBCCQuickLaunchSectionController *>(contentView, "_quickLaunchSection");
	SBControlCenterSectionViewController *airplaySection 		= MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_airplaySection");

	CGRect mediaSectionFrame = mediaControlsSection.view.frame;
	CGRect quickLaunchSectionFrame = quickLaunchSection.view.frame;
	CGRect brightnessSectionFrame = brightnessSection.view.frame;
	CGSize mediaSectionSize = mediaSectionFrame.size;
	CGSize quickLaunchSectionSize = quickLaunchSectionFrame.size;
	
	[mediaControlsSection.view removeFromSuperview];
	[musicScrollView addSubview:mediaControlsSection.view];

	[quickLaunchSection.view removeFromSuperview];
	[quickLaunchScrollView addSubview:quickLaunchSection.view];

	musicScrollView.frame = CGRectMake(brightnessSectionFrame.origin.x,brightnessSectionFrame.origin.y+brightnessSectionFrame.size.height,mediaSectionSize.width,mediaSectionSize.height);
	quickLaunchScrollView.frame = CGRectMake(airplaySection.view.frame.origin.x,airplaySection.view.frame.origin.y+airplaySection.view.frame.size.height,quickLaunchSectionSize.width,quickLaunchSectionSize.height);

	closeButton.frame = CGRectMake(0, 0, 30, 30);
	closeButton.center = CGPointMake((self.frame.size.width - ((self.frame.size.height/kScreenHeight)*self.frame.size.width))/4, self.frame.size.height * 0.5);
	
	musicScrollView.contentSize = CGSizeMake(mediaSectionSize.width*2,mediaSectionSize.height);
	mediaControlsSection.view.frame = CGRectMake(0,0,mediaSectionSize.width,mediaSectionSize.height);

	quickLaunchScrollView.contentSize = CGSizeMake(quickLaunchSectionSize.width*2,quickLaunchSectionSize.height);
	quickLaunchSection.view.frame = CGRectMake(0,0,quickLaunchSectionSize.width,quickLaunchSectionSize.height);

	cardListView.frame = CGRectMake(musicScrollView.frame.size.width,0,musicScrollView.frame.size.width,musicScrollView.frame.size.height);
	iconListView.frame = CGRectMake(quickLaunchSectionSize.width, 0, quickLaunchSectionSize.width, quickLaunchSectionSize.height);
	//[cardListView setIcons:[[KeekDataProvider sharedInstance] cachedIdentifiers]];

	if ([[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked]) {
		BKSDisplaySetSecureMode(NO);
	}

}

- (void)controlCenterDidFinishTransition{
	%orig;
	isCCOpen = YES;
	[cardListView setIcons:[[KeekDataProvider sharedInstance] cachedIdentifiers]];

	static NSMutableArray *allApps = nil;

	SBIconController *iconController = [%c(SBIconController) sharedInstance];
	SBIconViewMap *homescreenMap  = [iconController homescreenIconViewMap];
	SBIconModel *model = [homescreenMap iconModel];
	allApps = [[model visibleIconIdentifiers] mutableCopy];

	NSMutableArray *dockApps = [[NSMutableArray alloc] initWithCapacity:10];

	for (NSString *str in allApps)
	{	
		SBIcon *icon = [model expectedIconForDisplayIdentifier:str];
		SBIconView *iconView = [homescreenMap mappedIconViewForIcon:icon];
        if ([iconView isInDock]){
        	//[dockApps insertObject:str atIndex:[iconView location]];
        	[dockApps addObject:str];
        			//Alert(str,[@([iconView location]) stringValue]);
        }
    }

	[iconListView setIcons:dockApps];
	//[iconListView setIcons:@[@"com.apple.mobiletimer", @"com.apple.calculator", @"com.apple.camera", @"com.apple.Preferences", @"com.saurik.Cydia", @"net.whatsapp.WhatsApp"]];
}

-(void)controlCenterDidDismiss{
	[self closeView];
	%orig;
	if(openIdentifier) [[CDTContextHostProvider sharedInstance] stopHostingForBundleID:openIdentifier];
	openIdentifier = nil;
	isCCOpen = NO;
	musicScrollView.contentOffset = CGPointZero;
}

%new
-(void)openAppWithIdentifier:(UITapGestureRecognizer *)tap{
	KCCCardView *cardView = tap.view;
	KeekIconView *iconView = tap.view;

	NSString *identifier;

	if([tap.view isKindOfClass:[KCCCardView class]]){
		identifier = cardView.identifier;
	}else{
		identifier = iconView.identifier;
	}

	[self openAppViewWithIdentifier:identifier];
}

%new

-(void)openAppViewWithIdentifier:(NSString*)identifier{	
	SBControlCenterContentView 			 *contentView 			= MSHookIvar<SBControlCenterContentView *>(self, "_contentView");
	SBControlCenterSectionViewController *mediaControlsSection  = MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_mediaControlsSection");
	SBControlCenterSectionViewController *airplaySection 		= MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_airplaySection");
	SBCCQuickLaunchSectionController 	 *quickLaunchSection 	= MSHookIvar<SBCCQuickLaunchSectionController *>(contentView, "_quickLaunchSection");
	SBCCSettingsSectionController 		 *settingsSection 		= MSHookIvar<SBCCSettingsSectionController *>(contentView, "_settingsSection");
	SBControlCenterSectionViewController *brightnessSection 	= MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_brightnessSection");
	SBControlCenterGrabberView 			 *grabberView 			= MSHookIvar<SBControlCenterGrabberView *>(contentView, "_grabberView");

	openIdentifier = nil;
	[[CDTContextHostProvider sharedInstance] launchSuspendedApplicationWithBundleID:identifier];
	openIdentifier = identifier;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[self getContextViewForIdentifier:identifier];
	});

	appSnapshotPreview = [[[KeekDataProvider sharedInstance] snapshotsCache] objectForKey:identifier];
	[appSnapshotPreview setCornerRadius:15.0];
	[appSnapshotPreview setTransform:CGAffineTransformMakeScale(self.frame.size.height/kScreenHeight, self.frame.size.height/kScreenHeight)];
	appSnapshotPreview.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 1.5);
	appSnapshotPreview.backgroundColor = [UIColor grayColor];
	[self addSubview:appSnapshotPreview];

	[grabberView presentStatusUpdate:[%c(SBControlCenterStatusUpdate) statusUpdateWithString:[[[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:identifier] displayName] reason:@"com.irabih.keek"]];

	[UIView animateWithDuration:0.5 animations:^{
		airplaySection.view.alpha = 0;
		quickLaunchSection.view.alpha = 0;
		settingsSection.view.alpha = 0;
		brightnessSection.view.alpha = 0;
		musicScrollView.alpha = 0;
		quickLaunchScrollView.alpha = 0;
	}completion:^(BOOL finished){
	}];

	[UIView animateWithDuration:0.75 animations:^{
		appSnapshotPreview.center = contentView.center;
		closeButton.alpha = 1.0;
	}completion:^(BOOL finished){
		contextHostView.alpha = 1.0;
		grabberView.alpha = 0;
	}];
}

%new
-(void)getContextViewForIdentifier:(NSString*)identifier{

	SBControlCenterContentView *contentView = MSHookIvar<SBControlCenterContentView *>(self, "_contentView");
	[[CDTContextHostProvider sharedInstance] launchSuspendedApplicationWithBundleID:identifier];
	contextHostView = [[CDTContextHostProvider sharedInstance] hostViewForApplicationWithBundleID:identifier];

	if (!contextHostView || ![[CDTContextHostProvider sharedInstance] isHostViewHosting:contextHostView]) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			if (tries >= 5) {
				[[[UIAlertView alloc] initWithTitle:@"Keek" message:@"Unable to load app. Please open the app once then try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
				tries = 0;
				return;	
			} else {
				[self getContextViewForIdentifier:identifier];
				tries ++;
			}
		});
		return;
	}

	contextHostView.transform = CGAffineTransformMakeScale((contentView.frame.size.height - 0)/kScreenHeight, (contentView.frame.size.height - 0)/kScreenHeight);
	contextHostView.layer.cornerRadius = 15;
	contextHostView.layer.masksToBounds = YES;
	contextHostView.backgroundColor = [UIColor blackColor];
	contextHostView.center = contentView.center;//CGPointMake(contentView.frame.size.width * 0.5, (contentView.frame.size.height * 0.5));
	contextHostView.alpha = 0.0;
	[self addSubview:contextHostView];
}

%new
-(void)launchAppWithIdentifier:(UITapGestureRecognizer *)tap{
	KCCCardView *cardView = tap.view;
	KeekIconView *iconView = tap.view;

	NSString *identifier;

	if([tap.view isKindOfClass:[KCCCardView class]]){
		identifier = cardView.identifier;
	}else{
		identifier = iconView.identifier;
	}

	[[NSClassFromString(@"SBUIController") sharedInstance] activateApplication:[[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:identifier]];
}

%new
-(void)closeView {

	[appSnapshotPreview removeFromSuperview];
	appSnapshotPreview = nil;
	[cardListView setIcons:[[KeekDataProvider sharedInstance] cachedIdentifiers]];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		if(openIdentifier) [[CDTContextHostProvider sharedInstance] stopHostingForBundleID:openIdentifier];
	});


	SBControlCenterContentView 			 *contentView 			= MSHookIvar<SBControlCenterContentView *>(self, "_contentView");
	SBControlCenterSectionViewController *mediaControlsSection  = MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_mediaControlsSection");
	SBControlCenterSectionViewController *airplaySection 		= MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_airplaySection");
	SBCCQuickLaunchSectionController 	 *quickLaunchSection 	= MSHookIvar<SBCCQuickLaunchSectionController *>(contentView, "_quickLaunchSection");
	SBCCSettingsSectionController 		 *settingsSection 		= MSHookIvar<SBCCSettingsSectionController *>(contentView, "_settingsSection");
	SBControlCenterSectionViewController *brightnessSection 	= MSHookIvar<SBControlCenterSectionViewController *>(contentView, "_brightnessSection");
	SBControlCenterGrabberView 			 *grabberView 			= MSHookIvar<SBControlCenterGrabberView *>(contentView, "_grabberView");
	
	[UIView animateWithDuration:0.65 animations:^{
		closeButton.alpha = 0.0;
		contextHostView.alpha = 0.0;
		airplaySection.view.alpha = 1.0;
		quickLaunchSection.view.alpha = 1.0;
		settingsSection.view.alpha = 1.0;
		brightnessSection.view.alpha = 1.0;
		grabberView.alpha = 1.0;
		musicScrollView.alpha = 1.0;
		quickLaunchScrollView.alpha = 1.0;
		contextHostView.alpha = 0.0;
	}completion:^(BOOL finished){
		[contextHostView removeFromSuperview];
		contextHostView = nil;
	}];
}

%end
%end

%group NormalControlCenter
%hook SBCCButtonController

-(void)buttonTapped:(SBControlCenterButton*)tapped{
	NSString *buttonID = tapped.identifier;
	[self _updateButtonState];

	if([buttonID isEqualToString:@"com.apple.mobiletimer"]){
		[container openAppViewWithIdentifier:@"com.apple.mobiletimer"];
	}else if([buttonID isEqualToString:@"com.apple.calculator"]){
		[container openAppViewWithIdentifier:@"com.apple.calculator"];
	}else if([buttonID isEqualToString:@"com.apple.camera"]){
		[container openAppViewWithIdentifier:@"com.apple.camera"];
	}else{
		%orig;
	}
}

%end
%end

%group FlipControlCenter
%hook _FSSwitchButton

- (void)_pressed
{
	NSString *switchIdentifier = MSHookIvar<NSString *>(self, "switchIdentifier");
	if(isCCOpen){
		if ([switchIdentifier isEqualToString:@"com.rpetrich.flipcontrolcenter.clock"]) {
			[container openAppViewWithIdentifier:@"com.apple.mobiletimer"];
		}else if([switchIdentifier isEqualToString:@"com.rpetrich.flipcontrolcenter.calculator"]){
			[container openAppViewWithIdentifier:@"com.apple.calculator"];
		}else if([switchIdentifier isEqualToString:@"com.rpetrich.flipcontrolcenter.camera"]){
			[container openAppViewWithIdentifier:@"com.apple.camera"];
		}else if([switchIdentifier isEqualToString:@"com.a3tweaks.switch.settings"]){
			[container openAppViewWithIdentifier:@"com.apple.Preferences"];
		}else{
			%orig;
		}
	}else{
		%orig;
	}
}

%end
%end
///////////CONTROLCENTER END//////////////

///////////KEEK GROUP//////////////
%group Keek
%hook SBUIController
- (void)finishLaunching {
	%orig;
	//BKSDisplaySetSecureMode(YES);
}
%end

%hook SBApplication

-(void)updateProcessState:(id)arg1{
	%orig;
	[ncAppViewController setShouldReload];
}

%end
%end
///////////KEEK END//////////////

%ctor{

	dlopen("/Library/MobileSubstrate/DynamicLibraries/Keek2Client.dylib", RTLD_LAZY);

	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.irabih.keek"];

	[preferences registerDefaults:@{
		@"Enabled": @YES,
	}];

	BOOL enabled = [preferences boolForKey:@"Enabled"];

	if(enabled){
		%init(CC);
		%init(NC);
		%init(Keek);

		if (dlopen("/Library/MobileSubstrate/DynamicLibraries/FlipControlCenter.dylib", RTLD_LAZY) && dlopen("/Library/MobileSubstrate/DynamicLibraries/Flipswitch.dylib", RTLD_LAZY)){
			%init(FlipControlCenter);
		}else{
			%init(NormalControlCenter);
		}
	}

	[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"Keek2PreferencesObserver" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		//BOOL enabledChanged = ((NSNumber *)notification.userInfo[@"Enabled"]).boolValue;
		Alert(@"Test",@"The Test");
	}];

}
