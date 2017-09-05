import Vapor

extension Droplet {
    func setupRoutes() throws {
        
        post("sign-up") { req in
            
           guard
            let firstName = req.data["First_Name"]?.string,
            let lastName = req.data["Last_Name"]?.string
            else {
            
                throw Abort.badRequest
                
            }
            
            let newUser = User(firstName: firstName, lastName: lastName)
            
            try newUser.save()
            
            return try JSON(
                node: [
                    "data": [
                        "id": newUser.id?.string
                    ]
                ]
            )
            
        
        }
        
        //只要協定不一樣的話，endpoint一樣沒關係
        post("comments") { req in
            
            guard
                let text = req.data["text"]?.string
                else {
            
                    throw Abort.badRequest
            }
            
            
            // Todo: save text into database (MySQL)
            
            var json = JSON()
            
            try json.set(
                "data",
                [
                    "id": "QQ",
                    "text": text
                ]
            )
            
            return json
        
        }
        
        get("comments", String.parameter) { req in
            
            let commentID = try req.parameters.next(String.self)
            
//            let page = try req.parameters.next()
        
            return "your comment ID is \(commentID)"
        }
        
        get("comments") { req in
            
            //寫回傳給client的東西
            var json = JSON()
            
            try json.set(
                "data",
                [
                    [
                        "id": "111",
                        "text": "棒棒"
                    ],
                    [
                        "id": "222",
                        "text": "嗯嗯"
                    ]
                    
                ]
                
            )
            
            return json
            
        }
        
        
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }
}
