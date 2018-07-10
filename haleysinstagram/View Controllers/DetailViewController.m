//
//  DetailViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.usernameLabel.text = self.post.author.username;
    self.captionLabel.text = self.post.caption;
    
    // set date
    NSDate *createdAtDate = self.post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    formatter.dateStyle = NSDateFormatterLongStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *dateString = [formatter stringFromDate:createdAtDate];
    self.dateLabel.text = dateString;
    
    NSURL *photoURL = [NSURL URLWithString:self.post.image.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:photoURL];
    __weak DetailViewController *weakSelf = self;
    [self.detailImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            weakSelf.detailImageView.alpha = 0.0;
            weakSelf.detailImageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.detailImageView.alpha = 1.0;
            }];
        }
        else {
            weakSelf.detailImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
}


#pragma mark - Bar Button Functionality

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
