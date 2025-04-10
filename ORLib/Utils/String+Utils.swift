//
//  String+Utils.swift
//  GenericApp
//
//  Created by Michael Rademaker on 26/10/2020.
//  Copyright © 2020 OpenRemote. All rights reserved.
//

import Foundation

extension String {

  func stringByURLEncoding() -> String? {

    let characters = CharacterSet.urlQueryAllowed.union(CharacterSet(charactersIn: "#"))

    guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: characters) else {
      return nil
    }

    return encodedString
  }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }

    func buildBaseUrlFromDomain() -> String {
        do {
            let pattern = "^(?:([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6}))$"
            let ipv6NoSchemeNoPort = try NSRegularExpression(pattern: pattern)
            let numberOfMatches = ipv6NoSchemeNoPort.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            if numberOfMatches == 1 {
                return "https://[\(self)]"
            }
        } catch let error as NSError {
            print("Error creating NSRegularExpression: \(error)")
        }
        /*
        do {
            let ipv4 = try NSRegularExpression(pattern: "^http(s)?://((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.)){3}+((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$")
            let numberOfMatches = ipv4.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            if numberOfMatches == 1 {
                return self
            }
        } catch let error as NSError {
            print("Error creating NSRegularExpression: \(error)")
        }

        do {
            let ipv4 = try NSRegularExpression(pattern: "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.)){3}+((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$")
            let numberOfMatches = ipv4.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            if numberOfMatches == 1 {
                return "https://\(self)"
            }
        } catch let error as NSError {
            print("Error creating NSRegularExpression: \(error)")
        }
        */

        if self.starts(with: "https://") || self.starts(with: "http://") {
            if self.firstIndex(of: ".") != nil || self.firstIndex(of: "[") != nil {
                return self
            } else {
                return "\(self).openremote.app"
            }
        } else if self.firstIndex(of: ".") != nil || self.firstIndex(of: "[") != nil {
            return "https://\(self)"
        }
        return "https://\(self).openremote.app"
    }


}
