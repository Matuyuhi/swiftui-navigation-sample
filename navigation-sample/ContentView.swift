//
//  ContentView.swift
//  navigation-sample
//
//  Created by yuhi y on 2023/10/11.
//

import SwiftUI

struct ContentView: View {
    // インスタンスをViewに対して1つだけにしたい時は`@StateObject`を使う
    @ObservedObject private var controller = NaviController()
    var body: some View {
        NavigationStack(path: $controller.stack) {
            VStack {
                List {
                    NavigationLink("pathA", value: NavigationPath.PathA)
                    NavigationLink("pathB", value: NavigationPath.PathB)
                    NavigationLink("pathC", value: NavigationPath.PathC)
                }
            }
            .navigationDestination(for: NavigationPath.self) { path in
                path.Destination(controller: controller)
            }
        }
    }
}




#Preview {
    ContentView()
}
