//
//  MyUser.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MyUser : PFUser <PFSubclassing>

@property (nonatomic, strong) PFFile * _Nullable profileImage;

+ (PFFile *_Nullable)getPFFileFromImage:(UIImage * _Nullable)image;

+ (void) createUserWithUsername:(NSString *_Nonnull)username withPassword:(NSString *_Nonnull)password withCompletion: (PFBooleanResultBlock _Nullable)completion;

@end
