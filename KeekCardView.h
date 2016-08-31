#import "Keek.h"
#import "KeekIconView.h"
#import "KeekDataProvider.h"

@interface KeekCardView : UIView {
}

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) SBAppSwitcherSnapshotView *appSnapshot;
@property (nonatomic, retain) KeekIconView *appIcon;
@property (nonatomic, retain) UILabel *appName;
@property (nonatomic, retain) id application;

- (id)initWithIdentifier:(NSString *)identifier cardViewSize:(CGSize)cardSize;

@end
