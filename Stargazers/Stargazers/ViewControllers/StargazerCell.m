//
//  StargazerCell.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import "StargazerCell.h"

@implementation StargazerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.imvAvatar.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.imvAvatar.layer.cornerRadius=20;
    self.imvAvatar.layer.borderWidth=2.0;
    self.imvAvatar.layer.masksToBounds = YES;
    self.imvAvatar.layer.borderColor=[[UIColor blueColor] CGColor];

}

@end
