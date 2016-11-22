//
//  HTTPBackgroundOperation.swift
//  iOS
//
//  Created by Chris Shanley on 6/14/16.
//  Copyright © 2016 Chirs Shanley. All rights reserved.
//

import Foundation
public typealias BackgroundComplete = ()->Void
open class HTTPBackgroundAction : NSObject , URLSessionDataDelegate
{
    var session:Foundation.URLSession!
    let request:URLRequest
    var complete:BackgroundComplete!
    open internal(set) var data:Data?
   
    public init( request:URLRequest)
    {
        self.request = request
        super.init()
        let config = URLSessionConfiguration.background(withIdentifier: "com.simplifeye.background.session")
        self.session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main )
    }
    
    open func start( _ complete:@escaping BackgroundComplete )
    {
        self.complete = complete
        let task = self.session.dataTask(with: self.request)
        task.resume()
    }
    
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        self.data = data
        self.complete()
    }
    
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        print("\(self) ---- \(#function), response : \(response)")
        completionHandler(Foundation.URLSession.ResponseDisposition.allow)
    }

    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        print("\(self) --- background error \(error) ")
        self.complete()
    }
    
    open func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession)
    {
        print("\(self) --- background done ")
    }
}
