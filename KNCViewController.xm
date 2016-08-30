#import "KNCViewController.h"
#import "KeekCardView.h"
#import "CDTContextHostProvider.h"
#import <notify.h>
#import "objc/objc.h"
#import "objc/runtime.h"
#import "rocketbootstrap/rocketbootstrap.h"

@implementation SBNCColumnViewController
@end

@interface KNCViewController () {
	KeekCardView *cardView;
	KeekCardView *openedCard;
	UIView* contextHostView;
	UIButton 	*closeButton;
	NSString 	*openIdentifier;
	CGPoint 	oldCenter;
	int 		tries;
	BOOL 		shouldReload;
	CPDistributedMessagingCenter *c;
}
@end

extern KNCViewController *ncAppViewController;

@implementation KNCViewController

+(instancetype) sharedViewController
{
	return ncAppViewController;
}

- (void)insertAppropriateViewWithContent
{
	[self viewDidAppear:YES];
}

- (void)viewWillLayoutSubviews
{
	[self viewDidAppear:YES];
}

-(void)setShouldReload{
	shouldReload = YES;
	NSLog(@"[KEEK]: setShouldReload = YES in NC");
	//Alert(@"Keek",@"shouldReload = YES");
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	/*if (!c) {
		c = [CPDistributedMessagingCenter centerNamed:@"keek.center"];
		rocketbootstrap_distributedmessagingcenter_apply(c);
		[c runServerOnCurrentThread];
		[c registerForMessageName:@"keek.center.shouldreload" target:self selector:@selector(setShouldReload)];
	}*/

	if ([[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked]) {
		BKSDisplaySetSecureMode(NO);
	}

	if (openedCard)	[self closeView];

	int width = self.view.frame.size.width;
	int height = self.view.frame.size.height;
	int cardHeight, cardWidth;

	if (height>=width){
		cardHeight = (height-120)/2;
		cardWidth = cardHeight*(kScreenWidth/kScreenHeight);
	}else{
	 	cardHeight = height-60;
	 	cardWidth = cardHeight*(kScreenWidth/kScreenHeight);
	}

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		dispatch_async(dispatch_get_main_queue(), ^{
			if (shouldReload == YES)	[[KeekDataProvider sharedInstance] setup];
		});
	});

	if (shouldReload == YES) {
		NSArray *subviews = [self.view subviews];
		for ( int x = 0; x < [subviews count]; ++x )	{
			UIView *card = [subviews objectAtIndex:x];
			if ([card isKindOfClass:[KeekCardView class]])	{
				[card removeFromSuperview];
			}
		}
	}

	NSLog(@"[KEEK]: loading apps in NC");

	if(cardView == nil || shouldReload == YES) {
		for (int i = 0; i < 4; i++) {
			cardView = [[KeekCardView alloc] initWithIdentifier:[[[KeekDataProvider sharedInstance] cachedIdentifiers] objectAtIndex:i] cardViewSize:CGSizeMake(cardWidth,cardHeight)];
			cardView.frame = [self frameForCardAtIndex:i];
			cardView.tag = i;
			[self.view addSubview:cardView];
		}
	}

	if (closeButton == nil) {
		closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[closeButton setTitle:@"Close" forState:UIControlStateNormal];
		[closeButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
		closeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
		[closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
		closeButton.titleLabel.font = [UIFont systemFontOfSize:18];
		closeButton.alpha = 0.0;
		closeButton.layer.cornerRadius = 15;
		closeButton.clipsToBounds = YES;
		closeButton.userInteractionEnabled = NO;
		closeButton.tag = 961;
		[self.view addSubview:closeButton];
	}

	int widthSpacing = ((self.view.frame.size.height-65)/kScreenHeight)*self.view.frame.size.width;
	closeButton.frame = CGRectMake((self.view.frame.size.width-widthSpacing)/2, self.view.frame.size.height-55, widthSpacing, 50);

	CGRect frame = self.view.frame;
	frame.origin.x = frame.size.width * 2.0;
	self.view.frame = frame;
}

-(void)openAppWithIdentifier:(UITapGestureRecognizer *)tap{
	KeekCardView *kCardView = tap.view.superview;
	NSString *identifier = kCardView.identifier;

	if([[[[UIApplication sharedApplication] _accessibilityFrontMostApplication] bundleIdentifier] isEqualToString:identifier]){
		[[NSClassFromString(@"SBNotificationCenterController") sharedInstanceIfExists] dismissAnimated:YES completion:nil];
		return;
	}

	CGRect superFrame = self.view.frame;
	closeButton.alpha = 0.25;
	oldCenter = kCardView.center;
	openedCard = kCardView;
	openIdentifier = identifier;

	tries = 0;
	[[CDTContextHostProvider sharedInstance] launchSuspendedApplicationWithBundleID:identifier];
	[self getContextViewForIdentifier:identifier];

	NSArray *subviews = [self.view subviews];

	for ( int x = 0; x < [subviews count]; ++x )	{
		UIView *card = [subviews objectAtIndex:x];
		if ([card isKindOfClass:[KeekCardView class]])	{
			if (card.tag != kCardView.tag) {
				[UIView animateWithDuration:0.25 animations:^{
					card.alpha = 0.0;
				}completion:^(BOOL finished){
				}];
			}
		}
	}

	//CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)[NSString stringWithFormat:@"%@.Keek.HideStatusBar", identifier], NULL, NULL , YES);

	[UIView animateWithDuration:0.65 animations:^{
		kCardView.center = CGPointMake(superFrame.size.width/2,(superFrame.size.height/2)-30);
		[kCardView.appSnapshot setTransform:CGAffineTransformMakeScale((superFrame.size.height-65)/kScreenHeight, (superFrame.size.height-65)/kScreenHeight)];
		kCardView.appName.alpha = 0.0;
		kCardView.appIcon.alpha = 0.0;
		closeButton.alpha = 1.0;
	}completion:^(BOOL finished){
		closeButton.userInteractionEnabled = YES;
		contextHostView.transform = CGAffineTransformMakeScale((superFrame.size.height-65)/kScreenHeight, (superFrame.size.height-65)/kScreenHeight);
		contextHostView.layer.cornerRadius = 15;
		contextHostView.layer.masksToBounds = YES;
		contextHostView.center = kCardView.appSnapshot.center;
		kCardView.appSnapshot.alpha = 0.0;
		[kCardView addSubview:contextHostView];
	}];
}

-(void)getContextViewForIdentifier:(NSString*)identifier{
	contextHostView = [[CDTContextHostProvider sharedInstance] hostViewForApplicationWithBundleID:identifier];
	if (!contextHostView) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			if (tries >= 5) {
				[[[UIAlertView alloc] initWithTitle:@"Keek" message:@"Unable to load app. Please open the app once then try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
				tries = 0;
				return;
			} else {
				[self getContextViewForIdentifier:identifier];
				tries++;
			}
		});
		return;
	}
}

