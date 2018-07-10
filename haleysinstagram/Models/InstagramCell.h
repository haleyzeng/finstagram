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

@interface InstagramCell : UITableViewCell


@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end
