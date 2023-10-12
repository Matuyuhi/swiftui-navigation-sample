//
//  navigation.swift
//  navigation-sample
//
//  Created by yuhi y on 2023/10/12.
//

import Foundation
import SwiftUI

enum NavigationPath{
    case PathA, PathB, PathC, PathD
    
    // pathそれぞれのview
    @ViewBuilder
    func Destination(controller: NaviController) -> some View{
       switch self {
       case .PathA: PathAView(controller: controller)
       case .PathB: PathBView(controller: controller)
       case .PathC: PathCView(controller: controller)
       case .PathD: PathDView(controller: controller)
       }
   }
}

struct PathAView: View {
    var controller: NaviController
    
    // `StateObject`なので、初回遷移時に初期化される
    @StateObject private var viewModel = PathAViewModel()
    
    var body: some View {
        Text("Hello, PathA! count : \(viewModel.count)")
        List {
            Button("pathB") {
                controller.navigationB()
            }
            Button("pathC") {
                controller.navigationC()
            }
        }
        .navigationTitle("A画面")
        .onAppear {
            viewModel.addCount()
        }
    }
}


struct PathBView: View {
    var controller: NaviController
    var body: some View {
        VStack {
            Text("Hello, PathB!")
        }
        .navigationTitle("B画面")
    }
}

struct PathCView: View {
    var controller: NaviController
    var body: some View {
        Text("Hello, PathC!")
        List {
            Button("pathD") {
                controller.navigationD()
            }
        }
        .navigationTitle("C画面")
    }
}

struct PathDView: View {
    var controller: NaviController
    var body: some View {
        Text("Hello, PathD!")
        List {
            Button("go Root") {
                controller.navigationReset()
            }
        }
        .navigationTitle("D画面")
    }
}



private class PathAViewModel: ObservableObject {
    
    @Published var count: Int = 0
    init() {
        print("pathA init")
        
        DispatchQueue.main.async {
            self.count = 0
        }
    }
    
    func addCount() {
        DispatchQueue.main.async {
            self.count += 1
        }
    }
}


// 配列を直接操作させない
// nabigationLink以外でもfuncで遷移できるようにする
class NaviController: ObservableObject {
    @Published public var stack: [NavigationPath] = []
    
    func navigationReset() {
        stack.removeLast(stack.count)
    }
    
    func navigationPrev() {
        stack.removeLast()
    }
    
    // すでに配列にpathが存在するなら再度追加せずにremoveで遷移させる
    private func addPath(_ path: NavigationPath) {
        if let index = stack.firstIndex(of: path) {
            stack.removeSubrange(index+1..<stack.count)
        } else {
            stack.append(path)
        }
    }

    func navigationA() {
        addPath(.PathA)
    }

    func navigationB() {
        addPath(.PathB)
    }

    func navigationC() {
        addPath(.PathC)
    }

    func navigationD() {
        addPath(.PathD)
    }
}
