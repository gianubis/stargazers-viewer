//
//  ImageCache.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import "ImageCache.h"

@interface ImageCache ()

@property (nonatomic, strong) NSCache *imageCache;

@end

@implementation ImageCache

static ImageCache *_sharedInstance = nil;

+ (ImageCache*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ImageCache alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)cacheImage:(UIImage*)image forKey:(NSString*)key {
    [self.imageCache setObject:image forKey:key];
}

- (UIImage*)getCachedImageForKey:(NSString*)key {
    return [self.imageCache objectForKey:key];
}

@end
