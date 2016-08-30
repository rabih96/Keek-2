#import "KPersonTableCell.h"
#import <Preferences/PSSpecifier.h>

@implementation KPersonTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		self.detailTextLabel.text = specifier.properties[kKDisplayedHandleKey];
	}

	return self;
}

@end
