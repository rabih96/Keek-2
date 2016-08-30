#import "Keek.h"
#import "KeekDataProvider.h"
#import "KCCCardView.h"

SBControlCenterContentContainerView *container;

__attribute__((visibility("hidden")))
@interface KCCCardListView : UIScrollView

- (id)initWithFrame:(CGRect)frame;
- (void)setIcons:(NSArray *)icons;
- (void)layout;
@end