import SwiftUI

public enum Theme {
    public enum Colors {
        public static let primary = Color.blue
        public static let secondary = Color.gray
        #if os(iOS)
        public static let background = Color(uiColor: .systemBackground)
        #elseif os(macOS)
        public static let background = Color(nsColor: .windowBackgroundColor)
        #else
        public static let background = Color.white
        #endif
        public static let error = Color.red
    }
    
    public enum Spacing {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
    }
    
    public enum Typography {
        public static let title = Font.title.bold()
        public static let body = Font.body
        public static let caption = Font.caption
    }
}
