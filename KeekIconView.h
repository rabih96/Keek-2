#import <UIKit/UIKit.h>

__attribute__((visibility("hidden")))
@interface KeekIconView : UIImageView
@property (nonatomic, retain) NSString *identifier;

- (void)loadIcon:(NSString *)identifier;

@end
