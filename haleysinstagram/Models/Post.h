//
//  Post.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "MyUser.h"

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong) MyUser * _Nullable author;
@property (nonatomic, strong) NSString * _Nullable caption;
@property (nonatomic, strong) PFFile * _Nullable image;

@property (nonatomic, strong) NSArray * _Nullable likedBy;
@property (nonatomic, strong) NSArray * _Nullable comments;

+ (void)postUserImage:(UIImage * _Nullable)image
          withCaption:(NSString * _Nullable)caption
       withCompletion:(PFBooleanResultBlock  _Nullable)completion;

- (void)addLike:(MyUser *_Nullable)user withCompletion:completion;
- (void)removeLike:(MyUser *_Nullable)user withCompletion:completion;
- (BOOL)isLikedByUser:(MyUser *_Nullable)user;
@end
