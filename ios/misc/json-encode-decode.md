# Create Json Encoder/Decoder for a class

Example:

```
struct TimePattern: Codable {
    
    var id: String
    var name: String = ""
    var timeIntervals: [TBTimeInterval] = []
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
    
    init(name: String, timeIntervals: [TBTimeInterval]) {
        self.id = UUID().uuidString
        self.name = name
        self.timeIntervals = timeIntervals
    }
    
    ///
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case timeIntervals = "intervals"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(timeIntervals, forKey: .timeIntervals)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        timeIntervals = try values.decode([TBTimeInterval].self, forKey: .timeIntervals)
    }
    
}
```

## To / From Json

```
 func toJsonString() -> String {
        do {
            let je = JSONEncoder()
            let data = try je.encode(DataManager.shared.getTimePatterns())
            let json = String(data: data, encoding: String.Encoding.utf8)
            return json!
        } catch  {
            print(error)
            return ""
        }
    }
    
    func fromJsonString(jsonString: String) {
        do {
            let jsonData = jsonString.data(using: .utf8)
            let jd = JSONDecoder()
            timePatterns = try jd.decode([TimePattern].self, from: jsonData!)
        } catch {
            print(error)
            initDefaultData()
        }
    }
```