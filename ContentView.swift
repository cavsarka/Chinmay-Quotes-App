//
//  ContentView.swift
//  Quotes App
//
//  Created by Chinmay Avsarkar on 7/10/21.
//

import SwiftUI
import SDWebImageSwiftUI
// import SDWebImageSwiftUI - allows for async image loading and caching


// API KEY -

@available(iOS 15.0, *)
struct ContentView: View {
    
    @State private var quoteData: QuoteData?
    @State private var imageUrl: ImageData?

    
    var body: some View {
        
        
        ZStack {
            
            //White background on the screen
            Rectangle().foregroundColor(.white).ignoresSafeArea()
            
            HStack {
                    
                    Spacer()
                    
                    //Main Vertical Stack for quote, author, refresh
                    VStack{
                        
                        Spacer()
                        
                        //Quote w/ background
                        Text(quoteData?.q ?? "Nothing")
                            .padding(.all)
                            .background(AnimatedImage(url: URL(string: imageUrl?.urls.regular ?? "No url")).blur(radius: 5))
                        .cornerRadius(15)
                        .shadow(radius: 20)
                        .foregroundColor(.white)
                            .font(.system(size: 30))
                        
                        
                        //Quote author
                        Text(quoteData?.a ?? "Nothing").foregroundColor(.black)
                    
                        // Text(imageUrl?.urls.regular ?? "no url")
                        
                        // Image(uiImage: imageUrl?.urls.regular ?? "no url")
                        
                        
                        
                        // Image(uiImage:  "https://images.unsplash.com/photo-1625675922341-4bf48403c9aa?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=MnwyNDU4Nzh8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MjYwMTIyMDY\u0026ixlib=rb-1.2.1\u0026q=80\u0026w=1080".load())
                        
                        
                        Spacer()
                        
                        Button {
                            loadImageData()
                            loadQuoteData()
                        } label: {
                            Image(systemName: "arrow.clockwise").foregroundColor(.black)
                                .padding(20)
                        }.font(.title)
                        .padding(.top)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        
                        
                    }.onAppear(perform: {loadQuoteData()})
                    .onAppear(perform: {loadImageData()})
                    .background(Color.white)
                //Loads quote and image data every time the view is show.
                
                
                    Spacer()
                    
                
            }
        }
        
    }
    
    private func loadQuoteData() {
        guard let url = URL(string: "https://zenquotes.io/api/quotes/613bcce458648882af2fff80e5cb46799b4fbf70") else {return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedData = try? JSONDecoder().decode([QuoteData].self, from: data) {
                    DispatchQueue.main.async {
                        print(decodedData)
                        self.quoteData = decodedData.first
                        
                        
            }
            
                }
                
            }
        }.resume()
    }
    
    private func loadImageData() {
        guard let url = URL(string: "https://api.unsplash.com/photos/random/?topics=nature&client_id=oFqCqq9h5M-DYXtR2vsTfnhu6gMozvH5fi3iZnY6XMM") else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedImageData = try? JSONDecoder().decode(ImageData.self, from: data) {
                    DispatchQueue.main.async {
                        self.imageUrl = decodedImageData
                    }
                }
            }
        }.resume()
    }
    
}

struct QuoteData: Codable {
    var q: String
    var a: String
}

struct ImageData: Codable{
    var urls: ImageUrls
}

struct ImageUrls: Codable {
    var regular: String
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView()
        } else {
            // Fallback on earlier versions
        }
    }
}


