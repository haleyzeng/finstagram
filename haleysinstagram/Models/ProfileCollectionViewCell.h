//
//  ProfileCollectionViewCell.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Post.h"

@interface ProfileCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *profilePostImageView;

@end
