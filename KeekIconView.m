#import "KeekIconView.h"
#import "KCCCardListView.h"

@implementation KeekIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)loadIcon:(NSString *)identifier
{
	if (self.image != nil) {
		return;
	}
	UIImage * __block largeImage;
	if ([identifier isEqualToString:@"com.apple.mobilecal"] || [identifier isEqualToString:@"com.apple.mobiletimer"]) {
		void (^block)() = ^{
			__block SBApplicationIcon *icon;
			if ([identifier isEqualToString:@"com.apple.mobilecal"]) {
				icon = [[NSClassFromString(@"SBCalendarApplicationIcon") alloc] initWithApplication:[[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:identifier]];
			}else if ([identifier isEqualToString:@"com.apple.mobiletimer"]) {
				icon = [[NSClassFromString(@"SBClockApplicationIcon") alloc] initWithApplication:[[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:identifier]];
			}
			largeImage = [icon generateIconImage:2];
		};
		if ([NSThread isMainThread]) {
			block();
		} else {
			dispatch_semaphore_t sema = dispatch_semaphore_create(0);
			dispatch_async(dispatch_get_main_queue(), ^{
				block();
				dispatch_semaphore_signal(sema);
				});
			dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
		}
	} else {
		static NSCache *cache;
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			cache = [[NSCache alloc]init];
			cache.countLimit = 16;
		});
		largeImage = [cache objectForKey:identifier];
		if (largeImage == nil) {
			largeImage = [UIImage _applicationIconImageForBundleIdentifier:identifier format:2 scale:[UIScreen mainScreen].scale];
			[cache setObject:largeImage forKey:identifier];
		}
	}
	[self performSelectorOnMainThread:@selector(setImage:) withObject:largeImage waitUntilDone:NO];
}
@end
