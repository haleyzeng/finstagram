//
//  CommentsViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/11/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "CommentsViewController.h"

#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"
#import "CommentCell.h"
#import "Comment.h"
#import "ErrorAlert.h"


@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIStackView *commenterStackView;
@property (weak, nonatomic) IBOutlet UIImageView *commenterProfileIcon;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;

@property (strong, nonatomic) NSArray *comments;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCommenterIcon];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchComments];
    
    if (self.writeCommentImmediately)
        [self.commentTextField becomeFirstResponder];
}

- (void)fetchComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query orderByAscending:@"createdAt"];
    [query whereKey:@"post" equalTo:self.post];
    [query includeKey:@"author"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable comments, NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alert = [ErrorAlert getErrorAlertWithTitle:@"Error loading comments" withMessage:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            self.comments = comments;
            [self.tableView reloadData];
        }
        
    }];
}


- (void)setupCommenterIcon {
    NSURL *photoURL = [NSURL URLWithString:MyUser.currentUser.profileImage.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:photoURL];
    __weak CommentsViewController *weakSelf = self;
    [self.commenterProfileIcon setImageWithURLRequest:request
                                     placeholderImage:nil
                                              success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                                  // imageResponse will be nil if the image is cached
                                                  if (imageResponse) {
                                                      weakSelf.commenterProfileIcon.alpha = 0.0;
                                                      weakSelf.commenterProfileIcon.image = image;
                                                      
                                                      //Animate UIImageView back to alpha 1 over 0.3sec
                                                      [UIView animateWithDuration:0.3 animations:^{
                                                          weakSelf.commenterProfileIcon.alpha = 1.0;
                                                      }];
                                                  }
                                                  else {
                                                      weakSelf.commenterProfileIcon.image = image;
                                                  }
                                              } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    commentCell.comment = self.comments[indexPath.row];
    
    return commentCell;
}

#pragma mark - Button Functionality

- (IBAction)didTapPost:(id)sender {
    [Comment postCommentOnPost:self.post
                      withText:self.commentTextField.text
                withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        UIAlertController *alert = [ErrorAlert getErrorAlertWithTitle:@"Error posting comment" withMessage:error.localizedDescription];
                        [self presentViewController:alert
                                           animated:YES
                                         completion:nil];
                    }
                    else {
                        NSLog(@"successfully posted comment");
                        self.commentTextField.text = @"";
                        [self fetchComments];
                        [self.delegate didPostAComment];
                    }
                }];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
