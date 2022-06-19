//
//  StargazersViewController.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import "StargazersViewController.h"
#import "StargazerCell.h"
#import "RestService.h"
#import "ImageCache.h"

@interface StargazersViewController () <RestServiceDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tblView;
@property (nonatomic, weak) IBOutlet UILabel *lblOwnerTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblOwnerName;
@property (nonatomic, weak) IBOutlet UILabel *lblRepoTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblRepoName;

@end

@implementation StargazersViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    // update owner and repo on tableview header
    self.lblOwnerName.text = self.strOwner;
    self.lblRepoName.text = self.strRepository;
        
    // remove scrollbar from table
    [self.tblView setShowsHorizontalScrollIndicator:NO];
    [self.tblView setShowsVerticalScrollIndicator:NO];
        
    [RestService sharedInstance].delegate = self;
}

#pragma mark - RestService Delegate
- (void)fetchDataCompleteWithData:(NSDictionary *)data {

    // update model
    self.stargazerModel.lastPage = [[data objectForKey:@"LastPage"] integerValue];
    [self.stargazerModel.stargazers addObjectsFromArray:[data objectForKey:@"Data"]];

    [self.tblView reloadData];
}

- (void)fetchDataCompleteWithError:(NSString *)error {
    
    NSString *message = [NSString stringWithFormat:@"No data retrieved with error: %@", error];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stargazerModel.stargazers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StargazerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StargazerCell" forIndexPath:indexPath];
    
    // remove selection color
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    // get nickname of stargazer
    NSDictionary *dict = self.stargazerModel.stargazers[indexPath.row];
    cell.lblName.text = [dict objectForKey:@"login"];

    //get a dispatch queue lo fetch image
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{

        NSString *urlImage = [dict objectForKey:@"avatar_url"];
        UIImage *image = [[ImageCache sharedInstance] getCachedImageForKey:urlImage];
        if(image) {
            NSLog(@"This is cached");
        } else {
            NSURL *imageURL = [NSURL URLWithString:urlImage];
            image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageURL]];
            if(image) {
                NSLog(@"Caching ....");
                [[ImageCache sharedInstance] cacheImage:image forKey:urlImage];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imvAvatar.image = image;
        });

    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row == self.stargazerModel.stargazers.count - 3) && self.stargazerModel.nextPage < self.stargazerModel.lastPage) {
        self.stargazerModel.nextPage++;
        
        // call service with next page to load more data
        [[RestService sharedInstance] fetchdataWithPage:self.stargazerModel.nextPage withOwner:self.strOwner withRepository:self.strRepository];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.stargazerModel.stargazers[indexPath.row];
    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"html_url"]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
