//
//  GalleryCollectionViewCell.m
//  CamersAndGalaryStudy
//
//  Created by Rhinoda3 on 14.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "GalleryCollectionViewCell.h"

@implementation GalleryCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {

		// Initialization code
		NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GalleryCollectionViewCell" owner:self options:nil];

		if ([arrayOfViews count] < 1) {
			return nil;
		}

		if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
			return nil;
		}

		self = [arrayOfViews objectAtIndex:0];

	}

	return self;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
