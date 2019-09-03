
# JSON encode / aDecoder

## Dictionary to JSON

```
let jsonObject: NSMutableDictionary = NSMutableDictionary()

        jsonObject.setValue("val1", forKey: "b")
        jsonObject.setValue("val2", forKey: "p")
        jsonObject.setValue("val2", forKey: "o")
        jsonObject.setValue("val2", forKey: "s")
        jsonObject.setValue("val2", forKey: "r")

        let jsonObject2: NSMutableDictionary = NSMutableDictionary()

        jsonObject2.setValue("val1", forKey: "b")
        jsonObject2.setValue(jsonObject, forKey: "OBJ")


        let jsonData: NSData

        do {
           jsonData = try JSONSerialization.data(withJSONObject: jsonObject2, options: JSONSerialization.WritingOptions()) as NSData

           let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String\

           // OR

           let jsonString2 = String(data: jsonData as Data, encoding: String.Encoding.utf16)

            print("json string = \(jsonString)")
        catch {
                print("error \(error)")
        }
```

## JSON to Dictionary

```
var result : NSDictionary = [:]
if let data = textContent.data(using: .utf8) {
    do {
        result = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
    } catch {
        print(error)
    }
}
```

# Implement Codable protocol

## Data model objects

src: https://matteomanferdini.com/codable/

```

struct Item: Codable {
    var id: Int = 0
    var name: String = ""

    init() {...}

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }

    init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
       id = try values.decode(Int.self, forKey: .id)
       name = try values.decode(String.self, forKey: .name)
   }
}


struct Inventory: Codable {
    var name: String = ""
    var itemsInInventory: [Item] = []

    init () {...}

    enum CodingKeys: String, CodingKey {
        case name
        case itemsInInventory = "items"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(itemsInInventory, forKey: .itemsInInventory)
    }

    init(from decoder: Decoder) throws {
       let values = try decoder.container(keyedBy: CodingKeys.self)
       name = try values.decode(String.self, forKey: .name)
       id = try values.decode([Item].self, forKey: .itemsInInventory)
   }
}

...

func codeDecodeJson() {

    let inventory = Inventory(...)

    var je = JSONEncoder()
    var res = try je.encode(inventory)
    let jsonStr = String(data: res, encoding: String.Encoding.utf8)
    print("json string \(jsonStr)")


    let jd = JSONDecoder()
    let resd = try jd.decode([Inventory].self, from: res)
    print("how many items in inventory: \(resd.count)")

}


```
