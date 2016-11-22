//
//  HTTPOperation.swift
//  Networking
//
//  Created by Chris on 10/8/14.
//  Copyright (c) 2014 Chris. All rights reserved.
//

import Foundation
public typealias NetworkResponse = (status:Int, data:Data? )
open class HTTPOperation : Operation
{
    open let request:URLRequest
    public var userInfo:Any?
    open weak var session:URLSession!
    open private(set) var networkResponse:NetworkResponse?
    
    internal var task:URLSessionDataTask?;
    
    private var _ready    :Bool! = false
    private var _executing:Bool! = false
    private var _finished :Bool! = false
    open private(set) var response:HTTPURLResponse?
    
    override open var isReady : Bool
    {
        return _ready;
    }
    
    override open var isExecuting : Bool
    {
        return _executing
    }
    
    override open var isFinished : Bool
    {
        return _finished
    }
    
    open var debugString:String?
    {
        get
        {
            guard let d = self.networkResponse?.data else { return nil  }
            return String(data: d, encoding:String.Encoding.utf8)
        }
    }
    
    public init( request : URLRequest, session : URLSession )
    {
        self.request = request
        self.session = session
        super.init()
    }
    
    open func run()
    {
        self.notifyStart()
    }

    internal func notifyStart()
    {
        self.willChangeValue(forKey: "isReady")
        _ready = true
        self.didChangeValue(forKey: "isReady")
    }
    
    override open func start()
    {
        self.willChangeValue(forKey: "isExecuting")
        _executing = true
        self.didChangeValue(forKey: "isExecuting")
     
        self.task = self.session.dataTask(with: self.request, completionHandler: { (data, response, error) in
            self.response = response as? HTTPURLResponse
            if let _ = error
            {
                self.handleTaskFailed()
            }
            else
            {
                self.handleTaskComplete( data )
            }
        })
        self.task?.resume()
    }
    
    open func handleTaskComplete( _ data:Data?  )
    {
        guard let resp = self.response else
        {
            self.willChangeValue(forKey: "isFinished")
            _finished = true
            self.didChangeValue(forKey: "isFinished")
            return
        }
        
        self.networkResponse = (status:resp.statusCode, data:data)
        self.willChangeValue(forKey: "isFinished")
        _finished = true
        self.didChangeValue(forKey: "isFinished")
    }
    
    open func handleTaskFailed( )
    {
        guard let resp = self.response else
        {
            self.willChangeValue(forKey: "isFinished")
            _finished = true
            self.didChangeValue(forKey: "isFinished")
            return
        }
        
        self.networkResponse = (status:resp.statusCode, data:nil)
        self.willChangeValue(forKey: "isFinished")
        _finished = true
        self.didChangeValue(forKey: "isFinished")
    }
    
    open override func cancel()
    {
        self.task?.cancel()
    }
    
    deinit
    {
        self.task?.cancel()
    }
    
}
