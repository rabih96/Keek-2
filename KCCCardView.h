#import "Keek.h"
#import "KeekDataProvider.h"
#import "KeekIconView.h"

@interface KCCCardView : UIView

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) SBAppSwitcherSnapshotView *appSnapshot;
@property (nonatomic, retain) KeekIconView *appIcon;

- (id)initWithFrame:(CGRect)frame;
- (void)loadCard:(NSString *)identifier withSize:(CGSize)size;

@end