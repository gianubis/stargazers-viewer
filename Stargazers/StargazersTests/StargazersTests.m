//
//  StargazersTests.m
//  StargazersTests
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "RestService.h"

@interface StargazersTests : XCTestCase

@property ViewController *vcToTest;
@property RestService *rs;

@end

@implementation StargazersTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _vcToTest = [[ViewController alloc] init];
    _rs = [[RestService alloc] init];
}

- (void)testConnectionTask {
    [_vcToTest testConnection];
    bool result = _vcToTest.testIsConnected;
    XCTAssertTrue(result);
}

- (void)testFetchDataCompletedTask {
    
    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Method Works Correctly!"];

    // owner and repository values exists on github and are used for test
    NSString *testOwner = @"chemerisuk";
    NSString *testRepository = @"better-form-validation";

    [_rs fetchdataWithPage:1 withOwner:testOwner withRepository:testRepository andCompletionHandler:^(NSDictionary * _Nullable dictionary, NSString * _Nullable errorMessage) {
        if(errorMessage) {
            NSLog(@"error is: %@", errorMessage);
        } else {
            [expectation fulfill];
            NSLog(@"success");
        }
    }];

    //Wait 1 second for fulfill method called, otherwise fail:
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _vcToTest = nil;
    _rs = nil;
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
