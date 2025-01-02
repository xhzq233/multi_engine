//
//  ContentView.swift
//  Runner
//
//  Created by 夏侯臻 on 9/20/24.
//

import SwiftUI
import CoreData
import Flutter

struct ContentView: View {
    @EnvironmentObject var flutterDependencies: AppDelegate

    @State var state = false
    var body: some View {
        ScrollView {
            Text("iOS View")
            
            Button("Push view") {
                flutterDependencies.pushFlutter()
            }
            .padding()
        }
    }
}
