//
//  Post.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Post : PFObject <PFSubclassing>


@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFile *image;
//@property (nonatomic, strong) NSString *absoluteCreatedAtDate;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;

+ (void)postUserImage:(UIImage * _Nullable)image
          withCaption:(NSString * _Nullable)caption
       withCompletion:(PFBooleanResultBlock  _Nullable)completion;


@end