#import "KRootListController.h"
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Preferences/PSSpecifier.h>

@implementation KRootListController

#pragma mark - Constants

+ (NSString *)hb_specifierPlist {
	return @"Root";
}

+ (NSString *)hb_shareText {
	return @"I love #Keek2 by @rabih96";
}

+ (NSURL *)hb_shareURL {
	return nil;
}

#pragma mark - UIViewController

- (instancetype)init {
	self = [super init];

	if (self) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		appearanceSettings.tintColor = [UIColor colorWithRed:165.f / 255.f green:193.f / 255.f blue:240.f / 255.f alpha:1];
		self.hb_appearanceSettings = appearanceSettings;
	}

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)reloadSpecifiers {
	[super reloadSpecifiers];
}

@end
