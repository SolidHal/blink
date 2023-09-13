//////////////////////////////////////////////////////////////////////////////////
//
// B L I N K
//
// Copyright (C) 2016-2023 Blink Mobile Shell Project
//
// This file is part of Blink.
//
// Blink is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Blink is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Blink. If not, see <http://www.gnu.org/licenses/>.
//
// In addition, Blink is also subject to certain additional terms under
// GNU GPL version 3 section 7.
//
// You should have received a copy of these additional terms immediately
// following the terms and conditions of the GNU General Public License
// which accompanied the Blink Source Code. If not, see
// <http://www.github.com/blinksh/blink>.
//
////////////////////////////////////////////////////////////////////////////////


import Foundation


struct MoshServerParams {
  let key: String
  let udpPort: String
  // Only used when we expect the IP to be resolved at the remote.
  let remoteIP: String?
}

extension MoshServerParams {
  init(parsing output: String) throws {
    let connectPattern = try! NSRegularExpression(
      pattern: "^MOSH CONNECT (\\d+) (\\S*)$",
      options: []
    )
    if let connectMatch = connectPattern.firstMatch(
         in: output,
         options: [],
         range: NSRange(output.startIndex..., in: output)
       ) {
      self.udpPort = String(output[Range(connectMatch.range(at: 1), in: output)!])
      self.key = String(output[Range(connectMatch.range(at: 2), in: output)!])
    } else {
      throw MoshBootstrapError.NoMoshServerArgs
    }

    let remoteIPPattern = try! NSRegularExpression(
      pattern: "^MOSH SSH_CONNECTION (\\S*) (\\d*) (\\S*) (\\d*)$",
      options: []
    )
    if let remoteIPMatch = remoteIPPattern.firstMatch(
         in: output,
         options: [],
         range: NSRange(location: 0, length: output.utf8.count)
       ) {
      self.remoteIP = String(output[Range(remoteIPMatch.range(at: 3), in: output)!])
    } else {
      self.remoteIP = nil
    }
  }
}
