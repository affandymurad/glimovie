//
//  MoviePresenter.swift
//  glimovie
//
//  Created by Affandy Murad on 05/03/22.
//

import Foundation
import UIKit

class MoviePresenter: BasePresenter<MovieDelegates> {
    var movieList: [MovieList] = []

    func getMovieList(region: String, genre: String, pages: String){
        self.view.taskDidBegin()
        let endpoint = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(Config.shared.apiKey)&region=\(region)&with_genres=\(genre)&page=\(pages)")
        guard let url =  endpoint else { return }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, _) in
            guard let data = data else {
                self.view.taskDidError(txt: "Unknown")
                return
            }
            
            do{
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                self.movieList = movie.results ?? []
                self.view.loadMovieList(movies: self.movieList)
            } catch {
                do{
                    let errors = try JSONDecoder().decode(Errors.self, from: data)
                    self.view.taskDidError(txt: errors.status_message)
                } catch DecodingError.keyNotFound(let key, let context) {
                      self.view.taskDidError(txt: "could not find key \(key) in JSON: \(context.debugDescription)")
                  } catch DecodingError.valueNotFound(let type, let context) {
                      self.view.taskDidError(txt: "could not find type \(type) in JSON: \(context.debugDescription)")
                  } catch DecodingError.typeMismatch(let type, let context) {
                      self.view.taskDidError(txt: "type mismatch for type \(type) in JSON: \(context.debugDescription)")
                  } catch DecodingError.dataCorrupted(let context) {
                      self.view.taskDidError(txt: "data found to be corrupted in JSON: \(context.debugDescription)")
                  } catch let error as NSError {
                      self.view.taskDidError(txt: "Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                  }
            }
        })
        task.resume()
    }
}


protocol MovieDelegates: BaseDelegate {
    func loadMovieList(movies: [MovieList])
}
