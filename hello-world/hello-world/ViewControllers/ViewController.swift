//
//  ViewController.swift
//  hello-world
//
//  Created by hello on 2017/12/26.
//  Copyright © 2017年 hello. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        NetworkTools.requestData(urlString: "http://httpbin.org/get", type: .get, success: { (success) in
            
            let result = JSON(success)
            print(result["headers","Host"])
            
        }) { (error) in
            print(error)
        }
        
//        Bundle.main.path(forResource: <#T##String?#>, ofType: <#T##String?#>)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

