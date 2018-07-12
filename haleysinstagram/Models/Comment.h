//
//  Comment.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/11/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Post.h"
#import "MyUser.h"

@interface Comment : PFObject <PFSubclassing>

@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) MyUser *author;
@property (strong, nonatomic) NSString *unformattedCommentText;

- (instancetype)initWithPost:(Post *)post author:(MyUser *)author commentContent:(NSString *)commentContent;
- (NSAttributedString *)makeFormattedCommentTextFromUnformattedCommentText;

@end
