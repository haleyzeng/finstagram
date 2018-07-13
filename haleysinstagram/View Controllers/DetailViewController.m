//
//  DetailViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CommentsViewController.h"
#import "Comment.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DetailViewController

#pragma mark - Load View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = self.post.author.username;
    [self updateProfileIcon];
    
    [self updateLikeCountLabel];
    self.likeButton.selected = [self.post isLikedByUser:MyUser.currentUser];
    
    [self updatePhoto];
    [self updateCaption];
    [self updateDateLabel];
}

- (void)updateProfileIcon {
    // set profile picture
    __weak DetailViewController *weakSelf = self;
    NSURL *profilePhotoURL = [NSURL URLWithString:self.post.author.profileImage.url];
    NSURLRequest *profilePicRequest = [NSURLRequest requestWithURL:profilePhotoURL];;
    [self.profileImageView setImageWithURLRequest:profilePicRequest placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            weakSelf.profileImageView.alpha = 0.0;
            weakSelf.profileImageView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.profileImageView.alpha = 1.0;
            }];
        }
        else {
            weakSelf.profileImageView.image = image;
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
}

- (void)updatePhoto {
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

- (void)updateLikeCountLabel {
    NSUInteger count = self.post.likedBy.count;
    if (count == 0) {
        self.likeCountLabel.text = @"No likes";
    }
    else if (count == 1) {
        self.likeCountLabel.text = @"1 like";
    }
    else {
        self.likeCountLabel.text = [NSString stringWithFormat:@"%lu likes", self.post.likedBy.count];
    }
}

- (void)updateCaption {
    if (![self.post.caption isEqualToString:@""]) {
        Comment *caption = [[Comment alloc] initWithPost:self.post author:self.post.author commentContent:self.post.caption];
        
        self.captionLabel.hidden = NO;
        self.captionLabel.attributedText = [caption makeFormattedCommentTextFromUnformattedCommentText];
    }
    else {
        self.captionLabel.hidden = YES;
        self.captionLabel.text = nil;
    }
}

- (void)updateDateLabel {
    NSDate *createdAtDate = self.post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    formatter.dateStyle = NSDateFormatterLongStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *dateString = [formatter stringFromDate:createdAtDate];
    self.dateLabel.text = dateString;
}

#pragma mark - Button Functionality

- (IBAction)didTapLikeButton:(id)sender {
    [self.delegate didTapLikeInDetailViewWithCompletion:^(BOOL succeeded, NSError * _Nullable error){
        
            self.likeButton.selected = !self.likeButton.selected;
            [self updateLikeCountLabel];
    }];

}


#pragma mark - Bar Button Functionality

- (IBAction)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromDetailGoToCommentsSegue"]){
        CommentsViewController *commentsViewController = (CommentsViewController *)[segue destinationViewController];
        commentsViewController.post = self.post;
        commentsViewController.writeCommentImmediately = YES;
    }
}


@end
