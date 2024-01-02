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
