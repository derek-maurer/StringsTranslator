//
//  Translator.swift
//  StringsTranslator
//
//  Created by Derek Maurer on 7/11/14.
//  Copyright (c) 2014 Moca Apps. All rights reserved.
//

import Foundation

let rootAPIURL = "http://api.microsofttranslator.com/v2/Http.svc/Translate?"

func translateStringSynchronously(originalString: String, fromLanguage:String, toLanguage: String) -> String? {
    if let accessToken = AccessToken.accessToken()? {
        var error: NSError? = nil
        let request = NSMutableURLRequest(URL: NSURL.URLWithString("\(rootAPIURL)Text=\(originalString)&To=\(toLanguage)&From=\(fromLanguage)"))
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        var reponse: NSURLResponse? = nil
        let returnedData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &reponse, error: &error)
        
        if let data = returnedData {
            var dataString = NSString(data: returnedData, encoding: NSUTF8StringEncoding)
            dataString = dataString.stringByReplacingOccurrencesOfString("<string xmlns=\"http://schemas.microsoft.com/2003/10/Serialization/\">", withString: "")
            dataString = dataString.stringByReplacingOccurrencesOfString("</string>", withString: "")
            return dataString
        }
    }
    
    return nil
}