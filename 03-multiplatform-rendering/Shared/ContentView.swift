//
//  ContentView.swift
//  Shared
//
//  Created by Georgi Nikoloff on 03.10.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MetalView()
                .border(.black, width: 2)
            Text("Hello Metal!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
