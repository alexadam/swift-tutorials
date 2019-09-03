
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
