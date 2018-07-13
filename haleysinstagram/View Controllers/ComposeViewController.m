//
//  ComposeViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "ComposeViewController.h"

#import "Post.h"
#import "ErrorAlert.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *composeImageView;
@property (weak, nonatomic) IBOutlet UITextView *composeCaptionTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // resize image to square measuring full screen width
    CGFloat screenWidth = self.view.frame.size.width;
    CGSize newSize = CGSizeMake(screenWidth, screenWidth);
    UIImage *resizedImage = [self resizeImage:self.image withSize:newSize];
    self.image = resizedImage;
    [self.composeImageView setImage:self.image];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Bar Button Functionality

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)didTapPost:(id)sender {
    [Post postUserImage:self.image
            withCaption:self.composeCaptionTextView.text
         withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
             if (succeeded) {
                 [self.delegate didFinishPost];
                 [self dismissViewControllerAnimated:YES completion:^{}];
             }
             else {
                 UIAlertController *alert = [ErrorAlert getErrorAlertWithTitle:@"Error posting" withMessage:error.localizedDescription];
                 [self presentViewController:alert animated:YES completion:nil];
             }
         }];
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
