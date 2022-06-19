//
//  RestService.h
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class StargazerModel;

@protocol RestServiceDelegate <NSObject>

- (void) fetchDataCompleteWithData:(NSDictionary*)data;
- (void) fetchDataCompleteWithError:(NSString*)error;

@end

@interface RestService : NSObject

@property (nonatomic, assign) id<RestServiceDelegate> delegate;
@property (nonatomic, assign) long lastPage;


+ (RestService *)sharedInstance;
- (void)fetchdataWithPage:(NSInteger)page withOwner:(NSString*)owner withRepository:(NSString*)repository;

@end

NS_ASSUME_NONNULL_END
