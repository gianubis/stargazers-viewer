//
//  ViewController.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import "ViewController.h"
#import "StargazersViewController.h"
#import "StargazerModel.h"
#import "Reachability.h"
#import "RestService.h"
#import "Utils.h"
#import "ServiceController.h"

#import <SystemConfiguration/SystemConfiguration.h>

#define SEGUE_IDENTIFIER @"showStargazers"

@interface ViewController () <ServiceControllerDelegate>

@property (nonatomic, strong) StargazerModel *stargazerModel;

@property (nonatomic, weak) IBOutlet UILabel *lblOwner;
@property (nonatomic, weak) IBOutlet UITextField *txtOwner;
@property (nonatomic, weak) IBOutlet UILabel *lblRepository;
@property (nonatomic, weak) IBOutlet UITextField *txtRepository;
@property (nonatomic, weak) IBOutlet UIButton *btnShow;

- (IBAction)btnShowTapped:(id)sender;

@end

@implementation ViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init model
    if (!self.stargazerModel) {
        self.stargazerModel = [[StargazerModel alloc] init];
        self.stargazerModel.stargazers = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [ServiceController sharedInstance].delegate = self;

    self.txtOwner.placeholder = @"repository owner";
    self.txtRepository.placeholder = @"repository name";
}

#pragma mark - Actions
- (void)btnShowTapped:(id)sender {

    // check internet connection
    if ([self connected]) {
        if ((self.txtOwner.text.length > 0) && (self.txtRepository.text.length > 0)) {
            
            // reset model
            [self.stargazerModel.stargazers removeAllObjects];
            [self.stargazerModel setLastPage:0];
            
            // call service
            [[ServiceController sharedInstance] fetchdataWithPage:1 withOwner:self.txtOwner.text withRepository:self.txtRepository.text];
        } else {
            // show message if textfields are not set
            [Utils showAlertWithTitle:@"Warning" andMessage:@"Repository Owner and Repository Name must be set" andViewController:self];
        }
    } else {
        // show message if connection is not present
        [Utils showAlertWithTitle:@"Warning" andMessage:@"Internet connection is not present" andViewController:self];
    }
}

- (void)updateModelWithSuccess:(StargazerModel *)model {
    self.stargazerModel = model;
    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self];
}

- (void)updateModelWithErrorMessage:(NSString *)errorMessage {
    NSString *message = @"";
    if ([errorMessage isEqualToString:@"404"]) {
        message = @"Owner or repository not found.";
    } else {
        message = [NSString stringWithFormat:@"No data retrieved with error: %@", errorMessage];
    }
    [Utils showAlertWithTitle:@"Error" andMessage:message andViewController:self];
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

    if ([[segue identifier] isEqualToString:SEGUE_IDENTIFIER])
    {
        StargazersViewController *vc = (StargazersViewController*)segue.destinationViewController;
        vc.strOwner = self.txtOwner.text;
        vc.strRepository = self.txtRepository.text;
        vc.stargazerModel = self.stargazerModel;
    }
}

@end
