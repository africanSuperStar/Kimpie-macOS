//
//  TextView.swift
//  SwiftUIParsec
//
//  Created by Cameron de Bruyn on 2021/04/29.
//

import SwiftUI

//{
//    "view": "Text",
//    "init": {
//        "content": null,
//        "localizedStringKey": null,
//        "verbatim": null,
//        "image": null,
//        "date": null
//    },
//    "font": {
//        "isCustom": null,
//        "isBold": null,
//        "isItalic": null,
//        "isMonospacedDigit": null,
//        "isSmallCaps": null,
//        "isLowercaseSmallCaps": null,
//        "isUppercaseSmallCaps": null,
//        "leading": {
//            "init": {
//                "leading": null
//            }
//        }
//
//    }
//}

extension Text
{
    public init(url: URL)
    {
        if let data = try? Data(contentsOf: url),
           let jsonString = String(data: data, encoding: .utf8)
        {
            self.init(data: jsonString)
        }
        else
        {
            self.init("")
        }
    }
    
    public init(data: String)
    {
        self.init("")
        
        if let json = try? JSONParser(data: data)
        {
            self = parseText(json)
            self = parseFont(json)
        }
    }
    
    public init(parser: JSONParser)
    {
        self.init("")
        
        self = parseText(parser)
        self = parseFont(parser)
    }
    
    public func parseText(_ json: JSONParser) -> Self
    {
        if let _view = json["view"].string,
        _view == "Text"
        {
            if let _content = json["init"]["content"].string, !_content.isEmpty
            {
                return Self(_content)
            }
            else if let _key = json["init"]["localizedStringKey"].string, !_key.isEmpty
            {
                return Self(LocalizedString(_key))
            }
            else if let _verbatim = json["init"]["verbatim"].string, !_verbatim.isEmpty
            {
                return Self(verbatim: _verbatim)
            }
            else if let _image = json["init"]["image"].string
            {
                return Self(Image(_image))
            }
        }
        
        return Self("")
    }

    public func parseFont(_ json: JSONParser) -> Self
    {
        let _font = Font.parseJSON(json)
        
        return self.font(_font)
    }
}

extension Font
{
    public static func parseJSON(_ json: JSONParser) -> Self
    {
        let _isBold               = json["font"]["isBold"].bool               ?? false
        let _isItalic             = json["font"]["isItalic"].bool             ?? false
        let _isMonospacedDigit    = json["font"]["isMonospacedDigit"].bool    ?? false
        let _isSmallCaps          = json["font"]["isSmallCaps"].bool          ?? false
        let _isLowercaseSmallCaps = json["font"]["islowercaseSmallCaps"].bool ?? false
        let _isUppercaseSmallCaps = json["font"]["isUppercaseSmallCaps"].bool ?? false
        
        var _font = Font.title
        
        _isBold               ? _font = _font.bold()               : nil
        _isItalic             ? _font = _font.italic()             : nil
        _isMonospacedDigit    ? _font = _font.monospacedDigit()    : nil
        _isSmallCaps          ? _font = _font.smallCaps()          : nil
        _isLowercaseSmallCaps ? _font = _font.lowercaseSmallCaps() : nil
        _isUppercaseSmallCaps ? _font = _font.uppercaseSmallCaps() : nil

        return _font
    }
}
