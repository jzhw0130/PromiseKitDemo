# PromiseKitDemo
PromiseKit  Demo

Demo for doing your async task by PromiseKit


Just as  

```sh

self.loginWithUserName("John", password: "111111")
.then(execute: { (token) -> Promise<[String: Any]> in
                print("token:\(token)")
                return self.downloadUserInfo(token: token)
}).then(execute: { (userInfo) -> (Promise<[String: Any]>) in
                print("userInfo:\(userInfo)")
                return self.updateUserInfo(["Weight": 60.0, "Height": 180], token: userInfo["Token"] as! String)
}).then(execute: { (uploadResult) -> Promise<[String: Any]> in
                print("uploadResult:\(uploadResult)")
                return self.downloadUserInfo(token: uploadResult["Token"] as! String)
 }).then(execute: { (userInfo) -> Void in
                print("userInfo:\(userInfo)")
}).catch(execute: { (error) in
                print("error:\(error)")
}).always(execute: {
                print("User login completed")
})  

```
