#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kScreenScale            kScreenHeight/kScreenWidth
#define kCardViewIconSize       40
#define kSettingsPath 			[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.irabih.keek.plist"]
#define kSettingsChanged 		"com.irabih.keek/ReloadPrefs"
#define Alert(TITLE,MSG) 		[[[UIAlertView alloc] initWithTitle:(TITLE) message:(MSG) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]

#if __cplusplus
extern "C" {
#endif
	void BKSDisplaySetSecureMode(bool onOff);
#if __cplusplus
}
#endif

@interface UIImage (Private)
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(NSInteger)format scale:(CGFloat)scale;
- (UIImage *)_imageScaledToProportion:(CGFloat)proportion interpolationQuality:(CGInterpolationQuality)quality;
@end

@interface CPDistributedMessagingCenter : NSObject
+ (CPDistributedMessagingCenter *)centerNamed:(NSString *)name;
- (void)runServerOnCurrentThread;
- (void)registerForMessageName:(NSString *)name target:(id)target selector:(SEL)selector;
- (void)sendMessageName:(NSString *)message userInfo:(NSDictionary *)userInfo;
- (NSDictionary *)sendMessageAndReceiveReplyName:(NSString *)reply userInfo:(NSDictionary *)dictionary;
@end

@interface SBChevronView : UIView
@property (assign,nonatomic) long long state;
- (void) setState:(int)state animated:(BOOL)animated;
- (void)setBackgroundView:(id)arg1;
@end

@interface SBControlCenterStatusUpdate : NSObject
+(id)statusUpdateWithString:(NSString*)string reason:(NSString*)reason;
@end

@interface SBControlCenterGrabberView : UIView
-(SBChevronView*) chevronView;
- (void)_setStatusState:(int)arg1;
-(void)presentStatusUpdate:(SBControlCenterStatusUpdate*) statusUpdate;
@end

@interface SBControlCenterSectionViewController : UIViewController
@end

@interface SBCCQuickLaunchSectionController : UIViewController
@end

@interface SBCCSettingsSectionController : UIViewController
@end

@interface SBControlCenterContentView: UIView <UIScrollViewDelegate>
@property(retain, nonatomic) SBControlCenterSectionViewController *mediaControlsSection;
@property(retain, nonatomic) SBControlCenterSectionViewController *brightnessSection;
- (void)controlCenterDidFinishTransition;
- (void)controlCenterWillBeginTransition;
- (void)controlCenterDidDismiss;
- (void)controlCenterWillPresent;
- (void)layoutSubviews;
- (void)dealloc;
- (id)initWithFrame:(struct CGRect)arg1;
- (SBControlCenterGrabberView*)grabberView;
@end

@interface SBControlCenterContentContainerView : UIView <UIScrollViewDelegate>
-(void)getContextViewForIdentifier:(NSString*)identifier;
-(void)openAppWithIdentifier:(UITapGestureRecognizer *)tap;
-(void)getContextViewForIdentifier:(NSString*)identifier;
-(void)longPressTap:(UIGestureRecognizer*)recognizer;
-(void)closeView;
-(void)openAppViewWithIdentifier:(NSString*)identifier;
-(CGRect)frameForCardAtIndex:(int)index;
@end

@interface SBControlCenterButton : UIButton {
	NSString* _identifier;
	NSNumber* _sortKey;
}
@property(copy, nonatomic) NSNumber* sortKey;
@property(copy, nonatomic) NSString* identifier;
-(void)dealloc;
@end

@interface SBCCButtonController : NSObject
- (void)animateScrollView;
-(void)_updateButtonState;
@end

@interface SBControlCenterViewController : UIViewController
-(id)view;
-(void)dealloc;
-(id)init;
@end

@interface SBDeviceLockController : NSObject
+ (SBDeviceLockController *)sharedController;
- (BOOL)isPasscodeLocked;
@end

@interface SBNotificationCenterViewController <UITextFieldDelegate>
-(id)_newBulletinObserverViewControllerOfClass:(Class)aClass;
@end

@interface SBNotificationCenterLayoutViewController
+ (id)sharedInstance;
- (void)_loadContentViewControllers;
@end

@interface SBModeViewController
- (void)_addBulletinObserverViewController:(id)arg1;
- (void)addViewController:(id)arg1;
- (void)addHeaderText;
- (void)removeViewController:(id)arg1;
@end

@interface SBMainSwitcherGestureCoordinator : NSObject
+ (id)sharedInstance;
- (void)_releaseOrientationLock;
- (void)_lockOrientation;
@end

@interface SBSwitcherSnapshotImageView : UIView
@property (nonatomic,retain,readonly) UIImage * image;
-(UIImage *)image;
@end

@interface _SBAppSwitcherSnapshotContext : NSObject
@property (nonatomic,retain) SBSwitcherSnapshotImageView * snapshotImageView;
-(SBSwitcherSnapshotImageView *)snapshotImageView;
@end

@interface SBOrientationLockManager : NSObject
{
 NSMutableSet *_lockOverrideReasons;
 long long _userLockedOrientation;
}

+ (id)sharedInstance;
- (_Bool)_effectivelyLocked;
- (void)_updateLockStateWithOrientation:(long long)arg1 forceUpdateHID:(_Bool)arg2 changes:(id/*block*/)arg3;
- (void)_updateLockStateWithChanges:(id/*block*/)arg1;
- (void)updateLockOverrideForCurrentDeviceOrientation;
- (_Bool)lockOverrideEnabled;
- (void)enableLockOverrideForReason:(id)arg1 forceOrientation:(long long)arg2;
- (void)enableLockOverrideForReason:(id)arg1 suggestOrientation:(long long)arg2;
- (void)setLockOverrideEnabled:(_Bool)arg1 forReason:(id)arg2;
- (long long)userLockOrientation;
- (_Bool)isLocked;
- (void)unlock;
- (void)lock:(long long)arg1;
- (void)lock;
- (void)dealloc;
- (id)init;
- (void)restoreStateFromPrefs;

