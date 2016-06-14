//
//  UIImage+isFromVideo.m
//  CamersAndGalaryStudy
//
//  Created by Rhinoda3 on 14.06.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "UIImage+isFromVideo.h"

#import <objc/runtime.h>

static const void *ImageSourceKey = &ImageSourceKey;

@implementation UIImage (isFromVideo)

- (void) setSource:(NSString *)source
{
	objc_setAssociatedObject(self, ImageSourceKey, source, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)source
{
	return objc_getAssociatedObject(self, ImageSourceKey);
}


@end
