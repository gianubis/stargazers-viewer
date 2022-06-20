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

#import <SystemConfiguration/SystemConfiguration.h>

#define SEGUE_IDENTIFIER @"showStargazers"

@interface ViewController ()

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
            [RestService sharedInstance].lastPage = 0;
            
            // call service
            [self callRestService];
            
        } else {
            // show message if textfields are not set
            [Utils showAlertWithTitle:@"Warning" andMessage:@"Repository Owner and Repository Name must be set" andViewController:self];
        }
    } else {
        // show message if connection is not present
        [Utils showAlertWithTitle:@"Warning" andMessage:@"Internet connection is not present" andViewController:self];
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
- (void) callRestService {
    
    // call service first time to load data
    self.stargazerModel.nextPage = 1;
    
    __block ViewController *blocksafeSelf = self;
    [[RestService sharedInstance] fetchdataWithPage:self.stargazerModel.nextPage withOwner:self.txtOwner.text withRepository:self.txtRepository.text andCompletionHandler:^(NSDictionary * _Nullable dictionary, NSString * _Nullable errorMessage) {
        
        if (dictionary) {
            NSArray *newData = [dictionary objectForKey:@"Data"];
            if (newData.count > 0) {
                
                // update model
                blocksafeSelf.stargazerModel.lastPage = [[dictionary objectForKey:@"LastPage"] integerValue];
                [blocksafeSelf.stargazerModel.stargazers addObjectsFromArray:[dictionary objectForKey:@"Data"]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    // navigate to tableview
                    [blocksafeSelf performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self];
                });
                
            } else {

                dispatch_async(dispatch_get_main_queue(), ^{
                    // show message to inform user that the repository has no stargazers
                    NSString *message = [NSString stringWithFormat:@"This repository has no stargazers"];
                    [Utils showAlertWithTitle:@"Warning" andMessage:message andViewController:blocksafeSelf];
                });
            }
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // show message with error
                NSString *message = @"";
                if ([errorMessage isEqualToString:@"404"]) {
                    message = @"Owner or repository not found.";
                } else {
                    message = [NSString stringWithFormat:@"No data retrieved with error: %@", errorMessage];
                }
                [Utils showAlertWithTitle:@"Error" andMessage:message andViewController:blocksafeSelf];
            });
        }
    }];
}

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
