//
//  CommentsViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/11/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "CommentsViewController.h"

#import <Parse/Parse.h>
#import "CommentCell.h"
#import "Comment.h"
#import "ErrorAlert.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *comments;

@property (weak, nonatomic) IBOutlet UIStackView *commenterStackView;
@property (weak, nonatomic) IBOutlet UIImageView *commenterProfileIcon;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;


@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    commentCell.comment = self.comments[indexPath.row];
    return commentCell;
}



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
                    }
                }];
}

- (void)fetchComments {
    
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