@end

@interface SBMedusaSettings : NSObject
{
 _Bool _enableSideApps;
 _Bool _enableBreadcrumbs;
 _Bool _enablePinningSideApps;
 _Bool _debugSceneColors;
 _Bool _debugRotationCenter;
 _Bool _debugColorRotationRegions;
 _Bool _clipRotationRegions;
 _Bool _fencesRotation;
 NSString *_desiredBundleIdentifier;
 double _zoomOutRotationFactor;
 double _rotationSlowdownFactor;
 double _spaceAroundSideGrabberToAllowPullIn;
 unsigned long long _millisecondsBetweenResizeSteps;
 double _slideOffResizeThreshold;
 double _gapSwipeBuffer;
}

+ (id)settingsControllerModule;
@property(nonatomic) double gapSwipeBuffer; // @synthesize gapSwipeBuffer=_gapSwipeBuffer;
@property(nonatomic) double slideOffResizeThreshold; // @synthesize slideOffResizeThreshold=_slideOffResizeThreshold;
@property(nonatomic) unsigned long long millisecondsBetweenResizeSteps; // @synthesize millisecondsBetweenResizeSteps=_millisecondsBetweenResizeSteps;
@property(nonatomic) _Bool fencesRotation; // @synthesize fencesRotation=_fencesRotation;
@property(nonatomic) double spaceAroundSideGrabberToAllowPullIn; // @synthesize spaceAroundSideGrabberToAllowPullIn=_spaceAroundSideGrabberToAllowPullIn;
@property(nonatomic) double rotationSlowdownFactor; // @synthesize rotationSlowdownFactor=_rotationSlowdownFactor;
@property(nonatomic) double zoomOutRotationFactor; // @synthesize zoomOutRotationFactor=_zoomOutRotationFactor;
@property(nonatomic) _Bool clipRotationRegions; // @synthesize clipRotationRegions=_clipRotationRegions;
@property(nonatomic) _Bool debugColorRotationRegions; // @synthesize debugColorRotationRegions=_debugColorRotationRegions;
@property(nonatomic) _Bool debugRotationCenter; // @synthesize debugRotationCenter=_debugRotationCenter;
@property(nonatomic) _Bool debugSceneColors; // @synthesize debugSceneColors=_debugSceneColors;
@property(copy, nonatomic) NSString *desiredBundleIdentifier; // @synthesize desiredBundleIdentifier=_desiredBundleIdentifier;
@property(nonatomic) _Bool enablePinningSideApps; // @synthesize enablePinningSideApps=_enablePinningSideApps;
@property(nonatomic) _Bool enableBreadcrumbs; // @synthesize enableBreadcrumbs=_enableBreadcrumbs;
@property(nonatomic) _Bool enableSideApps; // @synthesize enableSideApps=_enableSideApps;
- (_Bool)anyRotationDebuggingEnabled;
- (void)setDefaultValues;

@end

@interface SBToAppsWorkspaceTransaction : NSObject
-(NSArray*) toApplications;
@end

@interface SBFWallpaperView : UIView
- (void)setGeneratesBlurredImages:(BOOL)arg1;
- (void)_startGeneratingBlurredImages;
- (void)prepareToAppear;
@end

@interface SBControlCenterController : UIViewController
+ (id)sharedInstance;
@property(nonatomic, getter=isPresented) _Bool presented; // @synthesize presented=_presented;
@property(nonatomic, getter=isUILocked) _Bool UILocked; // @synthesize UILocked=_uiLocked;
- (void)dismissAnimated:(_Bool)arg1;
- (void)presentAnimated:(_Bool)arg1;
- (void)presentAnimated:(_Bool)arg1 completion:(id)arg2;
- (void)hideGrabberAnimated:(_Bool)arg1 completion:(id)arg2;
- (void)hideGrabberAnimated:(_Bool)arg1;
- (void)showGrabberAnimated:(_Bool)arg1;
- (void)preventDismissalOnLock:(_Bool)arg1 forReason:(id)arg2;
- (void)_dismissOnLock;
- (void)_uiRelockedNotification:(id)arg1;
- (void)_lockStateChangedNotification:(id)arg1;
- (_Bool)isGrabberVisible;
- (_Bool)isPresentingControllerTransitioning;
- (_Bool)isVisible;
- (void)loadView;
- (_Bool)handleMenuButtonTap;
- (void)removeObserver:(id)arg1;
- (void)addObserver:(id)arg1;
- (_Bool)isAvailableWhileLocked;

// iOS 9
- (_Bool)_shouldShowGrabberOnFirstSwipe;
@end

@interface BKSProcess : NSObject { //BSBaseXPCClient  {
 int _pid;
 NSString *_bundlePath;
 bool _workspaceLocked;
 bool _connectedToExternalAccessories;
 bool _nowPlayingWithAudio;
 bool _recordingAudio;
 bool _supportsTaskSuspension;
 int _visibility;
 int _taskState;
 NSObject *_delegate;
 long long _terminationReason;
 long long _exitStatus;
}

@property (nonatomic, weak) NSObject * delegate;
@property int visibility;
@property long long terminationReason;
@property long long exitStatus;
@property bool workspaceLocked;
@property bool connectedToExternalAccessories;
@property bool nowPlayingWithAudio;
@property bool recordingAudio;
@property bool supportsTaskSuspension;
@property int taskState;
@property(readonly) double backgroundTimeRemaining;

