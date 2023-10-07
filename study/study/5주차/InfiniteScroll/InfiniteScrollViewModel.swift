//
//  InfiniteScrollViewModel.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import Foundation

struct Product: Identifiable {
    var id: UUID
    var name: String
    var price: Int
    
    init(name: String, price: Int) {
        self.id = UUID()
        self.name = name
        self.price = price
    }
}

class InfiniteScrollViewModel: ObservableObject {
    @Published var products = [Product]()
    
    /// 내부적으로 현재 몇 번째 페이지를 불러왔는지 확인하기 위해 사용
    private var page: Int = 0
    
    /// paging x
    func requestProducts() {
        // 데이터를 받아오는데 걸리는 시간을 2초로 설정
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.products.append(contentsOf: (0...20).map {
                Product(name: "page\(self.page), \($0)item", price: (1000...30000).randomElement() ?? 0)
            })
            
            self.page += 1
        }
    }
    
    /// paging
    func requestProductsWith(id: UUID? = nil) {
        if page == 5 { return } // 임의로 페이지 갯수 제한 둠
        
        if (id == nil) || (id == products.last?.id) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.products.append(contentsOf: (0...20).map {
                    Product(name: "page\(self.page), \($0)item", price: (1000...30000).randomElement() ?? 0)
                })
                print("ViewModel 업데이트 성공 페이지 : \(self.page)")
                self.page += 1
            }
        }
    }
}
