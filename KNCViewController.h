@interface SBNCColumnViewController : UIViewController
@property (nonatomic,readonly) CGSize contentSize;
-(CGSize)contentSize;
@end

@interface KNCViewController : SBNCColumnViewController
+(instancetype) sharedViewController;
-(void)setShouldReload;
-(void)openAppWithIdentifier:(UITapGestureRecognizer *)tap;
@end