+ (id)busyExtensionInstances:(id)arg1;
+ (void)setTheSystemApp:(int)arg1 identifier:(id)arg2;
+ (double)backgroundTimeRemaining;

- (void)setVisibility:(int)arg1;
- (int)visibility;
- (void)_sendMessageType:(int)arg1 withMessage:(id)arg2 withReplyHandler:(id)arg3 waitForReply:(bool)arg4;
- (long long)exitStatus;
- (id)initWithPID:(int)arg1 bundlePath:(id)arg2 visibility:(int)arg3 workspaceLocked:(bool)arg4 queue:(id)arg5;
- (bool)supportsTaskSuspension;
- (void)setTerminationReason:(long long)arg1;
- (void)setConnectedToExternalAccessories:(bool)arg1;
- (void)setNowPlayingWithAudio:(bool)arg1;
- (void)setRecordingAudio:(bool)arg1;
- (void)setWorkspaceLocked:(bool)arg1;
- (void)setTaskState:(int)arg1;
- (void)queue_connectionWasCreated;
- (void)queue_connectionWasInterrupted;
- (void)queue_handleMessage:(id)arg1;
- (bool)recordingAudio;
- (bool)nowPlayingWithAudio;
- (bool)connectedToExternalAccessories;
- (bool)workspaceLocked;
- (void)setExitStatus:(long long)arg1;
- (void)_handleDebuggingStateChanged:(id)arg1;
- (void)_handleExpirationWarning:(id)arg1;
- (void)_handleSuspendedStateChanged:(id)arg1;
- (void)_sendMessageType:(int)arg1 withMessage:(id)arg2;
- (int)taskState;
- (double)backgroundTimeRemaining;
- (void)setSupportsTaskSuspension:(bool)arg1;
- (id)delegate;
- (id)init;
- (void)setDelegate:(NSObject*)arg1;
- (void)dealloc;
- (long long)terminationReason;
@end

@interface SBAppSwitcherSnapshotView : UIView
- (void)_loadSnapshotAsyncPreferringDownscaled:(_Bool)arg1;
-(double)cornerRadius;
-(void)_loadSnapshotSync;
-(void)setCornerRadius:(double)arg1 ;
+ (id)appSwitcherSnapshotViewForDisplayItem:(id)arg1 orientation:(long long)arg2 preferringDownscaledSnapshot:(_Bool)arg3 loadAsync:(_Bool)arg4 withQueue:(dispatch_queue_t )arg5;
@end

@interface _SBFVibrantSettings : NSObject
{
 int _style;
 UIColor *_referenceColor;
 id _legibilitySettings; // _UILegibilitySettings *_legibilitySettings;
 float _referenceContrast;
 UIColor *_tintColor;
 UIColor *_shimmerColor;
 UIColor *_chevronShimmerColor;
 UIColor *_highlightColor;
 UIColor *_highlightLimitingColor;
}

+ (id)vibrantSettingsWithReferenceColor:(id)arg1 referenceContrast:(float)arg2 legibilitySettings:(id)arg3;
@property(retain, nonatomic) UIColor *highlightLimitingColor; // @synthesize highlightLimitingColor=_highlightLimitingColor;
@property(retain, nonatomic) UIColor *highlightColor; // @synthesize highlightColor=_highlightColor;
@property(retain, nonatomic) UIColor *chevronShimmerColor; // @synthesize chevronShimmerColor=_chevronShimmerColor;
@property(retain, nonatomic) UIColor *shimmerColor; // @synthesize shimmerColor=_shimmerColor;
@property(retain, nonatomic) UIColor *tintColor; // @synthesize tintColor=_tintColor;
@property(readonly, nonatomic) float referenceContrast; // @synthesize referenceContrast=_referenceContrast;
//@property(readonly, nonatomic) _UILegibilitySettings *legibilitySettings; // @synthesize legibilitySettings=_legibilitySettings;
@property(readonly, nonatomic) UIColor *referenceColor; // @synthesize referenceColor=_referenceColor;
@property(readonly, nonatomic) int style; // @synthesize style=_style;
- (id)highlightLimitingViewWithFrame:(struct CGRect)arg1;
- (id)tintViewWithFrame:(struct CGRect)arg1;
- (id)_computeSourceColorDodgeColorForDestinationColor:(id)arg1 producingLuminanceChange:(float)arg2;
- (int)_style;
- (unsigned int)hash;
- (BOOL)isEqual:(id)arg1;
- (void)dealloc;
- (id)initWithReferenceColor:(id)arg1 referenceContrast:(float)arg2 legibilitySettings:(id)arg3;

@end

typedef struct {
 BOOL itemIsEnabled[25];
 char timeString[64];
 int gsmSignalStrengthRaw;
 int gsmSignalStrengthBars;
 char serviceString[100];
 char serviceCrossfadeString[100];
 char serviceImages[2][100];
 char operatorDirectory[1024];
 unsigned serviceContentType;
 int wifiSignalStrengthRaw;
 int wifiSignalStrengthBars;
 unsigned dataNetworkType;
 int batteryCapacity;
 unsigned batteryState;
 char batteryDetailString[150];
 int bluetoothBatteryCapacity;
 int thermalColor;
 unsigned thermalSunlightMode : 1;
 unsigned slowActivity : 1;
 unsigned syncActivity : 1;
 char activityDisplayId[256];
 unsigned bluetoothConnected : 1;
 unsigned displayRawGSMSignal : 1;
 unsigned displayRawWifiSignal : 1;
 unsigned locationIconType : 1;
 unsigned quietModeInactive : 1;
 unsigned tetheringConnectionCount;
} StatusBarData;

