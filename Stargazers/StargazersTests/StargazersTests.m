//
//  StargazersTests.m
//  StargazersTests
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface StargazersTests : XCTestCase

@property ViewController *vcToTest;

@end

@implementation StargazersTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _vcToTest = [[ViewController alloc] init];
}

- (void)testConnectionTask {
    [_vcToTest testConnection];
    bool result = _vcToTest.testIsConnected;
    XCTAssertTrue(result);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _vcToTest = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
