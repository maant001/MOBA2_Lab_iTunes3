//
//  ContentView.swift
//  MOBA2_Lab_iTunes3
//
//  Created by Tony Mamaril on 13.05.23.
//

import SwiftUI


// views

struct ContentView: View {
    @State var artistList = [ArtistItem] ()
    @State var searchEntry : String = "The Rolling Stones"
    
    var body: some View {
        
        // TODO
        VStack {
            
            HStack {
                TextField("Search", text: $searchEntry, onCommit: {
                    self.artistList = Jsonhelpers.loadAlbums(searchEntry: self.searchEntry)
                })
                Image(systemName: "magnifyingglass")
            }.padding().background(Color(.secondarySystemBackground)).cornerRadius(15.5)
                
            NavigationView {
                List(artistList) { artistItem in
                    
                    NavigationLink(destination: AlbumDetailView(album: Jsonhelpers.loadOneAlbum(collectionId: artistItem.id), songs: Jsonhelpers.loadSongs(collectionId: artistItem.id), collectionId: artistItem.id)) {
                        
                        HStack {
                            Image(uiImage: artistItem.albumCover ?? UIImage()).shadow(radius: 3)
                            VStack {
                                Text(artistItem.collectionName!).frame(maxWidth: .infinity, alignment: .center)
                                Text(artistItem.artistName!).font(.footnote)
                            }
                        }
                        
                    }

                }.onAppear() {
                    DispatchQueue.main.async {
                        self.artistList = Jsonhelpers.loadAlbums(searchEntry: self.searchEntry)
                    }
                }
            }
        }
    }
}

struct AlbumDetailView : View {
    @State var album : ArtistItem
    @State var songs = [Song] ()
    var collectionId : Int
    
    var body : some View {
        
        VStack(alignment: .center) {
            
            Text(album.collectionName!)
            Text(album.formattedReleaseDate!).font(.subheadline)
            Image(uiImage: album.albumCover ?? UIImage())
            
            List(songs) { song in
                
                HStack {
                    
                    //Text(String(song.trackNumber ?? 0))
                    //Text(song.trackName!)
                    //Text(String(song.time))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// structs

struct ArtistItem: Identifiable, Decodable {
    var artistName : String?
    var collectionName : String?
    var collectionType : String?
    var collectionId : Int?
    var id: Int {
        get {
            return collectionId ?? 0
        }
    }
    
    // important that the attribute names are the same than in call/json!
    var artworkUrl100: String?
    var albumCover : UIImage? {
        get {
            return loadAlbumImage(urlImage: self.artworkUrl100)
        }
    }
    
    var releaseDate: String?
    var formattedReleaseDate: String? {
        get {
            return String(releaseDate!.prefix(9))
        }
    }
    
    func loadAlbumImage(urlImage: String?) -> UIImage? {
        if urlImage != nil {
            let url = NSURL(string: urlImage!)! as URL
            
            if let imageContent: NSData = NSData(contentsOf: url) {
                let albumImage = UIImage(data: imageContent as Data)
                return albumImage
            }
        }
        
        return nil
    }
}

struct ArtistWrapper: Decodable {
    // needs to be named results, because check json file!
    // "results": [...
    var results : [ArtistItem]
}

struct Song: Identifiable, Decodable {
    var trackId: Int?
    var wrapperType: String?
    var trackName: String?
    //var trackNumber: Int?
    var trackTimeMillis: Int?
    var id: Int {
        get {
            return trackId ?? 0
        }
    }
    
    var time: String {
        get {
            return convertMilliSeconds(trackTimeMillis!)
        }
    }
    
    func convertMilliSeconds(_ timeInMilliSeconds : Int) -> String {
        let seconds = timeInMilliSeconds / 1000
        let minutes = seconds / 60
        let true_seconds = seconds / 60
        var string_seconds = String(true_seconds)
        
        if (string_seconds.count == 1) {
            string_seconds = "0" + string_seconds
        }
        
        return String(minutes) + ":" + string_seconds
    }
}

struct SongWrapper: Decodable {
    var results: [Song]
}


