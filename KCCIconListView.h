#import "Keek.h"
#import "KeekDataProvider.h"
#import "KCCCardListView.h"

__attribute__((visibility("hidden")))
@interface KCCIconListView : UIView

- (id)initWithFrame:(CGRect)frame;
- (void)setIcons:(NSArray *)icons;
- (void)layout;
@end