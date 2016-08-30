#import "KeekCardView.h"
#import "KNCViewController.h"
#import "QuartzCore/QuartzCore.h"

@implementation KeekCardView

- (id)initWithIdentifier:(NSString *)identifier cardViewSize:(CGSize)cardSize{
 if (self = [super init]) {
  _identifier = identifier;

  _appSnapshot = [[[KeekDataProvider sharedInstance] snapshotsCache] objectForKey:identifier];
  [_appSnapshot setCornerRadius:15.0];
  [_appSnapshot setTransform:CGAffineTransformMakeScale(cardSize.width / kScreenWidth, cardSize.height / kScreenHeight)];
  [_appSnapshot setFrame:CGRectMake(0, 0, cardSize.width, cardSize.height)];
  [self addSubview:_appSnapshot];

  _appIcon = [[KeekIconView alloc] initWithFrame:CGRectMake((cardSize.width - kCardViewIconSize)/ 2, cardSize.height - (kCardViewIconSize * 0.25), kCardViewIconSize, kCardViewIconSize)];
  [_appIcon loadIcon:identifier];
  [self addSubview:_appIcon];

  _appName = [[UILabel alloc] initWithFrame:CGRectMake(0, cardSize.height + (kCardViewIconSize * 0.75), cardSize.width, 20)];
  [_appName setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
  [_appName setTextAlignment:NSTextAlignmentCenter];
  [_appName setTextColor:[UIColor whiteColor]];

  dispatch_async(dispatch_get_main_queue(), ^{
   [self addSubview:_appName];
   [_appName setText:[[[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:identifier] displayName]];
  });

  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[KNCViewController sharedViewController] action:@selector(openAppWithIdentifier:)];
  [tapGesture setCancelsTouchesInView:YES];
  [_appSnapshot addGestureRecognizer:tapGesture];

  [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:[KNCViewController sharedViewController] action:@selector(longPressTap:)]];
 }

 return self;
}

@end
