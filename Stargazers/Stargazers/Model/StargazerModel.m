//
//  StargazerModel.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import "StargazerModel.h"

@implementation StargazerModel

@synthesize stargazers;
@synthesize nextPage;
@synthesize lastPage;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stargazers = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

@end
