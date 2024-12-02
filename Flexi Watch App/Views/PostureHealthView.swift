//
//  PostureHealthView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUI

struct PostureHealthView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "bolt.heart.fill")
                .foregroundColor(.red)
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Health Insight")
                    .font(.system(size: 10, weight: .semibold))
                
                Text("Great progress today!")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
        .frame(maxWidth: .infinity)
    }
}

struct PostureHealthView_Previews: PreviewProvider {
    static var previews: some View {
        PostureHealthView()
            .previewLayout(.sizeThatFits)
    }
}