@interface UIStatusBar : UIView
+ (CGFloat)heightForStyle:(int)arg1 orientation:(int)arg2;
- (void)setOrientation:(int)arg1;
- (void)requestStyle:(int)arg1;
-(void) forceUpdateToData:(StatusBarData*)arg1 animated:(BOOL)arg2;
@end

@interface UIStatusBarServer
+(StatusBarData*) getStatusBarData;
@end

@interface SBNotificationCenterController : NSObject
+(id) sharedInstance;
-(void)dismissAnimated:(BOOL)arg1 completion:(/*^block*/id)arg2 ;
+(id)sharedInstanceIfExists;
-(BOOL) isVisible;
@end

@interface UIStatusBarItem : NSObject
-(NSString*)indicatorName;
@end

@interface UIScreen (ohBoy)
-(CGRect) _referenceBounds;
- (CGPoint)convertPoint:(CGPoint)arg1 toCoordinateSpace:(id)arg2;
+ (CGPoint)convertPoint:(CGPoint)arg1 toView:(id)arg2;
@end

@interface UIAutoRotatingWindow : UIWindow
- (instancetype)_initWithFrame:(CGRect)arg1 attached:(BOOL)arg2;
- (void)updateForOrientation:(UIInterfaceOrientation)arg1;
@end

@interface LSApplicationProxy
+ (id)applicationProxyForIdentifier:(id)arg1;
- (NSArray*) UIBackgroundModes;
@property (nonatomic, readonly) NSURL *appStoreReceiptURL;
@property (nonatomic, readonly) NSURL *bundleContainerURL;
@property (nonatomic, readonly) NSURL *bundleURL;
@end

@interface UIViewController ()
- (void)setInterfaceOrientation:(UIInterfaceOrientation)arg1;
- (void)_setInterfaceOrientationOnModalRecursively:(int)arg1;
- (void)_updateInterfaceOrientationAnimated:(BOOL)arg1;
@end

@interface SBWallpaperController
+(id) sharedInstance;
-(void) beginRequiringWithReason:(NSString*)reason;
-(void) endRequiringWithReason:(NSString*)reason;
@end

@interface BBAction
+ (id)actionWithCallblock:(id /* block */)arg1;
+ (id)actionWithTextReplyCallblock:(id)arg1;
+ (id)actionWithLaunchBundleID:(id)arg1 callblock:(id)arg2;
+ (id)actionWithLaunchURL:(id)arg1 callblock:(id)arg2;
+ (id)actionWithCallblock:(id)arg1;
@end

typedef enum
{
 NSNotificationSuspensionBehaviorDrop = 1,
 NSNotificationSuspensionBehaviorCoalesce = 2,
 NSNotificationSuspensionBehaviorHold = 3,
 NSNotificationSuspensionBehaviorDeliverImmediately = 4
} NSNotificationSuspensionBehavior;

@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(NSString *)notificationSender suspensionBehavior:(NSNotificationSuspensionBehavior)suspendedDeliveryBehavior;
- (void)removeObserver:(id)notificationObserver name:(NSString *)notificationName object:(NSString *)notificationSender;
- (void)postNotificationName:(NSString *)notificationName object:(NSString *)notificationSender userInfo:(NSDictionary *)userInfo deliverImmediately:(BOOL)deliverImmediately;
@end

@interface SBLockStateAggregator
-(void) _updateLockState;
-(BOOL) hasAnyLockState;
@end

@interface BBBulletinRequest : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *sectionID;
@property (nonatomic, copy) BBAction *defaultAction;
@property (nonatomic, copy) NSDate *date;

@property(copy) BBAction * acknowledgeAction;
@property(copy) BBAction * replyAction;

@property(retain) NSDate * expirationDate;
@end

@interface SBBulletinBannerController : NSObject
+ (SBBulletinBannerController *)sharedInstance;
- (void)observer:(id)observer addBulletin:(BBBulletinRequest *)bulletin forFeed:(int)feed;
-(void) observer:(id)observer addBulletin:(BBBulletinRequest*) bulletin forFeed:(int)feed playLightsAndSirens:(BOOL)guess1 withReply:(id)guess2;
@end

@interface SBAppSwitcherWindow : UIWindow
@end

@interface SBAppSwitcherController
- (void)forceDismissAnimated:(_Bool)arg1;
- (void)animateDismissalToDisplayLayout:(id)arg1 withCompletion:(id/*block*/)arg2;
- (void)animatePresentationFromDisplayLayout:(id)arg1 withViews:(id)arg2 withCompletion:(id/*block*/)arg3;
@property(nonatomic, copy) NSObject *startingDisplayLayout; // @synthesize startingDisplayLayout=_startingDisplayLayout;
- (void)switcherWasPresented:(_Bool)arg1;
@end

