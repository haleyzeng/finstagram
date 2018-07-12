//
//  CommentCell.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/11/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Comment.h"

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) Comment *comment;

@property (weak, nonatomic) IBOutlet UIImageView *commenterImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCreatedAtLabel;

@end
