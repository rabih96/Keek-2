#import "Keek.h"
#import <Foundation/Foundation.h>

@interface KeekDataProvider : NSObject

@property (nonatomic, retain) NSMutableArray *appIdentifiers;
@property (nonatomic, retain) NSMutableDictionary *snapshotsCache;
@property (nonatomic, retain) NSMutableArray *appSnapshots;
@property dispatch_queue_t snap_queue;
+ (id)sharedInstance;
- (NSArray *)cachedSnapshots;
- (NSArray *)cachedIdentifiers;
- (NSArray *)identifiers;
- (void)preheatSnapshots;
- (void)updateSnapshotForBundleID:(NSString *)bundleID;
- (void)purgeSnapshots;
- (void)purgeIdentifiers;
- (void)setup;
- (NSInteger)snapshotCount;
- (NSInteger)identifierCount;
@end
