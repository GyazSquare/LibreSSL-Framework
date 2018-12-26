//
//  LibreSSLTests.m
//  LibreSSLTests
//

@import Foundation;
@import XCTest;

@import LibreSSL;

@interface LibreSSLTests : XCTestCase
@end

@implementation LibreSSLTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    SSL_load_error_strings();
    SSL_library_init();
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testOpenSSL_version {
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.gyazsquare.LibreSSL"];
    NSString *shortVersionString = bundle.infoDictionary[@"CFBundleShortVersionString"];
    NSString *pattern = @"\\A[\\d.]*\\d[^(]*\\(([^)]*)\\)\\z";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (!regex) {
        NSLog(@"%@: %@", @(__PRETTY_FUNCTION__), error);
    }
    NSTextCheckingResult *match = [regex firstMatchInString:shortVersionString options:0 range:NSMakeRange(0, shortVersionString.length)];
    NSRange range = [match rangeAtIndex:1];
    NSString *expected = [shortVersionString substringWithRange:range];
    NSString *actual = @(OpenSSL_version(OPENSSL_VERSION));
    XCTAssertEqualObjects(expected, actual);
}

- (void)testTLSv1_2_method {
    XCTAssertTrue(TLSv1_2_method() != NULL);
    XCTAssertTrue(TLSv1_2_server_method() != NULL);
    XCTAssertTrue(TLSv1_2_client_method() != NULL);
}

@end
