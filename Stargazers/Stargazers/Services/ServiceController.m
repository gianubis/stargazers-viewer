//
//  ServiceController.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 21/06/22.
//

#import "ServiceController.h"
#import "StargazerModel.h"
#import "RestService.h"

@interface ServiceController()

@property(nonatomic, strong) RestService *rs;
@property(nonatomic, strong) StargazerModel *stargazerModel;

@end


@implementation ServiceController

static ServiceController *_sharedInstance = nil;

+ (ServiceController *)sharedInstance {
    @synchronized([ServiceController class]) {
        if (!_sharedInstance)
          _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stargazerModel = [[StargazerModel alloc] init];
        self.rs = [[RestService alloc] init];
    }
    return self;
}

- (void)fetchdataWithPage:(NSInteger)page withOwner:(nonnull NSString *)owner withRepository:(nonnull NSString *)repository {
    [self.rs fetchdataWithPage:page withOwner:owner withRepository:repository andCompletionHandler:^(NSDictionary * _Nullable dictionary, NSString * _Nullable errorMessage) {
       
        if (dictionary) {
            NSArray *newData = [dictionary objectForKey:@"Data"];
            if (newData.count > 0) {
                
                // update model
                self.stargazerModel.lastPage = [[dictionary objectForKey:@"LastPage"] integerValue];
                [self.stargazerModel.stargazers addObjectsFromArray:[dictionary objectForKey:@"Data"]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    // navigate to tableview
                    [self.delegate updateModelWithSuccess:self.stargazerModel];
                });
                
            } else {

                dispatch_async(dispatch_get_main_queue(), ^{
                    // show message to inform user that the repository has no stargazers
                    NSString *message = [NSString stringWithFormat:@"This repository has no stargazers"];
                    [self.delegate updateModelWithErrorMessage:message];
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
                [self.delegate updateModelWithErrorMessage:message];
            });
        }

        
    }];
}



@end
