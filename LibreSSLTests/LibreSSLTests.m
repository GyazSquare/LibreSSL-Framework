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

+ (void)setUp {
    SSL_load_error_strings();
    SSL_library_init();
    tls_init();
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
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

- (void)testTLS_method {
    XCTAssertTrue(TLS_method() != NULL);
    XCTAssertTrue(TLS_server_method() != NULL);
    XCTAssertTrue(TLS_client_method() != NULL);
}

- (void)testTls_client {
    self.continueAfterFailure = NO;
    struct tls *ctx = tls_client();
    XCTAssertTrue(ctx != NULL);
    XCTAssertTrue(tls_connect(ctx, "www.example.com", "443") == 0,
                  @"tls_connect: %@", @(tls_error(ctx)));
    do {
        ssize_t ret = tls_close(ctx);
        if (ret == TLS_WANT_POLLIN || ret == TLS_WANT_POLLOUT) {
            continue;
        }
        XCTAssertTrue(ret == 0, @"tls_close: %@", @(tls_error(ctx)));
        break;
    } while (1);
    tls_free(ctx);
}

@end
