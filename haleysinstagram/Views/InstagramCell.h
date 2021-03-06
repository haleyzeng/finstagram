//
//  InstagramCell.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "Post.h"

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "CommentsViewController.h"

@interface InstagramCell : UITableViewCell <DetailViewControllerDelegate, CommentsViewControllerDelegate>

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewCommentsButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeCountLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCommentsButtonHeightConstraint;

- (void)toggleLike:(MyUser *)user withCompletion:completion;

@end
