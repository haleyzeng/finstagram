//
//  CommentCell.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/11/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "CommentCell.h"

#import "UIImageView+AFNetworking.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setComment:(Comment *)comment {
    _comment = comment;
    NSAttributedString *formattedCommentText = [comment makeFormattedCommentTextFromUnformattedCommentText];
    self.commentTextLabel.attributedText = formattedCommentText;
    __weak CommentCell *weakSelf = self;
    // set post's user's profile icon imageview
    NSURL *profilePhotoURL = [NSURL URLWithString:self.comment.post.author.profileImage.url];
    NSURLRequest *profilePicRequest = [NSURLRequest requestWithURL:profilePhotoURL];;
    [self.commenterImageView setImageWithURLRequest:profilePicRequest placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            weakSelf.commenterImageView.alpha = 0.0;
            weakSelf.commenterImageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.commenterImageView.alpha = 1.0;
            }];
        }
        else {
            weakSelf.commenterImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
