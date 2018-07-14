//
//  SignUpViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "SignUpViewController.h"

#import <Parse/Parse.h>
#import "ErrorAlert.h"
#import "Post.h"
#import "MyUser.h"


@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Manual Segue

- (IBAction)didTapSignUpButton:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    if ([username isEqualToString:@""] ||
        [password isEqualToString:@""] ||
        [confirmPassword isEqualToString:@""]) {
        UIAlertController *alert = [ErrorAlert getErrorAlertWithTitle:@"Error"
                                                          withMessage:@"username namd password required"];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
    else if (![password isEqualToString:confirmPassword]) {
        UIAlertController *alert = [ErrorAlert getErrorAlertWithTitle:@"Error"
                                                          withMessage:@"Passwords do not match"];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
    else {
        [MyUser createUserWithUsername:username
                          withPassword:password
                        withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                            if (error != nil){
                                UIAlertController *alert = [ErrorAlert
                                                            getErrorAlertWithTitle:@"Error signing up"
                                                            withMessage:error.localizedDescription];
                                [self presentViewController:alert
                                                   animated:YES
                                                 completion:nil];
                            }
                            else {
                                [self performSegueWithIdentifier:@"successfulSignUpSegue" sender:nil];
                            }
                        }];
    }
}

- (IBAction)didTapGoToLoginButton:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{}];
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
