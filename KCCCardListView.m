#import "KCCCardListView.h"
#import "KeekIconView.h"

#define kCardPerRow 4
#define kCardSpacing 10
#define kCardYSpacing 20
#define kCardLoadCount 16

static CGSize cardSize(CGSize size){
	CGFloat height = size.height - kCardYSpacing;
	CGFloat width = height * (kScreenWidth / kScreenHeight);
	return CGSizeMake(width, height);
}

static float iconPositionXForIndex(NSInteger index, CGSize size)
{
	float spacing = (size.width - ((cardSize(size).width) * kCardPerRow) - (kCardSpacing * 2)) / (kCardPerRow - 1);
	int pageNumber = floor(index / kCardPerRow);
	int pageWidth = pageNumber * size.width;

	if (index % kCardPerRow == 0)
	{
		return pageWidth + kCardSpacing;
	}else{
		return pageWidth + kCardSpacing + ((index - (pageNumber * kCardPerRow))) * ((cardSize(size).width) + spacing);
	}
}

static CGRect iconFrameForIndex(NSInteger index, CGSize size)
{
	CGFloat x = iconPositionXForIndex(index, size);
    CGFloat y = kCardYSpacing * 0.25;
    return CGRectMake(x, y, cardSize(size).width, cardSize(size).height);
}

@implementation KCCCardListView{
    NSArray *_cards;
    NSMutableDictionary *_cardViews;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = NO;
        self.scrollEnabled = YES;
        self.pagingEnabled = YES;
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setIcons:(NSArray *)icons
{
	if (icons == nil) {
		icons = @[];
	}

	if (icons.count > kCardLoadCount) {
		self.contentSize = CGSizeMake(self.frame.size.width * ceil(kCardLoadCount / kCardPerRow), self.frame.size.height);
	}else{
		self.contentSize = CGSizeMake(self.frame.size.width * ceil(icons.count / kCardPerRow), self.frame.size.height);
	}

    [_cardViews.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _cards = icons;
    _cardViews = [NSMutableDictionary dictionary];
    if (_cards.count > 0) {
    	[_cards enumerateObjectsUsingBlock:^(NSString *icon, NSUInteger index, BOOL *stop) {
	        KCCCardView *iconView = [[KCCCardView alloc] initWithFrame:CGRectZero];
            if (index < kCardLoadCount) {
                [iconView loadCard:icon withSize:cardSize(self.frame.size)];
                iconView.identifier = icon;
            }
	        _cardViews[icon] = iconView;
	        [self addSubview:iconView];
    	}];
	    [self layout];
    }
}

- (void)layout
{
    [_cards enumerateObjectsUsingBlock:^(NSString *icon, NSUInteger index, BOOL *stop) {
		KCCCardView *iconView = _cardViews[icon];
		iconView.frame = iconFrameForIndex(index, self.frame.size);

		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:container action:@selector(openAppWithIdentifier:)];
		[tapGesture setCancelsTouchesInView:YES];
		[iconView addGestureRecognizer:tapGesture];

		[iconView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:container action:@selector(launchAppWithIdentifier:)]];
    }];
}

@end
