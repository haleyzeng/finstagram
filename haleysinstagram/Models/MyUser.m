//
//  MyUser.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "MyUser.h"

@implementation MyUser

@dynamic profileImage, username, password;

+ (nonnull NSString *)parseClassName {
   return [super parseClassName];
}

+ (PFFile *)getPFFileFromImage:(UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        NSLog(@"no image");
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        NSLog(@"no image data");
        return nil;
    }
    return [PFFile fileWithName:@"image.png" data:imageData];
}

@end
