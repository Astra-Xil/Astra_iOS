import SwiftUI


struct DynamicHeightTextview: UIViewRepresentable {
    
    //入力値を反映するプロパティ
    @Binding var text: String
    
    //入力値を考慮したTextViewの高さを保持するプロパティ
    @Binding var height: CGFloat
    
    let textView = UITextView()
    
    //実装必須
    func makeUIView(context: Context) -> UITextView {
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 13)
        textView.delegate = context.coordinator
        textView.textContainerInset = UIEdgeInsets(
                top: 8,
                left: 6,
                bottom: 8,
                right: 6
            )
        return textView
    }
    
    //実装必須
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    //Delegateメソッドを定義したクラスを返す
    func makeCoordinator() -> Coordinator {
        return Coordinator(dynamicHeightTextView: self)
    }
    
    //UITextViewのDelegateメソッドを実装する
    class Coordinator: NSObject, UITextViewDelegate {
        
        let dynamicHeightTextView: DynamicHeightTextview
        let textView: UITextView
        
        init(dynamicHeightTextView: DynamicHeightTextview) {
            self.dynamicHeightTextView = dynamicHeightTextView
            self.textView = dynamicHeightTextView.textView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            dynamicHeightTextView.text = textView.text
            let textViewSize = textView.sizeThatFits(textView.bounds.size)
            dynamicHeightTextView.height = textViewSize.height
        }
    }
}

