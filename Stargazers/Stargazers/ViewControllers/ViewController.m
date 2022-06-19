//
//  ViewController.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import "ViewController.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

#define SEGUE_IDENTIFIER @"showStargazers"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *lblOwner;
@property (nonatomic, weak) IBOutlet UITextField *txtOwner;
@property (nonatomic, weak) IBOutlet UILabel *lblRepository;
@property (nonatomic, weak) IBOutlet UITextField *txtRepository;
@property (nonatomic, weak) IBOutlet UIButton *btnShow;

- (IBAction)btnShowTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.txtOwner.placeholder = @"repository owner";
    self.txtRepository.placeholder = @"repository name";

}

#pragma mark - Actions
- (void)btnShowTapped:(id)sender {

    // check internet connection
    if ([self connected]) {
        if ((self.txtOwner.text.length > 0) && (self.txtOwner.text.length > 0)) {
            
            // navigate to tableview
            [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self];

        } else {
            
            // show message if textfields are not set
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Repository Owner and Repository Name must be set" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        
        // show message if connection is not present
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Internet connection is not present" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Private Methods
- (BOOL)connected {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark - Unit Test data

- (void)testConnection {
    if ([self connected]) {
        self.testIsConnected = true;
    } else {
        self.testIsConnected = false;
    }
}

@end
