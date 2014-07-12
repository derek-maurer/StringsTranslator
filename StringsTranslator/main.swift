//
//  main.swift
//  StringsTranslator
//
//  Created by Derek Maurer on 7/11/14.
//  Copyright (c) 2014 Moca Apps. All rights reserved.
//

import Foundation

/////////////////////////////////////////
////////// VARIABLES TO SET /////////////
/////////////////////////////////////////
let originalStringsFilePath = "/path/to/your/strings/file"
let outputPath = "/path/to/your/output/directory"
let originalStringsLanguage = "en" //English
let microsoftTranslatorClientSecret = "ENTER YOUR CLIENT SECRET HERE"
let microsoftTranslatorAppID = "ENTER YOUR APP ID HERE"
/////////////////////////////////////////
/////////////////////////////////////////
/////////////////////////////////////////

var convertToLanguages = ["en":"English",
    "ar":"Arabic",
    "bg":"Bulgarian",
    "ca":"Catalan",
    "zh-CHS":"Chinese Simplified",
    "cs":"Czech",
    "da":"Danish",
    "nl":"Dutch",
    "et":"Estonian",
    "fi":"Finnish",
    "fr":"French",
    "de":"German",
    "el":"Greek",
    "ht":"Haitian Creole",
    "hi":"Hindi",
    "hu":"Hungarian",
    "id":"Indonesian",
    "it":"Italian",
    "ja":"Japanese",
    "ko":"Korean",
    "lv":"Latvian",
    "lt":"Lithuanian",
    "ms":"Malay",
    "mt":"Maltese",
    "no":"Norwegian",
    "fa":"Persian",
    "pl":"Polish",
    "pt":"Portuguese",
    "ro":"Romanian",
    "ru":"Russian",
    "sk":"Slovak",
    "sl":"Slovenian",
    "es":"Spanish",
    "sv":"Swedish",
    "th":"Thai",
    "tr":"Turkish",
    "uk":"Ukrainian",
    "ur":"Urdu",
    "vi":"Vietnamese",
    "cy":"Welsh"]

//This exists because for some reason there are difference in ISO language codes between Apple and Microsoft
let iOSLanguageCodesVsMicrosoftLanguageCodes = ["zh-CHS":"zh-Hans", "da": "da-DK", "hu": "hu-HU", "no":"nb-NO"]

/////////////////////////////////////////////////////////
//Setup access token
/////////////////////////////////////////////////////////

AccessToken.setAppID(microsoftTranslatorAppID)
AccessToken.setClientSecret(microsoftTranslatorClientSecret)

/////////////////////////////////////////////////////////
//Remove the selected language
/////////////////////////////////////////////////////////

convertToLanguages[originalStringsLanguage] = nil

/////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
//Check if all the files exist and load
/////////////////////////////////////////////////////////

if microsoftTranslatorClientSecret == "ENTER YOUR CLIENT SECRET HERE" {
    println("Bro, why didn't you read the README? Make sure you set your client secret")
    exit(0)
}

if microsoftTranslatorAppID == "ENTER YOUR APP ID HERE" {
    println("Bro, why didn't you read the README? Make sure you set your App ID")
    exit(0)
}

if !NSFileManager.defaultManager().fileExistsAtPath(originalStringsFilePath) {
    println("Failed to start translating file because there wasn't a file at path: \(originalStringsFilePath)")
    exit(0)
}

let stringsFileData = NSString(contentsOfFile: originalStringsFilePath, encoding: NSUTF8StringEncoding, error: nil)

if stringsFileData.length <= 0 {
    println("Failed to parse the strings file because it didn't have any content")
    exit(0)
}

let strings = stringsFileData.stringByReplacingOccurrencesOfString(" ", withString: "").componentsSeparatedByString("\n") as [NSString]

/////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
// Start the translation and write to appropriate files
/////////////////////////////////////////////////////////

if let accessToken = AccessToken.accessToken() {
    println("Started translation")
    println("Tranlating \(strings.count) strings to \(convertToLanguages.count) different languages")
    println("=======================================================================")
    
    for line in strings {
        if line.rangeOfString("\"").location != NSNotFound {
            var key = (line.componentsSeparatedByString("=")[0] as NSString).stringByReplacingOccurrencesOfString("\"", withString: "")
            var value = (line.componentsSeparatedByString("=")[1] as NSString).stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString(";", withString: "")
            
            println("Translating: \(value)")
            
            for (lc:String, languageName:String) in convertToLanguages {
                var languageCode = lc
                
                if let alternateLanguageCode = iOSLanguageCodesVsMicrosoftLanguageCodes[languageCode]? {
                    languageCode = alternateLanguageCode
                }
                
                let translatedString = translateStringSynchronously(value, originalStringsLanguage, languageCode)
                
                var fileText = ""
                let filePath = "\(outputPath)/\(languageCode).lproj/Localizable.strings"
                let directoryPath = "\(outputPath)/\(languageCode).lproj"
                
                if !NSFileManager.defaultManager().fileExistsAtPath("directoryPath") {
                    NSFileManager.defaultManager().createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil, error: nil)
                }
                
                if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
                    fileText = NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil)
                }
                else {
                    fileText = "/*\nFile generated by StringsTranslator. http://mocaapps.com \nLanguage: \(languageName)\n*/\n\n"
                }
                
                fileText += "\n\"\(key)\" = \"\(translatedString)\""
                
                fileText.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            }
        }
    }
    
    println("=======================================================================")
    println("Finished translation")
}
else {
    println("Failed to get the accesstoken for microsoft translator")
}

/////////////////////////////////////////////////////////