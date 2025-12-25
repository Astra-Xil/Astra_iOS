//
//  DynamicHeightTextEditor.swift
//  astra
//
//  Created by Xil on 2025/12/25.
//
import SwiftUI

struct DynamicHeightTextEditor: View {
    
    @Binding var text: String
    @State var textHeight: CGFloat = 0
    
    var placeholder: String
    var minHeight: CGFloat
    var maxHeight: CGFloat
    
    //TextEditorの高さを保持するプロパティ
    var textEditorHeight: CGFloat {
        if textHeight < minHeight {
            return minHeight
        }
        
        if textHeight > maxHeight {
            return maxHeight
        }
        
        return textHeight
    }
    
    var body: some View {
        ZStack {
            //TextEditorの背景色
            Color("BrandSecondaryColor")
            
            //Placeholder
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color("SecondaryColor"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .font(.footnote)
            }
            
            DynamicHeightTextview(text: $text, height: $textHeight)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .frame(height: textEditorHeight) //← ここで高さを反映
    }
}

#Preview {
    @Previewable @State var text = ""

    DynamicHeightTextEditor(
        text: $text,
        textHeight: 120,
        placeholder: "今日はいい天気",
        minHeight: 120,
        maxHeight: 240
    )
}

