//
//  ComposeViewController.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComposeViewDelegate

-(void)didFinishPost;

@end

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) id<ComposeViewDelegate> delegate;
@property (strong, nonatomic) UIImage *image;

@end
