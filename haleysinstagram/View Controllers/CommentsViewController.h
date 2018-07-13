//
//  CommentsViewController.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/11/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Post.h"

@protocol CommentsViewControllerDelegate

- (void)didPostAComment;

@end

@interface CommentsViewController : UIViewController

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) id<CommentsViewControllerDelegate> delegate;
@property (nonatomic) BOOL writeCommentImmediately;

@end
