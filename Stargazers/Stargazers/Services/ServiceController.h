//
//  ServiceController.h
//  Stargazers
//
//  Created by Alessandro Giannubilo on 21/06/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class StargazerModel;

@protocol ServiceControllerDelegate <NSObject>

- (void) updateModelWithSuccess:(StargazerModel*)model;
- (void) updateModelWithErrorMessage:(NSString*)errorMessage;

@end

@interface ServiceController : NSObject

@property(nonatomic, assign) id<ServiceControllerDelegate>delegate;

+ (ServiceController *)sharedInstance;
- (void)fetchdataWithPage:(NSInteger)page withOwner:(nonnull NSString *)owner withRepository:(nonnull NSString *)repository;

@end

NS_ASSUME_NONNULL_END
