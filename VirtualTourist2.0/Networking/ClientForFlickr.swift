//
//  ClientForFlickr.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import Foundation

class ClientForFlickr : NSObject{
    
    // MARK: - Properties
    
    var session = URLSession.shared
    
    var photosPath : [FlickrImage] = [FlickrImage]()
    
    override init() {
        super.init()
    }
    

    
    func getPhotosPath (lat: Double, lon: Double, _ completionHandlerForGetPhotosPath: @escaping (_ result : [FlickrImage]?, _ error : NSError?)->Void ){
        

        
        let methodParameters: [String : Any] = [
            ClientForFlickr.ParameterKeys.Method: ClientForFlickr.ParameterValues.SearchMethod,
            ClientForFlickr.ParameterKeys.ApiKey: ClientForFlickr.ParameterValues.ApiKey,
            ClientForFlickr.ParameterKeys.Format: ClientForFlickr.ParameterValues.ResponseFormat,
            ClientForFlickr.ParameterKeys.Lat: lat,
            ClientForFlickr.ParameterKeys.Lon: lon,
            ClientForFlickr.ParameterKeys.NoJSONCallback:ClientForFlickr.ParameterValues.DisableJSONCallback,
            ClientForFlickr.ParameterKeys.SafeSearch: ClientForFlickr.ParameterValues.UseSafeSearch,
            ClientForFlickr.ParameterKeys.Extras: ClientForFlickr.ParameterValues.MediumURL,
            ClientForFlickr.ParameterKeys.Radius: ClientForFlickr.ParameterValues.SearchRangeKm,
            ClientForFlickr.ParameterKeys.PerPage: ClientForFlickr.ParameterValues.PerPageAmount,
            ClientForFlickr.ParameterKeys.Page: Int(arc4random_uniform(6))

        ]
        
        
        let _ = taskForGetMethod(methodParameters: methodParameters as [String: AnyObject]) { results, error in
            if let error = error {
                completionHandlerForGetPhotosPath(nil, error)
            } else {
                if let photos = results?[ClientForFlickr.JSONResponseKeys.Photos] as? [String: AnyObject],
                   let photo = photos[ClientForFlickr.JSONResponseKeys.Photo] as? [[String:AnyObject]]{
                    let flickerImage = FlickrImage.photosPathFromResults(photo)
                    completionHandlerForGetPhotosPath(flickerImage, nil)
                } else {
                    completionHandlerForGetPhotosPath(nil, NSError(domain: "getPhotosPath", code: 0, userInfo: [NSLocalizedDescriptionKey:"Could not parse getPhotosPath"]))
                }
            }
        }
    }
    
    
    
    // MARK: - TaskForGet Functions
    
    
    func taskForGetMethod(methodParameters: [String: AnyObject], completionHandlerForGet: @escaping (_ result : AnyObject? , _ error : NSError?)->Void) -> URLSessionDataTask{
        
        let receivedParameter = methodParameters
        
        let request = NSMutableURLRequest(url: URLsFlickerFromParameters(receivedParameter))
        
        let task = session.dataTask(with: request as URLRequest) { data , response , error in
            
            func sendError(_ error: String){
                print("error received from taskForGetMethod \(error)")
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGet(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            guard error == nil else {
                sendError("An error occurred while performing the request in taskForGetMethod \(error!)")
                return
            }
            
            guard let codeStatus = (response as? HTTPURLResponse)?.statusCode, codeStatus >= 200 && codeStatus <= 299 else {
                sendError("The request returned an error other than 2XX!")
                return
            }
            guard let data = data else {
                sendError("The request did not return any data")
                return
            }
            self.dataConversionWithCompletionHandler(data, innerCompletionHandlerForConvertingData: completionHandlerForGet)

        }
        
        
        task.resume()
        return task
    }
    
    
    func taskForGetImage(photoPath : String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error : NSError?)->Void) -> URLSessionDataTask{
        
        let url = URL(string: photoPath)!
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data , response , error in
            func sendError(_ error : String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForImage(nil, NSError(domain: "taskForGetImage", code: 1, userInfo: userInfo))
            }
            guard error == nil else {
                sendError("An error occurred while performing the request \(error!)")
                return
            }
            
            guard let codeStatus = (response as? HTTPURLResponse)?.statusCode, codeStatus >= 200 && codeStatus <= 299 else {
                sendError("The request returned an error other than 2XX!")
                return
            }
            guard let data = data else {
                sendError("There was no data returned by the request")
                return
            }
            completionHandlerForImage(data, nil)

        }
        task.resume()
        
        return task
    }
    
  
    
    
    
    // MARK: - Private Helper Functions
    
        
    private func URLsFlickerFromParameters(_ parameters: [String:AnyObject])-> URL{
        var components = URLComponents()
        components.scheme = ClientForFlickr.Constants.ApiScheme
        components.host = ClientForFlickr.Constants.ApiHost
        components.path = ClientForFlickr.Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    
    
    private func dataConversionWithCompletionHandler(_ data: Data, innerCompletionHandlerForConvertingData: (_ result: AnyObject? , _ error : NSError?)->Void ){
        var resultsParsed : AnyObject! = nil
        
        do {
            resultsParsed = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "The data could not be parsed as JSON \(data)"]
            innerCompletionHandlerForConvertingData(nil, NSError(domain: "dataConversionWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        innerCompletionHandlerForConvertingData(resultsParsed, nil)

    }

    
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> ClientForFlickr {
        struct Singleton{
            static var sharedInstance = ClientForFlickr()
        }
        return Singleton.sharedInstance
    }
    
    
    
}
