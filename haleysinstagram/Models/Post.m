//
//  Post.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "Post.h"


@implementation Post

@dynamic author, caption, image, likedBy, comments;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage:(UIImage * _Nullable)image withCaption: (NSString * _Nullable)caption withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.author = MyUser.currentUser;
    newPost.caption = caption;
    newPost.image = [MyUser getPFFileFromImage:image];
    
    newPost.likedBy = [[NSArray alloc] init];
    newPost.comments = [[NSArray alloc] init];
    
    [newPost saveInBackgroundWithBlock:completion];
}



- (void)addLike:(MyUser *)user withCompletion:completion {
    NSRange arrayRange = (NSRange){0, self.likedBy.count};
    
    NSMutableArray *mutableLikedBy = [NSMutableArray arrayWithArray:self.likedBy];
    
    NSUInteger insertionIndex = [mutableLikedBy indexOfObject:MyUser.currentUser
                                         inSortedRange: arrayRange
                                               options:NSBinarySearchingInsertionIndex
                                       usingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                                           MyUser *user1 = (MyUser *)obj1;
                                           MyUser *user2 = (MyUser *)obj2;
                                           NSComparisonResult result = [user1.objectId compare:user2.objectId];
                                           return result;
                                       }];

    [mutableLikedBy insertObject:MyUser.currentUser atIndex:insertionIndex];
    self.likedBy = [mutableLikedBy copy];
    [self saveInBackgroundWithBlock:completion];
}

- (void)removeLike:(MyUser *)user withCompletion:completion{
    NSRange arrayRange = (NSRange){0, self.likedBy.count};
    NSMutableArray *mutableLikedBy = [NSMutableArray arrayWithArray:self.likedBy];
    
    // remove current user from likedByArray using binary search
    NSUInteger index = [mutableLikedBy indexOfObject:MyUser.currentUser
                                inSortedRange:arrayRange options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                                    MyUser *user1 = (MyUser *)obj1;
                                    MyUser *user2 = (MyUser *)obj2;
                                    NSComparisonResult result = [user1.objectId compare:user2.objectId];
                                    return result;
                                }];
    [mutableLikedBy removeObjectAtIndex:index];
    self.likedBy = [mutableLikedBy copy];
    [self saveInBackgroundWithBlock:completion];
}

- (BOOL)isLikedByUser:(MyUser *)user {
    NSRange arrayRange = (NSRange){0, self.likedBy.count};
    NSUInteger index = [self.likedBy indexOfObject:MyUser.currentUser
                                inSortedRange:arrayRange options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                                    MyUser *user1 = (MyUser *)obj1;
                                    MyUser *user2 = (MyUser *)obj2;
                                    NSComparisonResult result = [user1.objectId compare:user2.objectId];
                                    return result;
                                }];
    return (index < self.likedBy.count);
}

@end