@interface SBUIController : NSObject
+(id) sharedInstance;
+ (id)_zoomViewWithSplashboardLaunchImageForApplication:(id)arg1 sceneID:(id)arg2 screen:(id)arg3 interfaceOrientation:(long long)arg4 includeStatusBar:(_Bool)arg5 snapshotFrame:(struct CGRect *)arg6;
-(id) switcherController;
- (id)_appSwitcherController;
-(void) activateApplicationAnimated:(id)app;
- (id)switcherWindow;
- (void)_animateStatusBarForSuspendGesture;
- (void)_showControlCenterGestureCancelled;
- (void)_showControlCenterGestureFailed;
- (void)_hideControlCenterGrabber;
- (void)_showControlCenterGestureEndedWithLocation:(CGPoint)arg1 velocity:(CGPoint)arg2;
- (void)_showControlCenterGestureChangedWithLocation:(CGPoint)arg1 velocity:(CGPoint)arg2 duration:(CGFloat)arg3;
- (void)_showControlCenterGestureBeganWithLocation:(CGPoint)arg1;
- (void)restoreContentUpdatingStatusBar:(_Bool)arg1;
-(void) restoreContentAndUnscatterIconsAnimated:(BOOL)arg1;
- (_Bool)shouldShowControlCenterTabControlOnFirstSwipe;- (_Bool)isAppSwitcherShowing;
-(BOOL) _activateAppSwitcher;
- (void)_releaseTransitionOrientationLock;
- (void)_releaseSystemGestureOrientationLock;
- (void)releaseSwitcherOrientationLock;
- (void)_lockOrientationForSwitcher;
- (void)_lockOrientationForSystemGesture;
- (void)_lockOrientationForTransition;
- (void)_dismissSwitcherAnimated:(_Bool)arg1;
- (void)dismissSwitcherAnimated:(_Bool)arg1;
- (void)_dismissAppSwitcherImmediately;
- (void)dismissSwitcherForAlert:(id)arg1;

- (void)activateApplication:(id)arg1;
@end

@interface SBDisplayItem : NSObject <NSCopying>
+ (id)displayItemWithType:(NSString *)arg1 displayIdentifier:(id)arg2;
- (id)initWithType:(NSString *)arg1 displayIdentifier:(id)arg2;
@property(readonly, nonatomic) NSString *displayIdentifier; // @synthesize displayIdentifier=_displayIdentifier;
@property(readonly, nonatomic) NSString *type; // @synthesize type=_type;
@end

@interface SBLockScreenManager
+(id) sharedInstance;
-(BOOL) isUILocked;
@end

@interface BKSWorkspace : NSObject
- (NSString *)topActivatingApplication;
@end

typedef struct {
 int type;
 int modifier;
 NSUInteger pathIndex;
 NSUInteger pathIdentity;
 CGPoint location;
 CGPoint previousLocation;
 CGPoint unrotatedLocation;
 CGPoint previousUnrotatedLocation;
 double totalDistanceTraveled;
 UIInterfaceOrientation interfaceOrientation;
 UIInterfaceOrientation previousInterfaceOrientation;
 double timestamp;
 BOOL isValid;
} SBActiveTouch;

typedef NS_ENUM(NSInteger, UIScreenEdgePanRecognizerType) {
 UIScreenEdgePanRecognizerTypeMultitasking,
 UIScreenEdgePanRecognizerTypeNavigation,
 UIScreenEdgePanRecognizerTypeOther
};

@protocol _UIScreenEdgePanRecognizerDelegate;

@interface _UIScreenEdgePanRecognizer : NSObject
- (id)initWithType:(UIScreenEdgePanRecognizerType)type;
- (void)incorporateTouchSampleAtLocation:(CGPoint)location timestamp:(double)timestamp modifier:(NSInteger)modifier interfaceOrientation:(UIInterfaceOrientation)orientation;
- (void)incorporateTouchSampleAtLocation:(CGPoint)location timestamp:(double)timestamp modifier:(NSInteger)modifier interfaceOrientation:(UIInterfaceOrientation)orientation forceState:(int)arg5;
- (void)reset;
@property (nonatomic, assign) id <_UIScreenEdgePanRecognizerDelegate> delegate;
@property (nonatomic, readonly) NSInteger state;
@property (nonatomic) UIRectEdge targetEdges;
@property (nonatomic) CGRect screenBounds;
@end

@protocol _UIScreenEdgePanRecognizerDelegate <NSObject>
@optional
- (void)screenEdgePanRecognizerStateDidChange:(_UIScreenEdgePanRecognizer *)screenEdgePanRecognizer;
@end

@interface UIDevice (UIDevicePrivate)
- (void)setOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
@end

@interface _UIBackdropViewSettings : NSObject
@property (nonatomic) CGFloat grayscaleTintAlpha;
@property (nonatomic) CGFloat grayscaleTintLevel;
- (void)setBlurQuality:(id)arg1;
+ (id)settingsForStyle:(int)arg1;
+ (id)settingsForStyle:(int)arg1 graphicsQuality:(int)arg2;
- (void)setBlurRadius:(CGFloat)arg1;
@end

@interface _UIBackdropView : UIView
@property (retain, nonatomic) _UIBackdropViewSettings *outputSettings;
@property (retain, nonatomic) _UIBackdropViewSettings *inputSettings;
@property (nonatomic) int blurHardEdges;
- (void) setBlursWithHardEdges:(BOOL)arg1;
- (void)setBlurQuality:(id)arg1;
-(void) setBlurRadius:(CGFloat)radius;
-(void) setBlurRadiusSetOnce:(BOOL)v;
-(id) initWithStyle:(NSInteger)style;
@property (nonatomic) BOOL autosizesToFitSuperview;
@property (nonatomic) BOOL blursBackground;
- (void)_setBlursBackground:(BOOL)arg1;
- (void)setBlurFilterWithRadius:(float)arg1 blurQuality:(id)arg2 blurHardEdges:(int)arg3;
@end

@interface FBWorkspaceEvent : NSObject
+ (instancetype)eventWithName:(NSString *)label handler:(id)handler;
@end

@interface FBSceneManager : NSObject
@end

@interface SBWorkspaceApplicationTransitionContext : NSObject
@property(nonatomic) _Bool animationDisabled; // @synthesize animationDisabled=_animationDisabled;
- (void)setEntity:(id)arg1 forLayoutRole:(int)arg2;
@end

@interface SBWorkspaceDeactivatingEntity : NSObject
@property(nonatomic) long long layoutRole; // @synthesize layoutRole=_layoutRole;
+ (id)entity;
@end

