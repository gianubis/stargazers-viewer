//
//  ImageCache.h
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCache : NSObject

+ (ImageCache*)sharedInstance;

// set
- (void)cacheImage:(UIImage*)image forKey:(NSString*)key;
// get
- (UIImage*)getCachedImageForKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
