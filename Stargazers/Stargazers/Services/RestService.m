//
//  RestConsumer.m
//  Stargazers
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import "RestService.h"
#import "StargazerModel.h"

#define BASE_URL @"https://api.github.com/repos"

@interface RestService()

- (void) getLastPageFromLinkHeader:(NSString*)linkHeader;

@end

@implementation RestService

static RestService *_sharedInstance = nil;

+ (RestService *)sharedInstance {
    @synchronized([RestService class]) {
        if (!_sharedInstance)
          _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

- (void)fetchdataWithPage:(NSInteger)page withOwner:(nonnull NSString *)owner withRepository:(nonnull NSString *)repository andCompletionHandler:(void (^)(NSDictionary * _Nullable dictionary, NSString * _Nullable errorMessage))comp {
    
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];

    // Setup the request with URL
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/stargazers?page=%ld", BASE_URL, owner, repository, (long)page];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

    [urlRequest setHTTPMethod:@"GET"];

    // Create dataTask
    __block RestService *blocksafeSelf = self;
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
        if (httpResp.statusCode == 200) {
            if (data) {
                // extract lastPage from header Link
                [blocksafeSelf getLastPageFromLinkHeader:[httpResp valueForHTTPHeaderField:@"Link"]];

                // compose userInfo for notification
                NSString *strLastPage = [NSString stringWithFormat:@"%ld",self.lastPage];
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:results, @"Data", strLastPage, @"LastPage", nil];
                
                comp(userInfo, nil);
                
            } else {
                NSLog(@"No data retrieved with error: %@",error.localizedDescription);

                comp(nil, error.localizedDescription);
            }
        } else {
            NSLog(@"Error with statusCode %ld",httpResp.statusCode);

            NSString *statusCode = [NSString stringWithFormat:@"%ld", httpResp.statusCode];
            comp(nil, statusCode);
        }
    }];

    // Fire the request
    [dataTask resume];
}

- (void) getLastPageFromLinkHeader:(NSString*)linkHeader {
    
    if (self.lastPage == 0) {
        NSArray *links = [linkHeader componentsSeparatedByString:@","];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        for (NSString *link in links) {
            NSArray *components = [link componentsSeparatedByString:@";"];
            NSString *cleanPath = [components[0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
            NSString *cleanKey = [components[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [dict setObject:cleanPath forKey:cleanKey];
        }
        
        NSString *lastPagePath = [dict objectForKey:@"rel=\"last\""];
        if (lastPagePath) {
            NSArray *components = [lastPagePath componentsSeparatedByString:@"="];
            NSString *strLastPage = [components lastObject];
            self.lastPage = [strLastPage integerValue];
        }
    }
}

@end
