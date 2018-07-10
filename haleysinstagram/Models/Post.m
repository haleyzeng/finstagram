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

+ (void) postUserImage:(UIImage * _Nullable)image withCaption: (NSString * _Nullable)caption withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.author = MyUser.currentUser;
    newPost.caption = caption;
    newPost.image = [MyUser getPFFileFromImage:image];
   // newPost.absoluteCreatedAtDate = [self getCurrentDateString];
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock:completion];
    NSLog(@"Post saved.");
}

@end
