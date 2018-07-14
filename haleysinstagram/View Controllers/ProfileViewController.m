//
//  ProfileViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "ProfileViewController.h"

#import <Parse/Parse.h>
#import "ProfileCollectionViewCell.h"
#import "ErrorAlert.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *photoTapGesture;

@property (strong, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

#pragma mark - Load View

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    // if profile view was from segue, userProfile already set
    // if not, profile view was from tab bar; set to own profile
    
    if (self.userProfile == nil)
        self.userProfile = MyUser.currentUser;
    
    self.usernameLabel.text = self.userProfile.username;
    
    [self putProfilePicture];
    
    // if profile is self, allow change profile pic
    if ([self.userProfile.objectId isEqualToString:MyUser.currentUser.objectId]) {
        self.photoTapGesture.enabled = YES;
    }
    else { // not self
        self.photoTapGesture.enabled = NO;
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self fetchProfilePosts];
}

- (void)putProfilePicture {
    NSURL *profilePhotoURL = [NSURL URLWithString:self.userProfile.profileImage.url];
    NSURLRequest *profilePicRequest = [NSURLRequest requestWithURL:profilePhotoURL];
    __weak ProfileViewController *weakSelf = self;
    [self.profileImageView setImageWithURLRequest:profilePicRequest
                                 placeholderImage:nil
                                          success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                              // imageResponse will be nil if the image is cached
                                              if (imageResponse) {
                                                  weakSelf.profileImageView.alpha = 0.0;
                                                  weakSelf.profileImageView.image = image;
                                                  
                                                  [UIView animateWithDuration:0.3
                                                                   animations:^{
                                                                       weakSelf.profileImageView.alpha = 1.0;
                                                                   }];
                                              }
                                              else {
                                                  weakSelf.profileImageView.image = image;
                                              }
                                          } failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
    
}

- (void)adjustCollectionViewCellSize {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    
    CGFloat imagesPerRow = 3;
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat itemWidth = (width -
                         (layout.minimumInteritemSpacing *
                          (imagesPerRow - 1)
                          )
                         ) / imagesPerRow;
    
    CGFloat itemHeight = itemWidth;
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchProfilePosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.userProfile];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"image"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self adjustCollectionViewCellSize];
            [self.collectionView reloadData];
            [self updatePostCountLabel];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)updatePostCountLabel {
    NSUInteger count = self.posts.count;
    if (count == 1)
        self.postCountLabel.text = @"1 post";
    else
        self.postCountLabel.text = [NSString stringWithFormat:@"%lu posts", count];
}

#pragma mark - UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfileCollectionViewCell *cell = [collectionView
                                       dequeueReusableCellWithReuseIdentifier:@"profileCollectionViewCell"
                                       forIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    cell.post = post;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - Tap Gesture

- (IBAction)didTapProfileImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    // create action sheet style alert so user can pick
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:@"Change profile picture"
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    // if camera is available, add the option to action sheet
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *camera = [UIAlertAction
                                 actionWithTitle:@"Take a photo"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * _Nonnull action) {
                                     // open camera
                                     imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     [self presentViewController:imagePickerVC
                                                        animated:YES
                                                      completion:nil];
                                 }];
        [alert addAction:camera];
    }
    
    UIAlertAction *library = [UIAlertAction
                              actionWithTitle:@"Choose from library"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * _Nonnull action) {
                                  // open photo library
                                  imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  [self presentViewController:imagePickerVC
                                                     animated:YES
                                                   completion:nil];
                              }];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * _Nonnull action) {
                             }];
    
    [alert addAction:library];
    [alert addAction:cancel];
    
    [self presentViewController:alert
                       animated:YES
                     completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // get image
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    PFFile *newProfileImage = [MyUser getPFFileFromImage:editedImage];
    MyUser.currentUser.profileImage = newProfileImage;
    [MyUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            [ErrorAlert getErrorAlertWithTitle:@"Error saving new profile picture" withMessage:error.localizedDescription];
        }
        else {
            [self setupView];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([segue.identifier isEqualToString:@"fromProfileToDetailViewSegue"]) {
        ProfileCollectionViewCell *tappedCell = sender;
        Post *post = tappedCell.post;
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.post = post;
    }
    
}





@end
