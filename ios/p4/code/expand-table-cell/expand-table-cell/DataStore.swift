

class DataStore {
    
    static let shared = DataStore()
    
    var data: [DataModel] = []
    
    private init() {
        initData()
    }
    
    
    func initData() {
        let d1 = DataModel(title: "Title 1", description: "description 1")
        data.append(d1)
        
        let d2 = DataModel(title: "Title 2", description: "description 2")
        data.append(d2)
        
        let d3 = DataModel(title: "Title 3", description: "description 3")
        data.append(d3)
    }
    
    
}
