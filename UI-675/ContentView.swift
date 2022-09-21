//
//  ContentView.swift
//  UI-675
//
//  Created by nyannyan0328 on 2022/09/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       MorphyView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
