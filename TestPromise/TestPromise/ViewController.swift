//
//  ViewController.swift
//  TestPromise
//
//  Created by jing on 07/07/2017.
//  Copyright © 2017 jing. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {


    enum HttpError: Error {
        case passwordError
        case networkError
    }
    
    //Login
    func loginWithUserName(_ name: String, password: String) -> Promise<String> {
        return Promise(resolvers: { (fulfill, reject) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: { 
                let result = arc4random()%2 == 1
                if result {
                    fulfill("Token:xxxx")
                } else {
                    reject(HttpError.passwordError)
                }
            })
            print(#function)
        })
    }
    
    //update user information
    func updateUserInfo(_ userInfo: [String: Any], token: String) -> Promise<[String: Any]> {
        return Promise(resolvers: { (fulfill, reject) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                let result = arc4random()%2 == 1
                if result {
                    fulfill(["Result": "OK", "Token": "Token:xxxx"])
                } else {
                    reject(HttpError.networkError)
                }
            })
            print(#function)
        })
    }
    
    //download user info
    func downloadUserInfo(token: String) -> Promise<[String: Any]> {
        return Promise(resolvers: { (fulfill, reject) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                let result = arc4random()%2 == 1
                if result {
                    fulfill(["Gender": "M", "Birthday": "1988-12-24", "Token": "Token:xxxx"])
                } else {
                    reject(HttpError.networkError)
                }
            })
            print(#function)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func userLogin(_ sender: Any) {
        self.loginWithUserName("John", password: "111111")
            .then(execute: { (token) -> Promise<[String: Any]> in
                print("token:\(token)")
                return self.downloadUserInfo(token: token)
            })
            .then(execute: { (userInfo) -> (Promise<[String: Any]>) in
                print("userInfo:\(userInfo)")
                return self.updateUserInfo(["Weight": 60.0, "Height": 180], token: userInfo["Token"] as! String)
            })
            .then(execute: { (uploadResult) -> Promise<[String: Any]> in
                print("uploadResult:\(uploadResult)")
                return self.downloadUserInfo(token: uploadResult["Token"] as! String)
            })
            .then(execute: { (userInfo) -> Void in
                print("userInfo:\(userInfo)")
            })
            .catch(execute: { (error) in
                print("error:\(error)")
            })
            .always(execute: {
                print("User login completed")
            })
    }
    
    func test1() -> Void {
        let promise = dispatch_promise(DispatchQueue.global(), { () -> (Data, String)  in
            return ("Data..XX".data(using: .utf8)!, "Tag")
        }).then(execute: { (data, tag) -> String in
            print("data:\(String(describing: String.init(data: data, encoding: .utf8)))")
            print("Tag:\(tag)")
            return "\(String(describing: String.init(data: data, encoding: .utf8)))"
        }).then(execute: { (str) -> Int in
            print("String:\(str)")
            
            return str.characters.count
        }).then(execute: { (count) -> Void in
            print("Count:\(count)")
        }).then(on: .main, execute: { () -> Void in
            print("End")
        }).catch(execute: { (error) in
            print("Error:\(error)")
        }).always {
            print("Always")
        }
        
        print(promise)
    }
    
    func test2() -> Void {
        let promise = firstly(execute: { () -> Promise<(String, Int)> in
            return Promise(value: ("123", 6))
        }).then(execute: { (str, nub) -> Promise<Int> in
            print(str)
            return Promise(value: nub)
        }).then(execute: { (nub) -> Void in
            print(nub)
        })
         print(promise)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