@interface SBWorkspaceHomeScreenEntity : NSObject
@end

@interface SBMainWorkspaceTransitionRequest : NSObject
- (id)initWithDisplay:(id)arg1;
@end

@interface SBAppToAppWorkspaceTransaction
- (void)begin;
- (id)initWithAlertManager:(id)alertManager exitedApp:(id)app;
- (id)initWithAlertManager:(id)arg1 from:(id)arg2 to:(id)arg3 withResult:(id)arg4;
- (id)initWithTransitionRequest:(id)arg1;
@end

@interface FBWorkspaceEventQueue : NSObject
+ (instancetype)sharedInstance;
- (void)executeOrAppendEvent:(FBWorkspaceEvent *)event;
@end

@interface SBDeactivationSettings
-(id)init;
-(void)setFlag:(int)flag forDeactivationSetting:(unsigned)deactivationSetting;
@end

@interface SBWorkspace : NSObject
+(id) sharedInstance;
-(BOOL) isUsingReachApp;
- (void)_exitReachabilityModeWithCompletion:(id)arg1;
- (void)_disableReachabilityImmediately:(_Bool)arg1;
- (void)handleReachabilityModeDeactivated;
-(void) RA_animateWidgetSelectorOut:(id)completion;
-(void) RA_setView:(UIView*)view preferredHeight:(CGFloat)preferredHeight;
-(void) RA_launchTopAppWithIdentifier:(NSString*) bundleIdentifier;
-(void) RA_showWidgetSelector;
-(void) updateViewSizes:(CGPoint)center animate:(BOOL)animate;
-(void) RA_closeCurrentView;
-(void) RA_handleLongPress:(UILongPressGestureRecognizer*)gesture;
-(void) RA_updateViewSizes;
-(void) appViewItemTap:(id)sender;
@end

@interface SBMainWorkspace : SBWorkspace // replaces SBWorkspace on iOS 9
@end

@interface SBDisplayLayout : NSObject {
 int _layoutSize;
 NSMutableArray* _displayItems;
 NSString* _uniqueStringRepresentation;
}
@property(readonly, assign, nonatomic) NSArray* displayItems;
@property(readonly, assign, nonatomic) int layoutSize;
+(id)fullScreenDisplayLayoutForApplication:(id)application;
+(id)homeScreenDisplayLayout;
+(id)displayLayoutWithPlistRepresentation:(id)plistRepresentation;
+(id)displayLayoutWithLayoutSize:(int)layoutSize displayItems:(id)items;
-(id)displayLayoutBySettingSize:(int)size;
-(id)displayLayoutByReplacingDisplayItemOnSide:(int)side withDisplayItem:(id)displayItem;
-(id)displayLayoutByRemovingDisplayItems:(id)items;
-(id)displayLayoutByRemovingDisplayItem:(id)item;
-(id)displayLayoutByAddingDisplayItem:(id)item side:(int)side withLayout:(int)layout;
-(BOOL)isEqual:(id)equal;
-(unsigned)hash;
-(id)uniqueStringRepresentation;
-(id)_calculateUniqueStringRepresentation;
-(id)description;
-(id)copyWithZone:(NSZone*)zone;
-(void)dealloc;
-(id)plistRepresentation;
-(id)initWithLayoutSize:(int)layoutSize displayItems:(id)items;
@end

@interface FBProcessManager : NSObject
+ (id)sharedInstance;
- (void)_updateWorkspaceLockedState;
- (void)applicationProcessWillLaunch:(id)arg1;
- (void)noteProcess:(id)arg1 didUpdateState:(id)arg2;
- (void)noteProcessDidExit:(id)arg1;
- (id)_serviceClientAddedWithPID:(int)arg1 isUIApp:(BOOL)arg2 isExtension:(BOOL)arg3 bundleID:(id)arg4;
- (id)_serviceClientAddedWithConnection:(id)arg1;
- (id)_systemServiceClientAdded:(id)arg1;
- (BOOL)_isWorkspaceLocked;
- (id)createApplicationProcessForBundleID:(id)arg1 withExecutionContext:(id)arg2;
- (id)createApplicationProcessForBundleID:(id)arg1;
- (id)applicationProcessForPID:(int)arg1;
- (id)processForPID:(int)arg1;
- (id)applicationProcessesForBundleIdentifier:(id)arg1;
- (id)processesForBundleIdentifier:(id)arg1;
- (id)allApplicationProcesses;
- (id)allProcesses;
@end

@interface UIGestureRecognizerTarget : NSObject {
 id _target;
}
@end

typedef NS_ENUM(NSUInteger, BKSProcessAssertionReason)
{
 kProcessAssertionReasonNone = 0,
 kProcessAssertionReasonAudio = 1,
 kProcessAssertionReasonLocation = 2,
 kProcessAssertionReasonExternalAccessory = 3,
 kProcessAssertionReasonFinishTask = 4,
 kProcessAssertionReasonBluetooth = 5,
 kProcessAssertionReasonNetworkAuthentication = 6,
 kProcessAssertionReasonBackgroundUI = 7,
 kProcessAssertionReasonInterAppAudioStreaming = 8,
 kProcessAssertionReasonViewServices = 9,
 kProcessAssertionReasonNewsstandDownload = 10,
 kProcessAssertionReasonBackgroundDownload = 11,
 kProcessAssertionReasonVOiP = 12,
 kProcessAssertionReasonExtension = 13,
 kProcessAssertionReasonContinuityStreams = 14,
 // 15-9999 unknown
 kProcessAssertionReasonActivation = 10000,
 kProcessAssertionReasonSuspend = 10001,
 kProcessAssertionReasonTransientWakeup = 10002,
 kProcessAssertionReasonVOiP_PreiOS8 = 10003,
 kProcessAssertionReasonPeriodicTask_iOS8 = kProcessAssertionReasonVOiP_PreiOS8,
 kProcessAssertionReasonFinishTaskUnbounded = 10004,
 kProcessAssertionReasonContinuous = 10005,
 kProcessAssertionReasonBackgroundContentFetching = 10006,
 kProcessAssertionReasonNotificationAction = 10007,
 // 10008-49999 unknown
 kProcessAssertionReasonFinishTaskAfterBackgroundContentFetching = 50000,
 kProcessAssertionReasonFinishTaskAfterBackgroundDownload = 50001,
 kProcessAssertionReasonFinishTaskAfterPeriodicTask = 50002,
 kProcessAssertionReasonAFterNoficationAction = 50003,
 // 50004+ unknown
};

