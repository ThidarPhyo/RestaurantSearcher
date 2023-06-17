//
//  ProfileView.swift
//  RestaurantSearcher
//
//  Created by cmStudent on 2023/06/13.
//

import SwiftUI


struct ProfileView: View {
    let defaultProfile = Profile(image: "meal")

    var body: some View {
        VStack {
            Image(defaultProfile.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
    
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


