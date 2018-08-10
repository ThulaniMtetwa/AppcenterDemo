//
//  AppCenterDemoXCTests.m
//  AppCenterDemoXCTests
//
//  Created by NPW iOS on 2018/08/10.
//  Copyright © 2018 NPW iOS. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SearchTableViewController.h"

@interface AppCenterDemoXCTests : XCTestCase

@end

@implementation AppCenterDemoXCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    XCTestExpectation *exp = [self expectationWithDescription:@"Get artist songs."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(29 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [exp fulfill];
    });
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // handle failure
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTrue {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssert(true,@"True should be true");
}


- (void)testValidCallToiTunesGetsHTTPStatusCode200{
    NSString *query = @"https://itunes.apple.com/search?country=za&term=Nasty+c&limit=30";
    XCTestExpectation *exp = [self expectationWithDescription:@"Get artist songs."];
    
    NSString * escapedUrlString = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
    
    NSURLSession * urlSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * task = [urlSession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                    if (error) {
                                                        XCTFail(@"Error: %@",error.localizedFailureReason);
                                                        return ;
                                                    } else if(httpResponse.statusCode == 200) {
                                                        [exp fulfill];
                                                    }else{
                                                        XCTFail(@"Status code: %ld",httpResponse.statusCode);
                                                    }
                                                }];
    [task resume];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



@end
