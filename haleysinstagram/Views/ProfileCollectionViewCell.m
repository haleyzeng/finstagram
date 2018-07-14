//
//  ProfileCollectionViewCell.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "ProfileCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ProfileCollectionViewCell

- (void)setPost:(Post *)post {
    _post = post;
    
    NSURL *photoURL = [NSURL URLWithString:self.post.image.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:photoURL];
    __weak ProfileCollectionViewCell *weakSelf = self;
    [self.profilePostImageView setImageWithURLRequest:request
                                     placeholderImage:nil
                                              success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                                  // imageResponse will be nil if the image is cached
                                                  if (imageResponse) {
                                                      weakSelf.profilePostImageView.alpha = 0.0;
                                                      weakSelf.profilePostImageView.image = image;
                                                      
                                                      //Animate UIImageView back to alpha 1 over 0.3sec
                                                      [UIView animateWithDuration:0.3
                                                                       animations:^{
                                                                           weakSelf.profilePostImageView.alpha = 1.0;
                                                                       }];
                                                  }
                                                  else {
                                                      weakSelf.profilePostImageView.image = image;
                                                  }
                                              } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
}

@end
