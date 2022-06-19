//
//  ViewController.h
//  Stargazers
//
//  Created by Alessandro Giannubilo on 15/06/22.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// used by unit test
@property (nonatomic, assign) BOOL testIsConnected;
- (void)testConnection;

@end
