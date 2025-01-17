//
// Copyright 2020 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import XCTest

@testable import Riot

class HomeserverConfigurationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Tests
    
    func testHomeserverConfigurationBuilder() {
    
        let expectedJitsiServer = "your.jitsi.example.org"
        let expectedJitsiServerStringURL = "https://\(expectedJitsiServer)"
        let expectedDeprecatedJitsiServer = "your.deprecated.jitsi.example.org"
        let expectedE2EEEByDefaultEnabled = true
        let expectedDeprecatedE2EEEByDefaultEnabled = false
        let expectedMapStyleURLString = "https://your.tileserver.org/style.json"
    
        let wellKnownDictionary: [String: Any] = [
            "m.homeserver": [
                 "base_url": "https://your.homeserver.org"
            ],
             "m.identity_server": [
                 "base_url": "https://your.identity-server.org"
            ],
            "m.tile_server": [
                 "map_style_url": expectedMapStyleURLString
            ],
            "im.vector.riot.e2ee" : [
                "default" : expectedDeprecatedE2EEEByDefaultEnabled
            ],
            "im.vector.riot.jitsi" : [
                "preferredDomain" : expectedDeprecatedJitsiServer
            ],
            "io.element.e2ee" : [
                "default" : expectedE2EEEByDefaultEnabled
            ],
            "io.element.jitsi" : [
                "preferredDomain" : expectedJitsiServer
            ]
        ]
        
        let wellKnown = MXWellKnown(fromJSON: wellKnownDictionary)
        
        let homeserverConfigurationBuilder = HomeserverConfigurationBuilder()
        let homeserverConfiguration = homeserverConfigurationBuilder.build(from: wellKnown)
    
        XCTAssertEqual(homeserverConfiguration.jitsi.serverDomain, expectedJitsiServer)
        XCTAssertEqual(homeserverConfiguration.jitsi.serverURL.absoluteString, expectedJitsiServerStringURL)
        XCTAssertEqual(homeserverConfiguration.isE2EEByDefaultEnabled, expectedE2EEEByDefaultEnabled)
        
        XCTAssertEqual(homeserverConfiguration.tileServer.mapStyleURL.absoluteString, expectedMapStyleURLString)
    }
}
