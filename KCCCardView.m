#import "KCCCardView.h"
#import "QuartzCore/QuartzCore.h"

#define kAppIconSize 30

@implementation KCCCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    	self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)loadCard:(NSString *)identifier withSize:(CGSize)size
{
	_appSnapshot = [[[KeekDataProvider sharedInstance] snapshotsCache] objectForKey:identifier];
	[_appSnapshot setCornerRadius:15.0];
	[_appSnapshot setTransform:CGAffineTransformMakeScale(size.width/kScreenWidth, size.height/kScreenHeight)];
	[_appSnapshot setFrame:CGRectMake(0, 0, size.width, size.height)];
	[self addSubview:_appSnapshot];

	_appIcon = [[KeekIconView alloc] initWithFrame:CGRectMake((size.width - kAppIconSize)/ 2, size.height - (kAppIconSize * 0.625), kAppIconSize, kAppIconSize)];
	[_appIcon loadIcon:identifier];
	[self addSubview:_appIcon];
}

@end
