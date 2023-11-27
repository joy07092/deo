//
//  NewsTabView.swift
//  iNEWS
//


import SwiftUI
import FirebaseAuth

struct NewsTabView: View {
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    @AppStorage("uid") var userID: String = ""
    @State private var showToast = true
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken, loadTask)
                .refreshable(action: refreshTask)
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                .navigationBarItems(leading: LogoutButton, trailing: menu)
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        default: EmptyView()
        }
    }
    
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @Sendable
    private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
    
    
    private func refreshTask() {
        DispatchQueue.main.async {
            articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
        }
    }
    
    private var menu: some View {
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
    
    private var LogoutButton: some View {
            Button(action: {
                let firebaseAuth = Auth.auth()
                                do {
                                    try firebaseAuth.signOut()
                                    withAnimation {
                                        userID = ""
                                        ToastMessageView(message: "Signed out", isShowing: $showToast)
                                    }
                                } catch let signOutError as NSError {
                                    print("Error signing out: %@", signOutError)
                                }
                            })  {
                //Image(systemName: "arrow.left.circle.fill")
                                Image(systemName: "person.crop.circle.badge.minus")
                    .imageScale(.large)
            }
        }
}

struct NewsTabView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared

    
    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            .environmentObject(articleBookmarkVM)
    }
}
