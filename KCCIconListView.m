#import "KCCIconListView.h"
#import "KeekIconView.h"

#define kIconSpacing 10
#define kIconMaxSize 62
#define kIconMinSize 42
#define kIconLoadCount 8

static float iconPositionXForIndex(NSInteger index, CGSize size, NSInteger iconCount)
{
    if (((iconCount * kIconMaxSize) + (2 * kIconSpacing) > size.width) && ((iconCount * kIconMinSize) + (2 * kIconSpacing) < size.width)){
        float spacing = (size.width - (kIconMinSize * iconCount) - (kIconSpacing * 2)) / (iconCount - 1);
        return kIconSpacing + index * (kIconMinSize + spacing);    
    }else if ((iconCount * kIconMaxSize) + (2 * kIconSpacing) < size.width){
        float spacing = (size.width - (kIconMaxSize * iconCount) - (kIconSpacing * 2)) / (iconCount - 1);
        return kIconSpacing + index * (kIconMaxSize + spacing);
    }
}

static CGRect iconFrameForIndex(NSInteger index, CGSize size, NSInteger iconCount)
{
	CGFloat x = iconPositionXForIndex(index, size, iconCount);
    CGFloat y = (size.height - kIconMaxSize) * 0.5;
    if (size.width > size.height){
        if (((iconCount * kIconMaxSize) + (2 * kIconSpacing) > size.width) && ((iconCount * kIconMinSize) + (2 * kIconSpacing) < size.width)){
            y = (size.height - kIconMinSize) * 0.5;
		    return CGRectMake(x, y, kIconMinSize, kIconMinSize);
        }else if ((iconCount * kIconMaxSize) + (2 * kIconSpacing) < size.width){
            return CGRectMake(x, y, kIconMaxSize, kIconMaxSize);
        }
    }else{
    	return CGRectMake(y, x, kIconMaxSize, kIconMaxSize);
    }
}

@implementation KCCIconListView{
    NSArray *_icons;
    NSMutableDictionary *_iconsView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setIcons:(NSArray *)icons
{
	if (icons == nil) {
		icons = @[];
	}

    [_iconsView.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _icons = icons;
    _iconsView = [NSMutableDictionary dictionary];
    if (_icons.count > 0) {
    	[_icons enumerateObjectsUsingBlock:^(NSString *icon, NSUInteger index, BOOL *stop) {
            KeekIconView *appIcon = [[KeekIconView alloc] initWithFrame:CGRectZero];
            if (index < kIconLoadCount) {
                [appIcon loadIcon:icon];
                appIcon.userInteractionEnabled = YES;
                appIcon.identifier = icon;
            }
	        _iconsView[icon] = appIcon;
            [self addSubview:appIcon];
    	}];
	    [self layout];
    }
}

- (void)layout
{
    [_icons enumerateObjectsUsingBlock:^(NSString *icon, NSUInteger index, BOOL *stop) {
		KeekIconView *appIcon = _iconsView[icon];
		appIcon.frame = iconFrameForIndex(index, self.frame.size, _icons.count);

		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:container action:@selector(openAppWithIdentifier:)];
		[tapGesture setCancelsTouchesInView:YES];
		[appIcon addGestureRecognizer:tapGesture];

		[appIcon addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:container action:@selector(launchAppWithIdentifier:)]];
    }];
}

@end

