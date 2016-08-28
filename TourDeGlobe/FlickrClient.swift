//
//  FlickrClient.swift
//  TourDeGlobe
//
//  Created by Pritam Hinger on 28/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    // MARK: - Properties
    let session = NSURLSession.sharedSession()
    
    // MARK: - Shared Instance
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var instance = FlickrClient()
        }
        
        return Singleton.instance
    }
    
    // MARK: - Get Methods
    func taskForGetMethod(methodName: String, parameter: [String:String], completionHandler: (result: AnyObject!, error:NSError?) -> Void) -> NSURLSessionDataTask {
        let queryParameters = FlickrClient.addCommonParameters(methodName, parameters: parameter)
        let request = NSMutableURLRequest(URL: FlickrClient.flickrURLFromParameters(queryParameters))
        print(request.URL?.absoluteString)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            func sendError(errorString: String) {
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandler(result: nil, error: NSError(domain: (error?.domain)!, code: (error?.code)!, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandler)
        }
        
        task.resume()
        return task
    }
    
    // MARK: - Private Methods
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let output = NSString(data: data, encoding: NSUTF8StringEncoding)
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(output)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // MARK: - Flickr Client Intializer
    override init() {
        super.init()
    }
}