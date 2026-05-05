import SwiftUI

struct AtlasHeader: View {
    @Environment(\.atlasTheme) private var theme
    let title: String
    var trailing: AnyView?

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .stroke(AtlasColor.gold.opacity(0.6))
                Image(systemName: "safari.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AtlasColor.gold)
            }
            .frame(width: 30, height: 30)

            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(AtlasColor.text(theme))

            Spacer()

            trailing
        }
    }
}

struct GlassCard<Content: View>: View {
    @Environment(\.atlasTheme) private var theme
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(14)
            .background(AtlasColor.card(theme), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(AtlasColor.cardStroke(theme))
            )
    }
}

struct GradientThumb: View {
    let colors: [Color]

    var body: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}

struct ChipLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(AtlasColor.gold)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(AtlasColor.gold.opacity(0.12), in: Capsule())
    }
}

struct GlobeCanvas: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) * 0.43
            let rect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)

            context.addFilter(.blur(radius: 30))
            context.fill(Path(ellipseIn: rect.insetBy(dx: -8, dy: -8)), with: .color(.blue.opacity(0.22)))
            context.addFilter(.blur(radius: 0))

            context.fill(Path(ellipseIn: rect), with: .radialGradient(
                Gradient(colors: [Color(red: 0.23, green: 0.57, blue: 0.68), Color(red: 0.09, green: 0.22, blue: 0.35), AtlasColor.night]),
                center: center,
                startRadius: 0,
                endRadius: radius
            ))

            context.fill(Path(ellipseIn: CGRect(x: center.x - radius * 0.62, y: center.y - radius * 0.38, width: radius * 0.46, height: radius * 0.84)), with: .color(AtlasColor.green.opacity(0.72)))
            context.fill(Path(ellipseIn: CGRect(x: center.x + radius * 0.02, y: center.y - radius * 0.54, width: radius * 0.9, height: radius * 0.45)), with: .color(AtlasColor.green.opacity(0.72)))
            context.fill(Path(ellipseIn: CGRect(x: center.x + radius * 0.03, y: center.y + radius * 0.06, width: radius * 0.44, height: radius * 0.68)), with: .color(Color(red: 0.62, green: 0.59, blue: 0.35).opacity(0.72)))

            drawArc(context: context, from: CGPoint(x: center.x - radius * 0.58, y: center.y + radius * 0.52), to: CGPoint(x: center.x + radius * 0.55, y: center.y - radius * 0.24), color: AtlasColor.gold)
            drawArc(context: context, from: CGPoint(x: center.x + radius * 0.05, y: center.y - radius * 0.10), to: CGPoint(x: center.x + radius * 0.90, y: center.y + radius * 0.12), color: AtlasColor.gold)
            drawArc(context: context, from: CGPoint(x: center.x - radius * 0.15, y: center.y + radius * 0.08), to: CGPoint(x: center.x + radius * 0.46, y: center.y + radius * 0.64), color: .blue)

            for point in [
                CGPoint(x: center.x + radius * 0.48, y: center.y - radius * 0.22),
                CGPoint(x: center.x + radius * 0.10, y: center.y - radius * 0.04),
                CGPoint(x: center.x - radius * 0.55, y: center.y + radius * 0.50),
                CGPoint(x: center.x + radius * 0.72, y: center.y + radius * 0.20)
            ] {
                context.fill(Path(ellipseIn: CGRect(x: point.x - 12, y: point.y - 12, width: 24, height: 24)), with: .color(AtlasColor.gold.opacity(0.12)))
                context.fill(Path(ellipseIn: CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8)), with: .color(AtlasColor.gold))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func drawArc(context: GraphicsContext, from: CGPoint, to: CGPoint, color: Color) {
        var path = Path()
        path.move(to: from)
        path.addQuadCurve(
            to: to,
            control: CGPoint(x: (from.x + to.x) / 2, y: min(from.y, to.y) - 70)
        )
        context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 2, lineCap: .round))
    }
}

struct RouteMapCanvas: View {
    var body: some View {
        Canvas { context, size in
            let gridColor = Color.white.opacity(0.035)
            var x: CGFloat = 0
            while x < size.width {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(gridColor), lineWidth: 1)
                x += 52
            }
            var y: CGFloat = 0
            while y < size.height {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(gridColor), lineWidth: 1)
                y += 52
            }

            let segments: [(CGPoint, CGPoint, Color)] = [
                (CGPoint(x: size.width * 0.12, y: size.height * 0.20), CGPoint(x: size.width * 0.48, y: size.height * 0.44), .blue),
                (CGPoint(x: size.width * 0.48, y: size.height * 0.44), CGPoint(x: size.width * 0.76, y: size.height * 0.34), AtlasColor.gold),
                (CGPoint(x: size.width * 0.76, y: size.height * 0.34), CGPoint(x: size.width * 0.68, y: size.height * 0.72), AtlasColor.aqua),
                (CGPoint(x: size.width * 0.68, y: size.height * 0.72), CGPoint(x: size.width * 0.86, y: size.height * 0.58), AtlasColor.coral)
            ]

            for segment in segments {
                var path = Path()
                path.move(to: segment.0)
                path.addQuadCurve(
                    to: segment.1,
                    control: CGPoint(x: (segment.0.x + segment.1.x) / 2, y: min(segment.0.y, segment.1.y) - 36)
                )
                context.stroke(path, with: .color(segment.2), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                context.fill(Path(ellipseIn: CGRect(x: segment.0.x - 5, y: segment.0.y - 5, width: 10, height: 10)), with: .color(AtlasColor.ink))
                context.fill(Path(ellipseIn: CGRect(x: segment.1.x - 5, y: segment.1.y - 5, width: 10, height: 10)), with: .color(AtlasColor.ink))
            }
        }
        .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.12))
        )
    }
}

