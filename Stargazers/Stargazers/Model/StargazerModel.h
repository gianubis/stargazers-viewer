//
//  StargazerModel.h
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StargazerModel : NSObject

@property(nonatomic, strong) NSMutableArray *stargazers;
@property (nonatomic, assign) long nextPage;
@property (nonatomic, assign) long lastPage;

@end

NS_ASSUME_NONNULL_END
