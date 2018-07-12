//
//  InstagramCell.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "InstagramCell.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "Comment.h"

@implementation InstagramCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPost:(Post *)post {
    _post = post;
    
    NSString *username = self.post.author.username;
    self.usernameLabel.text = username;
    
    if (self.post.caption != nil) {
        Comment *caption = [[Comment alloc] initWithPost:self.post author:self.post.author commentContent:self.post.caption];
    
        self.captionLabel.attributedText = [caption makeFormattedCommentTextFromUnformattedCommentText];
    }
        
    NSDate *createdAtDate = self.post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *relativeDate = [NSDate shortTimeAgoSinceDate:createdAtDate];
    self.dateLabel.text = relativeDate;
    
    // set post's photo imageview
    NSURL *photoURL = [NSURL URLWithString:self.post.image.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:photoURL];
    __weak InstagramCell *weakSelf = self;
    [self.photoImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            weakSelf.photoImageView.alpha = 0.0;
            weakSelf.photoImageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.photoImageView.alpha = 1.0;
            }];
        }
        else {
            weakSelf.photoImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
    
    // set post's user's profile icon imageview
    NSURL *profilePhotoURL = [NSURL URLWithString:self.post.author.profileImage.url];
    NSURLRequest *profilePicRequest = [NSURLRequest requestWithURL:profilePhotoURL];;
    [self.profileImageView setImageWithURLRequest:profilePicRequest placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            weakSelf.profileImageView.alpha = 0.0;
            weakSelf.profileImageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.profileImageView.alpha = 1.0;
            }];
        }
        else {
            weakSelf.profileImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
    
    // set like button based on if current user liked
    self.likeButton.selected = [self.post isLikedByUser:MyUser.currentUser];
    
    [self updateLikeCountLabel];
}



- (void)toggleLike:(MyUser *)user withCompletion:completion {
    
    if (!self.likeButton.selected) {
        [self.post addLike:MyUser.currentUser withCompletion:completion];
    }
    else {
        [self.post removeLike:MyUser.currentUser withCompletion:completion];
    }
    self.likeButton.selected = !self.likeButton.selected;
    [self updateLikeCountLabel];
}

- (void)updateLikeCountLabel {
    NSUInteger count = self.post.likedBy.count;
    if (count == 0) {
        self.likeButtonToLikeCountLabelConstraint.constant = 0;
        self.likeCountLabelToCaptionLabelConstraint.constant = 0;
        self.likeCountLabel.text = nil;
    }
    else {
        [self.likeCountLabel sizeToFit];
        self.likeButtonToLikeCountLabelConstraint.constant = 8;
        self.likeCountLabelToCaptionLabelConstraint.constant = 4;
        if (count == 1) {
            self.likeCountLabel.text = @"1 like";
        }
        else {
            self.likeCountLabel.text = [NSString stringWithFormat:@"%lu likes", self.post.likedBy.count];
        }
        [self.likeCountLabel sizeToFit];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
