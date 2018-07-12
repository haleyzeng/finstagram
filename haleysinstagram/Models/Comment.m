//
//  Comment.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/11/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic post, author, unformattedCommentText;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

- (instancetype)initWithPost:(Post *)post author:(MyUser *)author commentContent:(NSString *)commentContent {
    self = [super init];
    self.post = post;
    self.author = author;
    self.unformattedCommentText = [self makeUnformattedCommentText:commentContent];
   
    return self;
}

- (NSString *)makeUnformattedCommentText:(NSString *)commentContent {
    return [[self.author.username stringByAppendingString:@" "] stringByAppendingString:commentContent];
}

- (NSAttributedString *)makeFormattedCommentTextFromUnformattedCommentText:(NSString *)unformattedCommentText {
    
    NSMutableAttributedString *formattedCommentText = [[NSMutableAttributedString alloc] initWithString:unformattedCommentText];
    
    NSRange range = NSMakeRange(0, self.author.username.length);
    
    UIFont *font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold];
    
    [formattedCommentText beginEditing];
    [formattedCommentText addAttribute:NSFontAttributeName
                          value:font
                          range:range];
    [formattedCommentText endEditing];
    
    return (NSAttributedString *)formattedCommentText;
}



@end
