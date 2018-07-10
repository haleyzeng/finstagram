//
//  ErrorAlert.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/10/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "ErrorAlert.h"

@implementation ErrorAlert

+(UIAlertController *)getErrorAlertWithTitle:(NSString *)title withMessage:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:ok];

    return alert;
}

@end
