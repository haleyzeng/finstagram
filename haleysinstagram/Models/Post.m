//
//  Post.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic author, caption, image, likeCount, commentCount;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFile fileWithName:@"image.png" data:imageData];
}

/*
+ (NSString *)getCurrentDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    NSDate *now = [NSDate date];
    NSString *newDateString = [formatter stringFromDate:now];
    
    return newDateString;
}*/

+ (void) postUserImage:(UIImage * _Nullable)image withCaption: (NSString * _Nullable)caption withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.author = PFUser.currentUser;
    newPost.caption = caption;
    newPost.image = [self getPFFileFromImage:image];
   // newPost.absoluteCreatedAtDate = [self getCurrentDateString];
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock:completion];
    NSLog(@"Post saved.");
}

@end
