#  References

### RandomUserApi
- https://www.youtube.com/watch?v=aMes-DVVJg4&list=PLgOlaPUIbynqyJHiTEv7CFaXd8g5jtogT
- https://www.youtube.com/watch?v=zpk8ZviA8Pg&list=PLgOlaPUIbynqyJHiTEv7CFaXd8g5jtogT

## api에서 받아온 값을 통해 Model의 Identifiable id 지정하고 싶을 때
```Swift
struct RandomUser: Codable, Identifiable {
    var id: String {
        return "\(userID.name)\(userID.value ?? "")"
    }
    
    var userID: RandomUserID
    var name: RandomUserName
    var picture: RandomUserPicture
    
    private enum CodingKeys: String, CodingKey {
        case userID = "id"
        case name
        case picture
    }
}

struct RandomUserID: Codable {
    let name: String
    let value: String?
}

```
- 서버로 부터 받아온 값을 ID로 사용하고 싶을 때
- Computed Propertis를 사용할 수 있음

### Closure 응용
```Swift
extension RandomUserView {
    fileprivate func configureRefreshControl(_ tableView: UICollectionView) {
        let refreshControl = UIRefreshControl()
        refreshControlHelper.refreshControl = refreshControl
        refreshControlHelper.parentContentView = self
        refreshControl.addTarget(refreshControlHelper, action: #selector(refreshControlHelper.didRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}
```

```Swift
// 생략
        .introspect(.list, on: .iOS(.v17), customize: configureRefreshControl(_:))
or 
// 생략
        .introspect(.list, on: .iOS(.v17) {
            configureRefreshControl(_:)
        }
```

### iOS 15 new modifier .refreshable
```Swift
        List(viewModel.randomUsers) { randomUser in
            RandomUserRowView(randomUser: randomUser)
        }
        .refreshable {
            viewModel.refreshActionSubject.send()
        }
```

### 중복 코드 줄이기
```Swift
    fileprivate func fetchMore()  {
        guard let page = pageInfo?.page else { return }
        
        let pageToLoad = page + 1
        self.fetchRandomUsers(pageToLoad)
    }
    
    fileprivate func fetchRandomUsers(_ currentPage: Int? = nil) {
        let page = currentPage == nil ? 1 : currentPage!
        
        self.isLoading = true
        
        AF.request(RandomUserRouter.getUsers(page: page))
            .publishDecodable(type: RandomUserResponse.self)
//            .compactMap { $0.value?.results }
            .compactMap { $0.value }
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] receivedValue in
                print(receivedValue.description)
//                self?.randomUsers.append(contentsOf: receivedValue)
                self?.randomUsers += receivedValue.results
                self?.pageInfo = receivedValue.info
                
                self?.isLoading = false
            }
            .store(in: &subscription)
    }
```
- fetchMore()을 파라미터 없이 호출하면 page가 1이기 때문에 초기화 코드와 동일함

### Asset Color 
- Asset에서 new color set을 추가하면 light, dark 모드에 대응할 수 있음
