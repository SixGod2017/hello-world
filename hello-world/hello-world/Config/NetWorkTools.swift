//
//  NetWorkTools.swift
//  hello-world
//
//  Created by hello on 2017/12/26.
//  Copyright © 2017年 hello. All rights reserved.
//

import Foundation
import Alamofire

enum MethodType {
    case get
    case post
}

struct NetworkTools {
    
    //常用请求
    static func requestData(urlString: String, type: MethodType, params: [String : Any]? = nil, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        let headers: HTTPHeaders = [
            "Accpet": "application/json"
//            "Accept": "text/javascript",
//            "Accept": "text/html",
//            "Accept": "text/plain"
        ]
        Alamofire.request(urlString, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    //文件(图片)上传
    static func uploadFile(urlString: String, params:Dictionary<String, Any>, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (_, value) in params {
                if value is Data || value is NSData {
                    let fileName = String(describing: Date()).appending(".png")
                    multipartFormData.append(value as! Data, withName: fileName, mimeType: "image/png")
                }
            }
        }, to: urlString) { (encodingResult) in
            switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress { progress in
                        print("当前进度：\(progress.fractionCompleted)")
                    }
                    .responseJSON(completionHandler: { (response) in
                        success(response)
                    })
                case .failure(let error):
                    failure(error)
            }
        }
    }
    
    //文件下载
    static func download(urlString: String, success: @escaping (Any) -> (), failure: @escaping (Error) -> ()) {
//        let destination: DownloadRequest.DownloadFileDestination = {_, response in
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
//            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
        //使用这种方式如果下载路径下有同名文件，不会覆盖原来的文件。
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
        Alamofire.download(urlString, to: destination)
            .downloadProgress { (progress) in
                print("当前进度：\(progress.fractionCompleted)")
            }
            .responseData { (response) in
                switch (response.result) {
                    case .success(let value):
                        success(value)
                    case .failure(let error):
                        failure(error)
                }
        }
    }
}
