import Cocoa

struct QuickTerminalSize {
    enum Size: Equatable {
        case percentage(Float)
        case pixels(UInt32)
        case unspecified

        func toPixels(for totalSize: CGFloat) -> CGFloat {
            switch self {
            case .percentage(let percent):
                return totalSize * CGFloat(percent)
            case .pixels(let px):
                return CGFloat(px)
            case .unspecified:
                return 0
            }
        }
    }

    let primary: Size
    let secondary: Size

    init(primary: Size = .unspecified, secondary: Size = .unspecified) {
        self.primary = primary
        self.secondary = secondary
    }

    static var `default`: QuickTerminalSize {
        return QuickTerminalSize()
    }

    func calculateSize(for position: QuickTerminalPosition, on screen: NSScreen) -> NSSize {
        switch position {
        case .top, .bottom:
            let width = screen.frame.width
            let height: CGFloat

            if case .unspecified = primary {
                height = screen.frame.height / 4
            } else {
                height = primary.toPixels(for: screen.frame.height)
            }

            return NSSize(width: width, height: height)

        case .left, .right:
            let width: CGFloat
            let height = screen.visibleFrame.height

            if case .unspecified = primary {
                width = screen.frame.width / 4
            } else {
                width = primary.toPixels(for: screen.frame.width)
            }

            return NSSize(width: width, height: height)

        case .center:
            let width: CGFloat
            let height: CGFloat

            if case .unspecified = primary {
                width = screen.frame.width / 2
            } else {
                width = primary.toPixels(for: screen.frame.width)
            }

            if case .unspecified = secondary {
                height = screen.frame.height / 3
            } else {
                height = secondary.toPixels(for: screen.frame.height)
            }

            return NSSize(width: width, height: height)
        }
    }
}
