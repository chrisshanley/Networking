//
//  NetworkRequestFactory.swift
//  Networking
//
//  Created by Chris on 9/26/14.
//  Copyright (c) 2014 Chris. All rights reserved.
//

import Foundation


public typealias RequestParameters = (encoding : NetworkParamEncoding,  params : Dictionary<String, Any>)
public typealias RequestHeaders = [String:String]

open class NetworkRequestFactory
{
    
    private var authorization:NetworkAuth?
    private let baseURL:URL;
    public var userInfo:Any?
    
    public init( baseURL : URL, auth : NetworkAuth? )
    {
        self.baseURL   = baseURL
        self.authorization = auth
    }
    
    open func invalidateAuthToken(_ token:String)
    {
        self.authorization?.token = token
    }
    
    open func httpRequest( _ endpoint : String, method : NetworkHTTPMethod, headers:RequestHeaders?, data : RequestParameters? )-> URLRequest
    {
        
        let urlstring : String            = self.baseURL.absoluteString + endpoint;
        let request : NSMutableURLRequest = NSMutableURLRequest( url: URL(string: urlstring)! )
        request.httpMethod = NetworkHTTPMethod.toString(method)
        
        if let h = headers
        {
            for (key, val) in h
            {
                request.setValue(val, forHTTPHeaderField: key)
            }
        }
        
        
        if let requestData = data
        {
            self.encodeParameters(request, params: requestData.params, encoding: requestData.encoding)
        }
        
        if let auth = self.authorization
        {
            request.addValue(auth.type.rawValue + auth.token, forHTTPHeaderField: "Authorization")
        }
        return request as URLRequest
    }
    
    open func toQueryString( _ params : Dictionary<String, String> )->String
    {
        var pair  : String!
        let queryChars:CharacterSet = CharacterSet.urlFragmentAllowed
        var array : [String] = [];
        for(key, value) in params
        {
            pair = key + "=" + value.addingPercentEncoding(withAllowedCharacters: queryChars)!.replacingOccurrences(of: "+", with: "%2B")
            array.append(pair);
        }
        return array.joined(separator: "&")
    }
    
    fileprivate func encodeParameters( _ request:NSMutableURLRequest, params:Dictionary<String, Any>, encoding:NetworkParamEncoding)
    {
        switch encoding
        {
            case .formEncoding :
                
                let queryString  = self.toQueryString( params as! Dictionary<String , String> );
                if request.httpMethod == NetworkHTTPMethod.toString( NetworkHTTPMethod.get )
                {
                    let url:String = request.url!.absoluteString + "?" + queryString;
                    request.url = URL(string: url)
                }
                else
                {
                    request.httpBody = queryString.data(using: String.Encoding.utf8, allowLossyConversion: false)
                }
            case .jsonEncoding :

                request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted  )
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                break
        }
    }
}
