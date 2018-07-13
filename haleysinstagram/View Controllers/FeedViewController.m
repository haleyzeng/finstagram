//
//  FeedViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "FeedViewController.h"

#import <Parse/Parse.h>
#import "AppDelegate.h"

#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"
#import "ProfileViewController.h"
#import "CommentsViewController.h"

#import "InstagramCell.h"
#import "Post.h"
#import "ErrorAlert.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ComposeViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIRefreshControl *refreshController;

@end

@implementation FeedViewController

#pragma mark - View Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupPullToRefresh];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchFeed];
}

- (void)fetchFeed {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"image"];
    [query includeKey:@"likedBy"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        [self.refreshController endRefreshing];
        if (error != nil) {
            UIAlertController *alert = [ErrorAlert getErrorAlertWithTitle:@"Error loading feed" withMessage:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            self.posts = posts;
            [self.tableView reloadData];
        }
    }];
}

- (void)setupPullToRefresh {
    // initialize refresh controller
    self.refreshController = [[UIRefreshControl alloc] init];
    
    // attach refresh functionality to refresh controller
    [self.refreshController addTarget:self
                               action:@selector(fetchFeed)
                     forControlEvents:UIControlEventValueChanged];
    
    // add refresh controller to view
    [self.tableView insertSubview:self.refreshController atIndex:0];
}

#pragma mark - ComposeViewDelegate

-(void)didFinishPost {
    [self fetchFeed];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InstagramCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstagramCell"];
    
    
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    
    UITapGestureRecognizer *iconGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfileIcon:)];
    [cell.profileImageView addGestureRecognizer:iconGesture];
    cell.profileImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *labelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUsernameLabel:)];
    [cell.usernameLabel addGestureRecognizer:labelGesture];
    cell.usernameLabel.userInteractionEnabled = YES;
    
    return cell;
}

#pragma mark - Bar Button Functionality

- (IBAction)didTapLogout:(id)sender {
    
    [MyUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alert = [ErrorAlert getErrorAlertWithTitle:@"Error logging out" withMessage:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
        }
    }];
}

- (IBAction)didTapNewPostButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    // if camera is not an option, show photo library
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
    // if camera is an option, allow user to pick between
    // camera and library
    else {
        // create action sheet style alert so user can pick
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // open camera
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        
        UIAlertAction *library = [UIAlertAction actionWithTitle:@"Choose from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // open photo library
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert addAction:camera];
        [alert addAction:library];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // get image
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // create instance of compose view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *composeNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    ComposeViewController *composeViewController = (ComposeViewController *)composeNavigationController.topViewController;
    
    composeViewController.delegate = self;
    
    // pass image to compose view controller
    composeViewController.image = editedImage;
    
    // dismiss picker and present compose view
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:composeNavigationController animated:YES completion:^{
        }];
    }];
   
}

#pragma mark - Table Cell Button Functionality

- (IBAction)didTapUsernameLabel:(id)sender {
    
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    UILabel *label = (UILabel *)gesture.view;
    InstagramCell *tappedCell = (InstagramCell *)label.superview.superview;
    [self performSegueWithIdentifier:@"goToProfileViewSegue" sender:tappedCell];
}

- (IBAction)didTapProfileIcon:(id)sender {
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    UIImageView *profileIcon = (UIImageView *) gesture.view;
    InstagramCell *tappedCell = (InstagramCell *)profileIcon.superview.superview;
    [self performSegueWithIdentifier:@"goToProfileViewSegue" sender:tappedCell];
}

- (IBAction)didTapViewComments:(id)sender {
    UIButton *button = sender;
    InstagramCell *tappedCell = (InstagramCell *)button.superview.superview.superview;
    [self performSegueWithIdentifier:@"goToCommentsSegue" sender:tappedCell];
}

- (IBAction)didTapWriteCommentButton:(id)sender {
    UIButton *button = sender;
    InstagramCell *tappedCell = (InstagramCell *)button.superview.superview.superview.superview;
    [self performSegueWithIdentifier:@"goToCommentsAndWriteSegue" sender:tappedCell];
}


- (IBAction)didTapLikeButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    InstagramCell *cell = (InstagramCell *) button.superview.superview.superview.superview;
    [cell toggleLike:MyUser.currentUser withCompletion:^(BOOL succeeded, NSError * _Nullable error){
        if (error) {
            UIAlertController *alert = [ErrorAlert getErrorAlertWithTitle:@"Error toggling like" withMessage:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    // in case the "# likes" line is being added/taken away,
    // allow tableview cell to readjust tableview size
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - CommentsViewControllerDelegate


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     InstagramCell *tappedCell = sender;
     Post *post = tappedCell.post;
     
     if ([segue.identifier isEqualToString:@"goToDetailViewSegue"]) {
         DetailViewController *detailViewController = [segue destinationViewController];
         detailViewController.post = post;
         detailViewController.delegate = tappedCell;
     }
     else if ([segue.identifier isEqualToString:@"goToProfileViewSegue"]) {
         ProfileViewController *profileViewController = [segue destinationViewController];
         profileViewController.userProfile = tappedCell.post.author;
     }
     else if ([segue.identifier isEqualToString:@"goToCommentsSegue"]) {
         CommentsViewController *commentsViewController = [segue destinationViewController];
         commentsViewController.delegate = tappedCell;
         commentsViewController.post = tappedCell.post;
         commentsViewController.writeCommentImmediately = NO;
     }
     else if ([segue.identifier isEqualToString:@"goToCommentsAndWriteSegue"]) {
         CommentsViewController *commentsViewController = [segue destinationViewController];
         commentsViewController.delegate = tappedCell;
         commentsViewController.post = tappedCell.post;
         commentsViewController.writeCommentImmediately = YES;
     }
 }

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
