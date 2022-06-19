//
//  StargazerCell.h
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StargazerCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UIImageView *imvAvatar;

@end

NS_ASSUME_NONNULL_END
