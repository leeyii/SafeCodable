//
//  ViewController.swift
//  TestCodable
//
//  Created by leeyii on 2019/12/25.
//  Copyright © 2019 leeyii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            
        let jsonData = """
        {
            "name" : "小明",
            "age" : null,
            "sex" : "true",
            "height" : "180.00"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        let model = try! decoder.decode(Model.self, from: jsonData)
        
    }


}

struct Model: Codable {
    
    var name: SafeStringCodable?
    
    var sex: SafeBoolCodable?
    
    var age: SafeIntCodable?
    
    var height: SafeDoubleCodable?
    
    
}
