//
//  DetailViewController.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@protocol DetailViewControllerDelegate

- (void)didTapLikeInDetailViewWithCompletion:completion;

@end


@interface DetailViewController : UIViewController

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) id<DetailViewControllerDelegate> delegate;

@end
