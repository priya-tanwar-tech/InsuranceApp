//
//  APICaller.swift
//  PETTest
//
//  Created by Sankalp on 30/11/21.
//

import Foundation

class APICallered : NSObject
{
    var responseData = NSDictionary.init()
    func fetchData(_ appendString: String, completion:@escaping(_ response:NSDictionary?)->Void)
    {
        var urlRequest = URL(string: appendString)
        if (urlRequest == nil)
        {
            urlRequest = URL(string: appendString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }
        print(urlRequest!)
        
        var request = URLRequest(url: urlRequest!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "User-Agent": "Iphone"
        ]

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print(urlRequest!)
            if let error = error {
              print("Error accessing as: \(error)")
                let aDict = NSDictionary.init(object: "", forKey: "Response" as NSCopying)
                completion(aDict)
              return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                          print("Error with the response, unexpected status code: \(String(describing: response))")
                          let aDict = NSDictionary.init(object: "", forKey: "Response" as NSCopying)
                          completion(aDict)
                          return
            }
            if let data = data {
                    var filmSummary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                var k : String!
                if (filmSummary == nil)
                {
                    k = String(decoding: data, as: UTF8.self)
                    k = k.replacingOccurrences(of: "\"", with: "")
                    k = k.replacingOccurrences(of: "\\r\\n", with: "\r\n")
                    k = k.replacingOccurrences(of: "\\", with: "\"")
                    filmSummary =   Common.sharedCommon.convertToDictionary(text: k)
                }
                if (filmSummary != nil)
                {
                    print(filmSummary!)
                    self.responseData = filmSummary as! NSDictionary
                    completion(self.responseData)
                }
                else
                {
                    let s = NSMutableDictionary.init()
                    s.setValue(k, forKey: "BoolValue")
                    print(s)
                    completion(s)
                }
            }
        })
        task.resume()
    }
        
    func POSTMethodForDataToGet(dataToPass thisData: NSDictionary?, toURL urlRequest: String,completion:@escaping(_ response:NSDictionary?)->Void)
    {
        var url = URL(string: urlRequest)
        if (url == nil)
        {
            url = URL(string: urlRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }

        print(url!)

        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.timeoutInterval = 100
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "User-Agent": "Iphone"
        ]

        var upData : Data!
        // Set HTTP Request Body
        if (thisData != nil)
        {
            upData = try! JSONSerialization.data(withJSONObject: thisData as Any, options: .prettyPrinted)
        }
        else
        {
            upData = Data.init()
        }
        
        URLSession.shared.uploadTask(with: request, from: upData) { (responseData, response, error) in
            if let error = error {
                print("Error making POST request: \(error.localizedDescription)")
                let aDict = NSDictionary.init(object: "", forKey: "Response" as NSCopying)
                completion(aDict)
                return
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    print("Invalid response code: \(responseCode)")
                    let aDict = NSDictionary.init(object: "", forKey: "Response" as NSCopying)
                    completion(aDict)
                    return
                }
//                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .fragmentsAllowed) {
                    print(responseJSONData)
                    if (responseJSONData is NSDictionary)
                    {
                        self.responseData = responseJSONData as! NSDictionary
                    }
                    else
                    {
                        let s = NSMutableDictionary.init()
                        s.setValue(responseJSONData, forKey: "BoolValue")
                        print(s)
                        self.responseData = s
                    }
                    completion(self.responseData)
                }
            }
        }.resume()
    }
}
/*
 String demouser = "{\n" +
         "  \"RoleName\": \"Associate\",\n" +
         "  \"Success\": true,\n" +
         "  \"UserDetail\": {\n" +
         "    \"AadhaarNo\": \"\",\n" +
         "    \"CertficateNumber\": \"\",\n" +
         "    \"IsPOS\": false,\n" +
         "    \"MobileNumber\": \"8486723128\",\n" +
         "    \"POSCityName\": \"Lumding\",\n" +
         "    \"POSCode\": \"\",\n" +
         "    \"POSLicenseExpiryDate\": \"/Date(-62135596800000)/\",\n" +
         "    \"PanCardNumber\": \"\",\n" +
         "    \"RMCode\": \"P625131\",\n" +
         "    \"RMMobile\": \"9435534177\",\n" +
         "    \"RMName\": \"SUMI DEB SARMAH\",\n" +
         "    \"Region\": \"Assam\",\n" +
         "    \"UserID\": 15929,\n" +
         "    \"FirstName\": \"ABHISHEK\",\n" +
         "    \"Gender\": \"M\",\n" +
         "    \"LastName\": \"MANDAL\",\n" +
         "    \"LoginStatus\": \"true\",\n" +
         "    \"MiddleName\": \"\",\n" +
         "    \"Msg\": \"\",\n" +
         "    \"RoleID\": 3,\n" +
         "    \"RoleName\": \"Associate\",\n" +
         "    \"UserMailId\": \"abhishekmandal065@gmail.com\"\n" +
         "  },\n" +
         "  \"UserId\": 15929\n" +
         "}";
 SessionManager sessionManager1 = new SessionManager();
 sessionManager1.setContext(Constants.APPLICATION_STATE, getActivity());
 sessionManager1.saveData("login_response_model", demouser);
 sessionManager1.saveBooleanData("is_logged_in", true);
 */
