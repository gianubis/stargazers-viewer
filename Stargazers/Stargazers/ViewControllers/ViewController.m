//
//  ViewController.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import "ViewController.h"

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
}

#pragma mark - Actions
- (void)btnShowTapped:(id)sender {

    // navigate to tableview
    [self performSegueWithIdentifier:SEGUE_IDENTIFIER sender:self];

}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
