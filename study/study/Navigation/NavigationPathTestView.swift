//
//  NavigationPathTestView.swift
//  study
//
//  Created by zumin you on 2023/12/30.
//

import SwiftUI

struct Fruit: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let emoji: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

// MARK: - NavigationLink

//struct FruitView: View {
//    
//    private var fruits = [Fruit(name: "사과", emoji: "🍎"), Fruit(name: "오렌지", emoji: "🍊"), Fruit(name: "바나나", emoji: "🍌")]
//    
//    var body: some View {
//        NavigationStack {
//            List(fruits) { fruit in
//                NavigationLink(fruit.name, value: fruit)
//            }
//            .navigationDestination(for: Fruit.self) { fruit in
//                FruitDetailView(fruit: fruit)
//            }
//        }
//    }
//}

struct FruitView: View {
    private var fruits = [Fruit(name: "사과", emoji: "🍎"), Fruit(name: "오렌지", emoji: "🍊"), Fruit(name: "바나나", emoji: "🍌")]
    
    var body: some View {
        NavigationStack {
            List(fruits) { fruit in
//                NavigationLink(fruit.name) {
//                    FruitDetailView(fruit: fruit)
//                }
                NavigationLink {
                    FruitDetailView(fruit: fruit)
                } label: {
                    VStack {
                        Text(fruit.name)
                        Text(fruit.emoji)
                    }
                }

            }
        }
    }
}

struct FruitDetailView: View {
    let fruit: Fruit
    
    var body: some View {
        VStack {
            Text(fruit.emoji)
                .font(.largeTitle)
            Text(fruit.name)
        }
    }
}

#Preview {
    FruitView()
}

#Preview {
    FruitDetailView(fruit: Fruit(name: "포도", emoji: "🍇"))
}


// MARK: - path

struct FruitContainerView: View {
    private var fruits = [Fruit(name: "사과", emoji: "🍎"), Fruit(name: "오렌지", emoji: "🍊"), Fruit(name: "바나나", emoji: "🍌")]
    @State private var path: [Fruit] = []
    
    var body: some View {
        NavigationStack(path: $path) { // path 바인딩
            List(fruits) { fruit in
                NavigationLink(fruit.name + fruit.emoji, value: fruit)
            } //: List
            .navigationDestination(for: Fruit.self) { fruit in
                FruitDetailView(fruit: fruit)
                    .toolbar {
                        Button("같은 과일!") {
                            path.append(fruit)
                        }
                        
                        Button("홈으로 돌아가기!") {
                            path.removeAll()
                        }
                    }
            }
        } //: NavigationStack
    } //: body
}

#Preview {
    FruitContainerView()
}


// MARK: path with different values (routing)

enum FruitRoute: Hashable {
    case detail(Fruit)
    case setting(String)
}

struct FruitHomeView: View {
    private var fruits = [Fruit(name: "사과", emoji: "🍎"), Fruit(name: "오렌지", emoji: "🍊"), Fruit(name: "바나나", emoji: "🍌")]
    @State private var path: [FruitRoute] = [] // how i can di to child view..
    
    var body: some View {
        NavigationStack(path: $path) {
            List(fruits) { fruit in
                NavigationLink(fruit.name + fruit.emoji, value: FruitRoute.detail(fruit))
            } //: List
            .navigationDestination(for: FruitRoute.self) { route in
                switch route {
                case .detail(let fruit):
                    FruitDetailView(fruit: fruit)
                        .toolbar {
                            Button("같은 과일!") {
                                path.append(.detail(fruit))
                            }
                            
                            Button("과일 환경설정") {
                                path.append(.setting(fruit.name))
                            }
                            
                            Button("홈으로 돌아가기!") {
                                path.removeAll()
                            }
                        }
                case .setting(let title):
                    VStack {
                        Text(title)
                    }
                    .toolbar {
                        Button("홈으로 돌아가기!") {
                            path.removeAll()
                        }
                    }
                }
            } //: NavigationDestination
        } //: NavigationStack
    }
}

#Preview {
    FruitHomeView()
}