-(void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	//shouldReload = NO;
}

-(void)longPressTap:(UIGestureRecognizer*)recognizer{
	KeekCardView *kCardView = recognizer.view;
	NSString *identifier = kCardView.identifier;
	[[NSClassFromString(@"SBUIController") sharedInstance] activateApplication:[[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:identifier]];
}

-(void)closeView {
	NSArray *subviews = [self.view subviews];
	for ( int x = 0; x < [subviews count]; ++x )	{
		UIView *card = [subviews objectAtIndex:x];
		if ([card isKindOfClass:[KeekCardView class]])	{
			if (card.tag != openedCard.tag) {
				[UIView animateWithDuration:0.65 animations:^{
					card.alpha = 1.0;
				}completion:^(BOOL finished){
				}];
			}
		}
	}

	int width = self.view.frame.size.width;
	int height = self.view.frame.size.height;
	int cardHeight, cardWidth;

	if (height>=width){
		cardHeight = (height-120)/2;
		cardWidth = cardHeight*(kScreenWidth/kScreenHeight);
	}else{
		cardHeight = height-60;
		cardWidth = cardHeight*(kScreenWidth/kScreenHeight);
	}

	openedCard.appSnapshot.alpha = 1.0;
	[contextHostView removeFromSuperview];
	[[CDTContextHostProvider sharedInstance] stopHostingForBundleID:openIdentifier];
	[UIView animateWithDuration:0.65 animations:^{
		openedCard.center = oldCenter;
		[openedCard.appSnapshot setTransform:CGAffineTransformMakeScale(cardWidth/kScreenWidth, cardHeight/kScreenHeight)];
		openedCard.appName.alpha = 1.0;
		openedCard.appIcon.alpha = 1.0;
		closeButton.alpha = 0.0;
	}completion:^(BOOL finished){
		closeButton.userInteractionEnabled = NO;
		openedCard = nil;
		openIdentifier = nil;
	}];
}

-(CGRect)frameForCardAtIndex:(int)index{
	int width = self.view.frame.size.width;
	int height = self.view.frame.size.height;

	if (height>=width){
		int cardHeight = (height-120)/2;
		int cardWidth = cardHeight*(kScreenWidth/kScreenHeight);
		switch (index) {
			case 0: return CGRectMake((width-(2*cardWidth))/4, 10, cardWidth, cardHeight);
			break;
			case 1:	return CGRectMake(width-(((width-(2*cardWidth))/4)+cardWidth), 10, cardWidth, cardHeight);
			break;
			case 2: return CGRectMake((width-(2*cardWidth))/4, height-50-cardHeight, cardWidth, cardHeight);
			break;
			case 3:	return CGRectMake(width-(((width-(2*cardWidth))/4)+cardWidth), height-50-cardHeight, cardWidth, cardHeight);
			break;
		}
	} else {
		int cardHeight = height-60;
		int cardWidth = cardHeight*(kScreenWidth/kScreenHeight);
		switch (index) {
			case 0: return CGRectMake((width-(4*cardWidth))/5, 10, cardWidth, cardHeight);
			break;
			case 1:	return CGRectMake((2*((width-(4*cardWidth))/5))+cardWidth, 10, cardWidth, cardHeight);
			break;
			case 2: return CGRectMake((3*((width-(4*cardWidth))/5))+(cardWidth*2), 10, cardWidth, cardHeight);
			break;
			case 3:	return CGRectMake((4*((width-(4*cardWidth))/5))+(cardWidth*3), 10, cardWidth, cardHeight);
			break;
		}
	}
	return CGRectZero;
}

- (void)hostDidDismiss
{
	if (openedCard) {
		[self closeView];
	}
}

- (void)insertTableView
{
	//
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	//
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
	if (signature == nil && class_respondsToSelector(%c(SBBulletinObserverViewController), aSelector))
		signature = [%c(SBBulletinObserverViewController) instanceMethodSignatureForSelector:aSelector];
	return signature;
}

- (BOOL)isKindOfClass:(Class)aClass
{
	if (aClass == %c(SBBulletinObserverViewController) || aClass == %c(SBNCColumnViewController))
		return YES;
	else
		return [super isKindOfClass:aClass];
}
@end
