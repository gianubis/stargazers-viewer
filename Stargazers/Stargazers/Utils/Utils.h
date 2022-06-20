//
//  Utils.h
//  Stargazers
//
//  Created by Alessandro Giannubilo on 20/06/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (void) showAlertWithTitle:(NSString*)title andMessage:(NSString*)message andViewController:(UIViewController*)controller;

@end

NS_ASSUME_NONNULL_END
