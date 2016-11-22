//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by christopher shanley on 11/22/16.
//  Copyright © 2016 christopher shanley. All rights reserved.
//

import XCTest
@testable import Networking

class NetworkingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreatesARequest()
    {
        let factory = NetworkRequestFactory(baseURL: URL(string: "http://test.com")!, auth: nil)
        let requst  = factory.httpRequest("/hello", method: NetworkHTTPMethod.get, headers: nil, data: nil)
        XCTAssertEqual(requst.url?.absoluteString, "http://test.com/hello", "did not build propper url")
    }
    
    func testCreatesAPostRequest()
    {
        let factory = NetworkRequestFactory(baseURL: URL(string: "http://test.com")!, auth: nil)
        let requst  = factory.httpRequest("/hello", method: NetworkHTTPMethod.post, headers: nil, data: nil)
        XCTAssertEqual((requst as NSURLRequest).httpMethod?.lowercased(), "post", "did not set http method")
    }
    
    func testCreatesAGetQueryRequest()
    {
        let body    = ["hello":"world"]
        let data:RequestParameters    = (encoding:NetworkParamEncoding.formEncoding, params:body as Dictionary<String, AnyObject>)
        let factory = NetworkRequestFactory(baseURL: URL(string: "http://test.com")!, auth: nil)
        let requst  = factory.httpRequest("/hello", method: NetworkHTTPMethod.get, headers: nil, data: data)
        XCTAssertEqual(requst.url?.absoluteString, "http://test.com/hello?hello=world", "did not build propper url")
    }
    
    
    func testCreatesAPostBodyRequest()
    {
        let body    = ["hello":"world"]
        let data:RequestParameters    = (encoding:NetworkParamEncoding.formEncoding, params:body as Dictionary<String, AnyObject>)
        let factory = NetworkRequestFactory(baseURL: URL(string: "http://test.com")!, auth: nil)
        let requst  = factory.httpRequest("/hello", method: NetworkHTTPMethod.post, headers: nil, data: data)
        let decoded    = NSString(data: requst.httpBody!, encoding: String.Encoding.utf8.rawValue)
        XCTAssertEqual("hello=world", decoded, "did not craete propper body")
    }

    
}
