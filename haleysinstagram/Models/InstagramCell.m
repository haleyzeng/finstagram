//
//  InstagramCell.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "InstagramCell.h"
#import "UIImageView+AFNetworking.h"

@implementation InstagramCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.usernameLabel.text = self.post.author.username;
    self.captionLabel.text = self.post.caption;
    NSLog(@"image url: %@", self.post.image.url);
 //   [self.photoImageView
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
