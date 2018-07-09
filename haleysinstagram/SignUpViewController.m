//
//  SignUpViewController.m
//  haleysinstagram
//
//  Created by Haley Zeng on 7/9/18.
//  Copyright © 2018 Haley Zeng. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

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

- (void)showErrorAlertWithTitle:(NSString *)title withMessage:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)didTapSignUpButton:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    if ([username isEqualToString:@""] || [password isEqualToString:@""] || [confirmPassword isEqualToString:@""]) {
        [self showErrorAlertWithTitle:@"Error"
                          withMessage:@"username namd password required"];
    }
    else if (![password isEqualToString:confirmPassword]) {
        [self showErrorAlertWithTitle:@"Error" withMessage:@"Passwords do not match"];
    }
    else {
        PFUser *newUser = [PFUser new];
        newUser.username = username;
        newUser.password = password;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error != nil){
                [self showErrorAlertWithTitle:@"Error signing up" withMessage:error.localizedDescription];
            }
            else {
                [self performSegueWithIdentifier:@"successfulSignUpSegue" sender:nil];
            }
        }];
    }
}


- (IBAction)didTapGoToLoginButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

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
