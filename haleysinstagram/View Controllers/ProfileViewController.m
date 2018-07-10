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

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self collectionViewCellSize];
    MyUser *user = MyUser.currentUser;
    self.userProfile = user;
    [self profilePicture];
    self.usernameLabel.text = self.userProfile.username;
    [self fetchProfilePosts];
    // Do any additional setup after loading the view.
}

- (void)profilePicture {
    NSLog(@"profile: %@", self.userProfile);
    NSLog(@"profile: %@", MyUser.currentUser);
    NSURL *profilePhotoURL = [NSURL URLWithString:self.userProfile.profileImage.url];
    NSURLRequest *profilePicRequest = [NSURLRequest requestWithURL:profilePhotoURL];
    NSLog(@"profile url: %@", profilePhotoURL);
    __weak ProfileViewController *weakSelf = self;
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

- (void)fetchProfilePosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    MyUser *current = MyUser.currentUser;
    [query whereKey:@"author" equalTo:current];
    [query includeKey:@"author"];
    [query includeKey:@"image"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)collectionViewCellSize {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    CGFloat imagesPerRow = 3;
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat itemWidth = (width - (layout.minimumInteritemSpacing * (imagesPerRow - 1))) / imagesPerRow;
    
    CGFloat itemHeight = itemWidth;
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfileCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"profileCollectionViewCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    cell.post = post;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}


#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ProfileCollectionViewCell *tappedCell = sender;
    Post *post = tappedCell.post;
   DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.post = post;

}





@end
