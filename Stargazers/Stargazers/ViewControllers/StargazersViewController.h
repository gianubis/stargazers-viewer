//
//  StargazersViewController.h
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import <UIKit/UIKit.h>
#import "StargazerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StargazersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) StargazerModel *stargazerModel;

@property (nonatomic, strong) NSString *strOwner;
@property (nonatomic, strong) NSString *strRepository;

@end

NS_ASSUME_NONNULL_END
