//
//  jsonhelpers.swift
//  MOBA2_Lab_iTunes3
//
//  Created by Tony Mamaril on 13.05.23.
//

import Foundation

class Jsonhelpers {
    // helpers

    class func loadAlbums(searchEntry: String) -> [ArtistItem] {
        do {
            let urlString = "https://itunes.apple.com/search?term=" + searchEntry + "&entity=album"
            let urlEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlFinal = URL(string: urlEncoded)!
            let data = try Data(contentsOf: urlFinal)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ArtistWrapper.self, from: data)
            
            return decodedData.results.filter({
                return $0.collectionType != nil
            })
        } catch {
            fatalError("json not loaded\n\(error)")
        }
    }

    class func loadSongs(collectionId: Int) -> [Song] {
        do {
            let urlString = "https://itunes.apple.com/lookup?id=" + String(collectionId) + "&entity=song"
            
            print(urlString)
            
            let urlEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlFinal = URL(string: urlEncoded)!
            let data = try Data(contentsOf: urlFinal)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(SongWrapper.self, from: data)
            
            print(decodedData)
            
            // TODO careful with filter here!!!
            return decodedData.results.filter({
                return $0.wrapperType != "collection"
            })
        } catch {
            fatalError("json not loaded\n\(error)")
        }
    }

    class func loadOneAlbum(collectionId: Int) -> ArtistItem {
        do {
            let urlString = "https://itunes.apple.com/lookup?id=" + String(collectionId) + "&entity=song"
            
            print(urlString)

            
            let urlEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlFinal = URL(string: urlEncoded)!
            let data = try Data(contentsOf: urlFinal)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ArtistWrapper.self, from: data)
            
            return decodedData.results.filter({
                return $0.collectionType != nil
            })[0]
        } catch {
            fatalError("json not loaded\n\(error)")
        }
    }
    
}
