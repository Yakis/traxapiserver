import Vapor


extension Droplet {
    func setupRoutes() throws {
        
        
        
        
        let v1 = V1()
        try collection(v1)
        
    }
}
