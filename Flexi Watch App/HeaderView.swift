//
//  HeaderView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Good Morning")
                    .font(.headline)
                Text("Your Wellness Companion")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Spacer()
            Image(systemName: "figure.stand")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue.opacity(0.2))
        )
        .rotation3DEffect(
            .degrees(5),
            axis: (x: 10.0, y: -10.0, z: 0.0)
        )
    }
}
