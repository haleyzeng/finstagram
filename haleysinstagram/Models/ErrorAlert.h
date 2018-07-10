//
//  ErrorAlert.h
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ErrorAlert : NSObject

+ (UIAlertController *)getErrorAlertWithTitle:(NSString *)title withMessage:(NSString *)msg;

@end