typedef NS_ENUM(NSUInteger, ProcessAssertionFlags)
{
 ProcessAssertionFlagNone = 0,
 ProcessAssertionFlagPreventSuspend         = 1 << 0,
 ProcessAssertionFlagPreventThrottleDownCPU = 1 << 1,
 ProcessAssertionFlagAllowIdleSleep         = 1 << 2,
 ProcessAssertionFlagWantsForegroundResourcePriority  = 1 << 3
};

@interface FBWindowContextHostView : UIView
- (BOOL)isHosting;
@end

@interface FBWindowContextHostManager
- (id)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2;
- (void)resumeContextHosting;
- (id)_hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2;
- (id)snapshotViewWithFrame:(CGRect)arg1 excludingContexts:(id)arg2 opaque:(BOOL)arg3;
- (id)snapshotUIImageForFrame:(struct CGRect)arg1 excludingContexts:(id)arg2 opaque:(BOOL)arg3 outTransform:(struct CGAffineTransform *)arg4;
- (id)visibleContexts;
- (void)orderRequesterFront:(id)arg1;
- (void)enableHostingForRequester:(id)arg1 orderFront:(BOOL)arg2;
- (void)enableHostingForRequester:(id)arg1 priority:(int)arg2;
- (void)disableHostingForRequester:(id)arg1;
- (void)_updateHostViewFrameForRequester:(id)arg1;
- (void)invalidate;

@property(copy, nonatomic) NSString *identifier; // @synthesize identifier=_identifier;
@end

@interface FBSSceneSettings : NSObject <NSCopying, NSMutableCopying>
{
 CGRect _frame;
 CGPoint _contentOffset;
 float _level;
 int _interfaceOrientation;
 BOOL _backgrounded;
 BOOL _occluded;
 BOOL _occludedHasBeenCalculated;
 NSSet *_ignoreOcclusionReasons;
 NSArray *_occlusions;
 //BSSettings *_otherSettings;
 //BSSettings *_transientLocalSettings;
}

+ (BOOL)_isMutable;
+ (id)settings;
@property(readonly, copy, nonatomic) NSArray *occlusions; // @synthesize occlusions=_occlusions;
@property(readonly, nonatomic, getter=isBackgrounded) BOOL backgrounded; // @synthesize backgrounded=_backgrounded;
@property(readonly, nonatomic) int interfaceOrientation; // @synthesize interfaceOrientation=_interfaceOrientation;
@property(readonly, nonatomic) float level; // @synthesize level=_level;
@property(readonly, nonatomic) CGPoint contentOffset; // @synthesize contentOffset=_contentOffset;
@property(readonly, nonatomic) CGRect frame; // @synthesize frame=_frame;
- (id)valueDescriptionForFlag:(int)arg1 object:(id)arg2 ofSetting:(unsigned int)arg3;
- (id)keyDescriptionForSetting:(unsigned int)arg1;
- (id)description;
- (BOOL)isEqual:(id)arg1;
- (unsigned int)hash;
- (id)_descriptionOfSettingsWithMultilinePrefix:(id)arg1;
- (id)transientLocalSettings;
- (BOOL)isIgnoringOcclusions;
- (id)ignoreOcclusionReasons;
- (id)otherSettings;
- (BOOL)isOccluded;
- (CGRect)bounds;
- (void)dealloc;
- (id)init;
- (id)initWithSettings:(id)arg1;
@end

@interface FBSMutableSceneSettings : FBSSceneSettings
{
}

+ (BOOL)_isMutable;
- (id)mutableCopyWithZone:(struct _NSZone *)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
@property(copy, nonatomic) NSArray *occlusions;
- (id)transientLocalSettings;
- (id)ignoreOcclusionReasons;
- (id)otherSettings;
@property(nonatomic, getter=isBackgrounded) BOOL backgrounded;
@property(nonatomic) int interfaceOrientation;
@property(nonatomic) float level;
@property(nonatomic) struct CGPoint contentOffset;
@property(nonatomic) struct CGRect frame;

@end

@interface UIMutableApplicationSceneSettings : FBSMutableSceneSettings
@end

#ifdef __cplusplus
extern "C" {
#endif
	CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);
#ifdef __cplusplus
}
#endif

@interface FBProcess : NSObject
@end

@interface FBScene
-(FBWindowContextHostManager*) contextHostManager;
@property(readonly, retain, nonatomic) FBSMutableSceneSettings *mutableSettings; // @synthesize mutableSettings=_mutableSettings;
- (void)updateSettings:(id)arg1 withTransitionContext:(id)arg2;
- (void)_applyMutableSettings:(id)arg1 withTransitionContext:(id)arg2 completion:(id)arg3;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly, retain) FBProcess *clientProcess;
@end

