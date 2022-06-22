//
//  StargazersUITests.m
//  StargazersUITests
//
//  Created by Alessandro Giannubilo on 19/06/22.
//

#import <XCTest/XCTest.h>

@interface StargazersUITests : XCTestCase

@end

@implementation StargazersUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testExistenceOfInteractors {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    XCTAssert([app.textFields[@"repository owner"] exists]);
    XCTAssert([app.textFields[@"repository name"] exists]);
    XCTAssert([app.staticTexts[@"Show Stargazers"] exists]);
}

- (void)testConnectionWarning {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    [app.staticTexts[@"Show Stargazers"] tap];
    [app.alerts[@"Warning"].scrollViews.otherElements.buttons[@"OK"] tap];
}

- (void)testEmptyFieldWarning {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    [app.staticTexts[@"Show Stargazers"] tap];
    [app.alerts[@"Warning"].scrollViews.otherElements.buttons[@"OK"] tap];
}

- (void)testRepositoryNotFoundWarning {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    [app.textFields[@"repository owner"] tap];
    [app.keys[@"t"] tap];
    [app.keys[@"e"] tap];
    [app.keys[@"s"] tap];
    [app.keys[@"t"] tap];

    [app.textFields[@"repository name"] tap];
    [app.keys[@"t"] tap];
    [app.keys[@"e"] tap];
    [app.keys[@"s"] tap];
    [app.keys[@"t"] tap];

    [app.buttons[@"Return"] tap];
    [app.staticTexts[@"Show Stargazers"] tap];
    [app.alerts[@"Error"].scrollViews.otherElements.buttons[@"OK"] tap];
}

- (void)testNoStargazersWarning {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    [app.textFields[@"repository owner"] tap];
    [app.keys[@"s"] tap];
    [app.keys[@"p"] tap];
    [app.keys[@"i"] tap];
    [app.keys[@"b"] tap];

    [app.textFields[@"repository name"] tap];
    [app.keys[@"a"] tap];
    [app.keys[@"r"] tap];
    [app.keys[@"d"] tap];
    [app.keys[@"e"] tap];
    [app.keys[@"n"] tap];
    [app.keys[@"t"] tap];

    [app.buttons[@"Return"] tap];
    [app.staticTexts[@"Show Stargazers"] tap];
    [app.alerts[@"Error"].scrollViews.otherElements.buttons[@"OK"] tap];
}

- (void)testCompleteBehavior {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    [app.textFields[@"repository owner"] tap];
    [app.keys[@"d"] tap];
    [app.keys[@"o"] tap];
    [app.keys[@"m"] tap];
    [app.keys[@"o"] tap];
    [app.keys[@"n"] tap];

    [app.textFields[@"repository name"] tap];
    [app.keys[@"d"] tap];
    [app.keys[@"o"] tap];
    [app.keys[@"t"] tap];
    [app.keys[@"f"] tap];
    [app.keys[@"i"] tap];
    [app.keys[@"l"] tap];
    [app.keys[@"e"] tap];
    [app.keys[@"s"] tap];

    [app.buttons[@"Return"] tap];
    [app.staticTexts[@"Show Stargazers"] tap];
    [app.staticTexts[@"domon"] swipeDown];
}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)) {
        // This measures how long it takes to launch your application.
        [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

@end
