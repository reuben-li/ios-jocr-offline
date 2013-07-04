//
//  cropper.h
//  jocroffline
//
//  Created by reuben on 4/7/13.
//  Copyright (c) 2013 space.works. All rights reserved.
//

#import <Foundation/Foundation.h>

// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
@interface UIImage (Extras)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end