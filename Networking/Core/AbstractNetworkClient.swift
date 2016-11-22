//
//  AbstractNetworkClient.swift
//  iOS
//
//  Created by Chris Shanley on 5/4/16.
//  Copyright © 2016 Chirs Shanley. All rights reserved.
//

import Foundation

public enum AuthType:String
{
    case basic = "Basic "
    case bearer = "Bearer "
}

public typealias NetworkAuth = ( type:AuthType, token:String )
public typealias NetworkCompleteClosure<T:Any>  = ( _ obj:T? , _ status:Int, _ userInfo:Any? ) -> Void

open class AbstractNetworkClient
{
    public let factory:NetworkRequestFactory
    public internal(set) weak var session:URLSession!
    private let queue:OperationQueue
    
    public init( host:String, session:URLSession, auth:NetworkAuth? )
    {
        guard let url = URL(string: host) else { abort() }
        self.session  = session
        self.factory  = NetworkRequestFactory(baseURL: url, auth:auth)
        self.queue    = OperationQueue()
    }
    
    open func makeRequest<T:Any>( _ method:NetworkHTTPMethod, params:RequestParameters? = nil, headers:RequestHeaders? = nil, type:T.Type, endpoint:String, userInfo:Any? = nil, closure:@escaping NetworkCompleteClosure<T> )
    {
        let req       = self.factory.httpRequest(endpoint, method:method, headers:headers, data:params)
        let operation = HTTPOperation(request: req, session: self.session)
        operation.userInfo = userInfo
        operation.completionBlock = {[weak op = operation] in
            let userInfo = op?.userInfo
            guard let res = op?.networkResponse else
            {
                DispatchQueue.main.async(execute: {
                    closure(nil, 0, userInfo)
                })
                return
            }
            
            if let data = res.data , 200...299 ~= res.status
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! T
                    DispatchQueue.main.async(execute: {
                        closure(json, res.status, userInfo)
                    })
                }
                catch
                {
                    DispatchQueue.main.async(execute: {
                        closure( nil , res.status, userInfo)
                    })
                }
            }
            else
            {
                DispatchQueue.main.async(execute: {
                    closure(nil, res.status, userInfo)
                })
            }
        }
        let queue = OperationQueue()
        queue.addOperation(operation)
        operation.start()
    }
    
    deinit
    {
        print("\(self) --- deinit")
    }

}
