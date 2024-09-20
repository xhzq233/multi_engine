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
    @EnvironmentObject var flutterDependencies: FlutterDependencies

    @State var state = false
    var body: some View {
        ScrollView {
            Text("iOS View")

            Button("Present view") {
                flutterDependencies.presentFlutter()
            }
            .padding()

            Button("Show view") {
                flutterDependencies.showFlutter()
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
