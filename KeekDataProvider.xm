#import "KeekDataProvider.h"

@implementation KeekDataProvider

+ (id)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
 if (self = [super init]) {
  _appIdentifiers = [[NSMutableArray alloc] init];
  _snapshotsCache = [[NSMutableDictionary alloc] init];
  _appSnapshots = [[NSMutableArray alloc] init];
  _snap_queue = dispatch_queue_create("snapshotQueue", DISPATCH_QUEUE_CONCURRENT);
  [self setup];
 }
 return self;
}

- (NSArray *)cachedSnapshots {
 return [_appSnapshots copy];
}

- (NSArray *)cachedIdentifiers {
 return [_appIdentifiers copy];
}

- (NSArray *)identifiers {
 NSArray *displayItems = [[NSClassFromString(@"SBAppSwitcherModel") sharedInstance] valueForKey:@"_recentDisplayItems"];
 NSMutableArray *identities = [[NSMutableArray alloc] initWithCapacity:[displayItems count]];
 for (SBDisplayItem *item in displayItems) {
  [identities addObject:[item valueForKey:@"_displayIdentifier"]];
 }
 _appIdentifiers = identities;
 return [_appIdentifiers copy];
}

- (void)preheatSnapshots {
    [_appSnapshots removeAllObjects];
    int i = 0;
    NSArray *displayItems = [[NSClassFromString(@"SBAppSwitcherModel") sharedInstance] valueForKey:@"_recentDisplayItems"];
    for (SBDisplayItem *item in displayItems) {
      if (i<16) {
          if (![_snapshotsCache valueForKey:[item valueForKey:@"_displayIdentifier"]]) {
          SBAppSwitcherSnapshotView *snapshotView = [NSClassFromString(@"SBAppSwitcherSnapshotView") appSwitcherSnapshotViewForDisplayItem:item orientation:0 preferringDownscaledSnapshot:YES loadAsync:YES withQueue:_snap_queue];
          [snapshotView _loadSnapshotAsyncPreferringDownscaled:YES];
          [_snapshotsCache setValue:snapshotView forKey:[item valueForKey:@"_displayIdentifier"]];
          [_appSnapshots addObject:snapshotView];
      } else {
         [_appSnapshots addObject:[_snapshotsCache valueForKey:[item valueForKey:@"_displayIdentifier"]]];
      }
    }
    i++;
   }
}

- (void)updateSnapshotForBundleID:(NSString *)bundleID {
   SBDisplayItem *item = [[NSClassFromString(@"SBDisplayItem") alloc] initWithType:@"App" displayIdentifier:bundleID];
   if ([_snapshotsCache valueForKey:[item valueForKey:@"_displayIdentifier"]]) {
      SBAppSwitcherSnapshotView *snapshotView = [_snapshotsCache valueForKey:[item valueForKey:@"_displayIdentifier"]];
      [snapshotView _loadSnapshotAsyncPreferringDownscaled:YES];
   }
}

- (void)purgeSnapshots {
   [_snapshotsCache removeAllObjects];
   [_appSnapshots removeAllObjects];
}

- (void)purgeIdentifiers {
   [_appIdentifiers removeAllObjects];
}

- (void)setup {
   [self purgeIdentifiers];
   [self purgeSnapshots];
   [self identifiers];
   [self preheatSnapshots];
}

- (NSInteger)snapshotCount {
   return [_appSnapshots count];
}

- (NSInteger)identifierCount {
   return [_appIdentifiers count];
}

@end
