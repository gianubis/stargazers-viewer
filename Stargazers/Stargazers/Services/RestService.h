//
//  RestService.h
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestService : NSObject

@property (nonatomic, assign) long lastPage;

- (void)fetchdataWithPage:(NSInteger)page withOwner:(nonnull NSString *)owner withRepository:(nonnull NSString *)repository andCompletionHandler:(void (^)(NSDictionary * _Nullable dictionary, NSString * _Nullable errorMessage))comp;

@end

NS_ASSUME_NONNULL_END
