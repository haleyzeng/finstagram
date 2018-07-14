//
//  LoginViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "LoginViewController.h"

#import <Parse/Parse.h>
#import "ErrorAlert.h"
#import "MyUser.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Manual Segue

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        UIAlertController *alert = [ErrorAlert getErrorAlertWithTitle:@"Error"
                                                          withMessage:@"username namd password required"];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [MyUser logInWithUsernameInBackground:username
                                     password:password
                                        block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                                            if (error != nil) {
                                                UIAlertController *alert = [ErrorAlert
                                                                            getErrorAlertWithTitle:@"Error Logging In"
                                                                            withMessage:error.localizedDescription];
                                                [self presentViewController:alert
                                                                   animated:YES
                                                                 completion:nil];
                                            }
                                            else {
                                                [self performSegueWithIdentifier:@"successfulLoginSegue"
                                                                          sender:nil];
                                            }
                                        }];
    }
}

- (IBAction)didTapGoToSignUpButton:(id)sender {
    [self performSegueWithIdentifier:@"goToSignUpViewSegue"
                              sender:nil];
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
