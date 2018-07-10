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
    InstagramCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"InstagramCell"];
    Post *post = self.posts[indexPath.row];
    cell.post = post;
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

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"goToDetailViewSegue"]) {
         InstagramCell *tappedCell = sender;
         Post *post = tappedCell.post;
        DetailViewController *detailViewController = [segue destinationViewController];
         detailViewController.post = post;
     }
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


@end