@interface UIApplication (Private)
- (void)_relaunchSpringBoardNow;
- (id)_accessibilityFrontMostApplication;
- (void)launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended;
- (id)displayIdentifier;
- (void)setStatusBarHidden:(bool)arg1 animated:(bool)arg2;
void receivedStatusBarChange(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo);
void receivedLandscapeRotate();
void receivedPortraitRotate();
@end

@interface SBApplication : UIApplication
@property(copy) NSString* bundleIdentifier;

-(void) _setDeactivationSettings:(SBDeactivationSettings*)arg1;
-(void) clearDeactivationSettings;
-(FBScene*) mainScene;
-(id) mainScreenContextHostManager;
-(id) mainSceneID;
- (void)activate;
- (NSString *)displayName;
- (NSString *)path;
- (void)processDidLaunch:(id)arg1;
- (void)processWillLaunch:(id)arg1;
- (void)resumeForContentAvailable;
- (void)resumeToQuit;
- (void)_sendDidLaunchNotification:(_Bool)arg1;
- (void)notifyResumeActiveForReason:(long long)arg1;
-(BOOL)isSpringBoard;

@property(readonly, nonatomic) int pid;
@end

@interface SBApplicationIcon : NSObject
- (id)initWithApplication:(id)arg1;
- (id)generateIconImage:(int)arg1;
@end

@interface SBApplicationController : NSObject
+(id) sharedInstance;
-(id) applicationWithBundleIdentifier:(NSString*)identifier;
-(id) applicationWithDisplayIdentifier:(NSString*)identifier;
-(id) applicationWithPid:(int)arg1;
@end

@interface SBIcon : NSObject
@end

@interface SBIconModel : NSObject
- (id)visibleIconIdentifiers;
- (id)applicationIconForBundleIdentifier:(id)arg1;
- (SBIcon *)expectedIconForDisplayIdentifier:(NSString *)identifier; //why not bundle identifier?
@end

@interface SBIconImageView : UIView {
	UIImageView *_overlayView;
}
@property (assign,nonatomic) CGFloat overlayAlpha;
@end
@protocol SBIconViewDelegate;

@interface SBIconView : UIView
@property (nonatomic,retain) SBIcon *icon;
@property (assign,nonatomic) id<SBIconViewDelegate> delegate;
@property (assign,nonatomic) CGFloat iconImageAlpha;
@property (assign,nonatomic) CGFloat iconAccessoryAlpha;
@property (assign,nonatomic) CGFloat iconLabelAlpha;
@property (nonatomic,getter=isHighlighted) BOOL highlighted;
- (id)initWithDefaultSize;
- (BOOL)isInDock;
-(int)location;
- (SBIconImageView *)_iconImageView;
@end

@protocol SBIconViewDelegate <NSObject>
@optional
- (void)iconHandleLongPress:(SBIconView *)iconView;
- (void)iconTouchBegan:(SBIconView *)iconView;
- (void)icon:(SBIconView *)iconView touchMoved:(id)touch;
- (void)icon:(SBIconView *)iconView touchEnded:(BOOL)end;
- (BOOL)iconShouldAllowTap:(SBIconView *)iconView;
- (void)iconTapped:(SBIconView *)iconView;
- (BOOL)icon:(SBIconView *)iconView canReceiveGrabbedIcon:(id)icon;
- (void)iconCloseBoxTapped:(SBIconView *)iconView;
- (BOOL)iconViewDisplaysBadges:(SBIconView *)iconView;
- (BOOL)iconViewDisplaysCloseBox:(SBIconView *)iconView;
- (CGFloat)iconLabelWidth;
- (void)icon:(SBIconView *)iconView openFolder:(id)folder animated:(BOOL)animated;
@end

@interface SBIconViewMap : NSObject {
	NSMapTable* _iconViewsForIcons;
	id<SBIconViewDelegate> _iconViewdelegate;
	NSMapTable* _recycledIconViewsByType;
	NSMapTable* _labels;
	NSMapTable* _badges;
}
@property (nonatomic,readonly) SBIconModel * iconModel;
+ (SBIconViewMap *)switcherMap;
+(SBIconViewMap *)homescreenMap;
+(Class)iconViewClassForIcon:(SBIcon *)icon location:(int)location;
-(id)init;
-(void)dealloc;
-(SBIconView *)mappedIconViewForIcon:(SBIcon *)icon;
-(SBIconView *)_iconViewForIcon:(SBIcon *)icon;
-(SBIconView *)iconViewForIcon:(SBIcon *)icon;
-(void)_addIconView:(SBIconView *)iconView forIcon:(SBIcon *)icon;
-(void)purgeIconFromMap:(SBIcon *)icon;
-(void)_recycleIconView:(SBIconView *)iconView;
-(void)recycleViewForIcon:(SBIcon *)icon;
-(void)recycleAndPurgeAll;
-(id)releaseIconLabelForIcon:(SBIcon *)icon;
-(void)captureIconLabel:(id)label forIcon:(SBIcon *)icon;
-(void)purgeRecycledIconViewsForClass:(Class)aClass;
-(void)_modelListAddedIcon:(SBIcon *)icon;
-(void)_modelRemovedIcon:(SBIcon *)icon;
-(void)_modelReloadedIcons;
-(void)_modelReloadedState;
-(void)iconAccessoriesDidUpdate:(SBIcon *)icon;
@end

@interface SBIconController : NSObject
+ (SBIconController *)sharedInstance;
- (SBIconModel *)model;
- (BOOL)hasAnimatingFolder;
-(SBIconViewMap *)homescreenIconViewMap;
@property (nonatomic,readonly) SBIconViewMap * homescreenIconViewMap; 
@end