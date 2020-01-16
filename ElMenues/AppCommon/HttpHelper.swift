//
//  HttpController.swift
//  AshakAlena
//
//  Created by Mohammad Farhan on 22/12/177/25/17.
//  Copyright © 2017 Mohammad Farhan. All rights reserved.
//

import Foundation
import Alamofire
protocol HttpHelperDelegate {
    func receivedResponse(dictResponse:Any,Tag:Int)
    func receivedErrorWithStatusCode(statusCode:Int)
    func retryResponse(numberOfrequest:Int)
}
/// HttpHelper class for http request using alamofire libs
class HttpHelper {
    /// **HttpHelparDelegate**  interface on complete request call
    var delegate: HttpHelperDelegate?
    
    var header:HTTPHeaders?
    var numberOfrequest = 0
    var maxNumberOfrequest = 3
    
    
    public  func GetWithoutHeader(url:String,parameters:Parameters=[:],Tag:Int ){
        
        request(url: url, method: .get, parameters: parameters, tag: Tag,header: nil)
    }
    
    public func Postwithoutheader(url:String,parameters:Parameters=[:],Tag:Int ){
        request(url: url, method: .post, parameters: parameters, tag: Tag,header: nil)
    }


    private func request(url:String,method:HTTPMethod,parameters:Parameters=[:],tag:Int,header:HTTPHeaders?){

        Alamofire.request(url, method: method,parameters: parameters,headers:header)
            .responseJSON { (response) in
                print(response)
                if response.response == nil {
                    self.delegate?.receivedErrorWithStatusCode(statusCode: statusCode.NOT_FOUND)
                    return
                }
                if response.response!.statusCode == statusCode.OK  || response.response!.statusCode == statusCode.CREATED
                    || response.response!.statusCode == statusCode.NO_CONTENT || response.response!.statusCode == statusCode.ACCEPTED{
                    if let JSON = response.result.value {

                        self.delegate?.receivedResponse(dictResponse: JSON,Tag: tag)
                    }
                }else if response.response!.statusCode == statusCode.BAD_GATEWAY || response.response!.statusCode == statusCode.SERVICE_UNAVAILABLE{
                    let when = DispatchTime.now() + Double(0.1 * Double(self.numberOfrequest))
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.delegate?.retryResponse(numberOfrequest: self.numberOfrequest)
                        self.numberOfrequest  = self.numberOfrequest +  1
                    }
                }else{
                    self.delegate?.receivedErrorWithStatusCode(statusCode: response.response!.statusCode)
                }
        }
    }
}

