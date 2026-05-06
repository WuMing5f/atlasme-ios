import SwiftUI

struct AtlasHeader: View {
    @Environment(\.atlasTheme) private var theme
    let title: String
    var trailing: AnyView?

    var body: some View {
        HStack {
            ZStack {
                Image(systemName: "sparkle")
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(AtlasColor.paleGold)
                Image(systemName: "location.north.line.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AtlasColor.gold)
            }
            .frame(width: 28, height: 28)

            Text(title)
                .font(.atlasDisplay(18, weight: .semibold))
                .foregroundStyle(AtlasColor.text(theme))

            Spacer()

            trailing
        }
    }
}

struct AtlasTexture: View {
    @Environment(\.atlasTheme) private var theme

    var body: some View {
        Canvas { context, size in
            guard theme == .dark else { return }

            for index in 0..<54 {
                let x = CGFloat((index * 47) % 331) / 331 * size.width
                let y = CGFloat((index * 83) % 719) / 719 * size.height
                let radius = CGFloat(index % 3 + 1) * 0.55
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: radius * 2, height: radius * 2)),
                    with: .color(AtlasColor.paleGold.opacity(index % 5 == 0 ? 0.18 : 0.08))
                )
            }

            for index in 0..<8 {
                let y = size.height * (0.12 + CGFloat(index) * 0.11)
                var route = Path()
                route.move(to: CGPoint(x: -40, y: y))
                route.addQuadCurve(
                    to: CGPoint(x: size.width + 40, y: y + CGFloat(index % 2 == 0 ? 26 : -22)),
                    control: CGPoint(x: size.width * 0.50, y: y + CGFloat(index % 2 == 0 ? -46 : 42))
                )
                context.stroke(route, with: .color(AtlasColor.aqua.opacity(0.025)), lineWidth: 1)
            }
        }
        .allowsHitTesting(false)
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
            .background(
                LinearGradient(
                    colors: [
                        AtlasColor.card(theme).opacity(theme == .dark ? 1.0 : 0.88),
                        AtlasColor.card(theme).opacity(theme == .dark ? 0.62 : 0.62)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .background(
                LinearGradient(
                    colors: [
                        Color.white.opacity(theme == .dark ? 0.035 : 0.36),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AtlasColor.cardStroke(theme))
            )
            .shadow(color: theme == .dark ? Color.black.opacity(0.22) : Color.black.opacity(0.06), radius: 18, y: 10)
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

struct ScenicThumb: View {
    let colors: [Color]
    var label: String? = nil

    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            var background = Path()
            background.addRect(rect)
            context.fill(background, with: .linearGradient(
                Gradient(colors: colors + [AtlasColor.night.opacity(0.65)]),
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: size.width, y: size.height)
            ))

            context.fill(Path(rect), with: .radialGradient(
                Gradient(colors: [Color.white.opacity(0.16), Color.clear]),
                center: CGPoint(x: size.width * 0.76, y: size.height * 0.20),
                startRadius: 0,
                endRadius: size.width * 0.72
            ))

            let sky = CGRect(x: 0, y: 0, width: size.width, height: size.height * 0.48)
            context.fill(Path(ellipseIn: sky.insetBy(dx: -size.width * 0.2, dy: -sky.height * 0.35)), with: .color(Color.white.opacity(0.10)))

            var far = Path()
            far.move(to: CGPoint(x: 0, y: size.height * 0.58))
            far.addLine(to: CGPoint(x: size.width * 0.22, y: size.height * 0.31))
            far.addLine(to: CGPoint(x: size.width * 0.42, y: size.height * 0.56))
            far.addLine(to: CGPoint(x: size.width * 0.62, y: size.height * 0.27))
            far.addLine(to: CGPoint(x: size.width, y: size.height * 0.62))
            far.addLine(to: CGPoint(x: size.width, y: size.height))
            far.addLine(to: CGPoint(x: 0, y: size.height))
            far.closeSubpath()
            context.fill(far, with: .color(Color.black.opacity(0.22)))

            for index in 0..<5 {
                let y = size.height * (0.72 + CGFloat(index) * 0.055)
                var terrace = Path()
                terrace.move(to: CGPoint(x: size.width * 0.08, y: y))
                terrace.addQuadCurve(
                    to: CGPoint(x: size.width * 0.92, y: y - 8),
                    control: CGPoint(x: size.width * 0.52, y: y + 16)
                )
                context.stroke(terrace, with: .color(AtlasColor.paleGold.opacity(0.28)), lineWidth: 1.4)
            }

            let sun = CGPoint(x: size.width * 0.78, y: size.height * 0.22)
            context.fill(Path(ellipseIn: CGRect(x: sun.x - 10, y: sun.y - 10, width: 20, height: 20)), with: .color(AtlasColor.paleGold.opacity(0.75)))

            var river = Path()
            river.move(to: CGPoint(x: size.width * 0.22, y: size.height))
            river.addCurve(
                to: CGPoint(x: size.width * 0.58, y: size.height * 0.58),
                control1: CGPoint(x: size.width * 0.28, y: size.height * 0.82),
                control2: CGPoint(x: size.width * 0.50, y: size.height * 0.76)
            )
            river.addCurve(
                to: CGPoint(x: size.width * 0.82, y: size.height * 0.36),
                control1: CGPoint(x: size.width * 0.62, y: size.height * 0.48),
                control2: CGPoint(x: size.width * 0.73, y: size.height * 0.46)
            )
            context.stroke(river, with: .color(AtlasColor.aqua.opacity(0.28)), style: StrokeStyle(lineWidth: 6, lineCap: .round))

            for index in 0..<18 {
                let x = size.width * (0.12 + CGFloat((index * 17) % 70) / 100)
                let y = size.height * (0.50 + CGFloat((index * 23) % 40) / 100)
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: 2.5, height: 2.5)),
                    with: .color(AtlasColor.paleGold.opacity(0.28))
                )
            }
        }
        .overlay(
            LinearGradient(
                colors: [Color.black.opacity(0.0), Color.black.opacity(0.35)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(alignment: .topLeading) {
            if let label {
                Text(label.uppercased())
                    .font(.atlasText(9, weight: .black))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(AtlasColor.coral.opacity(0.85), in: Capsule())
                    .padding(9)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.12))
        )
    }
}

struct GlobeShowcase: View {
    @Environment(\.atlasTheme) private var theme
    let style: AtlasGlobeStyle
    @State private var autoRotationAnchor = Date()
    @State private var anchorLongitude: Double = -18
    @GestureState private var dragTranslation: CGSize = .zero

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: false)) { timeline in
            let elapsed = timeline.date.timeIntervalSince(autoRotationAnchor)
            let autoRotation = elapsed * 1.45
            let displayedLongitude = anchorLongitude + autoRotation + Double(dragTranslation.width) * 0.22

            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(
                        RadialGradient(
                            colors: [
                                AtlasColor.aqua.opacity(theme == .dark ? 0.18 : 0.11),
                                AtlasColor.deepTeal.opacity(theme == .dark ? 0.34 : 0.16),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 190
                        )
                    )

                GlobeCanvas(style: style, longitudeOffset: displayedLongitude)
                    .frame(width: 292, height: 292)
                    .shadow(color: AtlasColor.aqua.opacity(theme == .dark ? 0.22 : 0.08), radius: 30, y: 10)
                    .contentShape(Circle())
                    .gesture(
                        DragGesture(minimumDistance: 4)
                            .updating($dragTranslation) { value, state, _ in
                                state = value.translation
                            }
                            .onEnded { value in
                                let rotationAtRelease = anchorLongitude + timeline.date.timeIntervalSince(autoRotationAnchor) * 1.45
                                let momentum = value.translation.width + (value.predictedEndTranslation.width - value.translation.width) * 0.35
                                anchorLongitude = rotationAtRelease + Double(momentum) * 0.22
                                autoRotationAnchor = timeline.date
                            }
                    )

                VStack {
                    HStack(spacing: 10) {
                        Image(systemName: "globe.europe.africa.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(AtlasColor.gold)
                        VStack(alignment: .leading, spacing: 1) {
                            HStack(spacing: 6) {
                                Text(style.title)
                                    .font(.atlasText(9.5, weight: .black))
                                    .foregroundStyle(AtlasColor.text(theme))
                                Text(style.capsule.uppercased())
                                    .font(.atlasText(7.5, weight: .black))
                                    .foregroundStyle(AtlasColor.gold)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2.5)
                                    .background(AtlasColor.gold.opacity(0.12), in: Capsule())
                            }
                            Text(style.story)
                                .font(.atlasText(8, weight: .semibold))
                                .foregroundStyle(AtlasColor.subtext(theme))
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(AtlasColor.card(theme).opacity(theme == .dark ? 0.94 : 0.90), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(AtlasColor.cardStroke(theme)))
                    .padding(.horizontal, 28)
                    .padding(.top, 10)

                    Spacer()

                    HStack(spacing: 8) {
                        miniLegend("Flights", color: AtlasColor.gold)
                        miniLegend("Train", color: AtlasColor.aqua)
                        miniLegend("Walk", color: AtlasColor.green)
                    }
                    .padding(.bottom, 8)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 316)
        }
    }

    private func miniLegend(_ title: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text(title)
                .font(.atlasText(9, weight: .black))
                .foregroundStyle(AtlasColor.subtext(theme))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(AtlasColor.card(theme), in: Capsule())
        .overlay(Capsule().stroke(AtlasColor.cardStroke(theme)))
    }
}

struct ChipLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.atlasText(10, weight: .bold))
            .foregroundStyle(AtlasColor.gold)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(AtlasColor.gold.opacity(0.12), in: Capsule())
    }
}

struct TransportIcon: View {
    let name: String
    let color: Color

    var body: some View {
        Image(systemName: name)
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(color)
            .frame(width: 22, height: 22)
            .background(color.opacity(0.12), in: Circle())
    }
}

struct GlobeModePreview: View {
    let style: AtlasGlobeStyle

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: globePalette(for: style).oceanColors.map { $0.opacity(0.92) },
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            GlobeCanvas(style: style, longitudeOffset: -28)
                .scaleEffect(0.34)
                .offset(y: 1)

            VStack {
                HStack {
                    Text(style.capsule.uppercased())
                        .font(.atlasText(7.5, weight: .black))
                        .foregroundStyle(.white.opacity(0.92))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.black.opacity(0.18), in: Capsule())
                    Spacer()
                }
                Spacer()
            }
            .padding(8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.12))
        )
    }
}

struct GlobeCanvas: View {
    @Environment(\.atlasTheme) private var theme
    let style: AtlasGlobeStyle
    let longitudeOffset: Double
    private var scene: AtlasGlobeScene { AtlasGlobeScene(style: style) }

    var body: some View {
        Canvas { context, size in
            let projection = GlobeProjection(size: size, longitudeOffset: longitudeOffset)
            let palette = globePalette(for: style)
            let sphereRect = CGRect(
                x: projection.center.x - projection.radius,
                y: projection.center.y - projection.radius,
                width: projection.radius * 2,
                height: projection.radius * 2
            )
            let sphere = Path(ellipseIn: sphereRect)
            var clippedContext = context
            clippedContext.clip(to: sphere)

            context.fill(Path(ellipseIn: sphereRect.insetBy(dx: -16, dy: -16)), with: .radialGradient(
                Gradient(colors: [palette.atmosphere.opacity(theme == .dark ? 0.22 : 0.14), Color.clear]),
                center: projection.center,
                startRadius: projection.radius * 0.55,
                endRadius: projection.radius * 1.32
            ))

            drawBackdrop(in: context, projection: projection, sphereRect: sphereRect)

            context.fill(sphere, with: .radialGradient(
                Gradient(colors: palette.oceanColors),
                center: CGPoint(x: projection.center.x - projection.radius * 0.34, y: projection.center.y - projection.radius * 0.34),
                startRadius: 0,
                endRadius: projection.radius * 1.16
            ))

            drawSurfaceTexture(in: clippedContext, projection: projection, sphereRect: sphereRect)

            context.fill(sphere, with: .radialGradient(
                Gradient(colors: [Color.white.opacity(0.11), Color.clear]),
                center: CGPoint(x: projection.center.x - projection.radius * 0.30, y: projection.center.y - projection.radius * 0.42),
                startRadius: 0,
                endRadius: projection.radius * 0.92
            ))

            for index in 0..<(style == .nightAtlas ? 140 : 90) {
                let angle = CGFloat(index) * .pi * 2 / 120
                let distance = projection.radius * (0.12 + CGFloat(index % 9) * 0.085)
                let point = CGPoint(
                    x: projection.center.x + cos(angle) * distance,
                    y: projection.center.y + sin(angle) * distance * 0.68
                )
                context.fill(
                    Path(ellipseIn: CGRect(x: point.x - 0.8, y: point.y - 0.8, width: 1.6, height: 1.6)),
                    with: .color(palette.sparkColor.opacity(index.isMultiple(of: 5) ? palette.sparkOpacity * 1.8 : palette.sparkOpacity))
                )
            }

            if palette.showsGrid {
                for latitude in stride(from: -60.0, through: 60.0, by: 20.0) {
                    drawLatitudeLine(context: context, projection: projection, latitude: latitude, opacity: palette.gridOpacity)
                }

                for longitude in stride(from: -150.0, through: 150.0, by: 30.0) {
                    drawLongitudeLine(context: context, projection: projection, longitude: longitude, opacity: palette.gridOpacity * 0.75)
                }
            }

            if palette.cloudOpacity > 0 {
                drawCloudBand(context: context, projection: projection, latitude: 22, amplitude: 8, opacity: palette.cloudOpacity, lineWidth: 6)
                drawCloudBand(context: context, projection: projection, latitude: 48, amplitude: 5, opacity: palette.cloudOpacity * 0.75, lineWidth: 5)
                drawCloudBand(context: context, projection: projection, latitude: -8, amplitude: 7, opacity: palette.cloudOpacity * 0.66, lineWidth: 4.5)
            }

            for polygon in scene.landPolygons {
                drawPolygon(polygon, in: context, projection: projection)
            }

            for blob in scene.landBlobs {
                drawBlob(blob, in: context, projection: projection)
            }

            for light in scene.cityLights {
                drawLight(light, in: context, projection: projection)
            }

            for route in scene.routes {
                drawRoute(route, in: context, projection: projection)
            }

            for city in scene.cities {
                drawCity(city, in: context, projection: projection)
            }

            drawForegroundAccent(in: clippedContext, projection: projection, sphereRect: sphereRect)

            context.fill(sphere, with: .linearGradient(
                Gradient(colors: [Color.clear, Color.black.opacity(0.30)]),
                startPoint: CGPoint(x: projection.center.x - projection.radius * 0.55, y: projection.center.y - projection.radius * 0.30),
                endPoint: CGPoint(x: projection.center.x + projection.radius * 0.85, y: projection.center.y + projection.radius * 0.82)
            ))

            context.stroke(Path(ellipseIn: sphereRect.insetBy(dx: 1.5, dy: 1.5)), with: .color(Color.white.opacity(0.16)), lineWidth: 1.15)
            context.stroke(Path(ellipseIn: sphereRect.insetBy(dx: 7, dy: 7)), with: .color(palette.atmosphere.opacity(0.10)), lineWidth: 0.8)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func drawBackdrop(in context: GraphicsContext, projection: GlobeProjection, sphereRect: CGRect) {
        switch style {
        case .nightAtlas:
            for index in 0..<22 {
                let x = sphereRect.minX - 18 + CGFloat((index * 37) % 280)
                let y = sphereRect.minY - 6 + CGFloat((index * 53) % 236)
                let size = CGFloat(index.isMultiple(of: 4) ? 2.2 : 1.2)
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: size, height: size)),
                    with: .color(Color.white.opacity(index.isMultiple(of: 5) ? 0.45 : 0.18))
                )
            }

            var aurora = Path()
            aurora.move(to: CGPoint(x: sphereRect.minX - 8, y: projection.center.y - projection.radius * 0.12))
            aurora.addCurve(
                to: CGPoint(x: sphereRect.maxX + 8, y: projection.center.y - projection.radius * 0.02),
                control1: CGPoint(x: projection.center.x - projection.radius * 0.58, y: projection.center.y - projection.radius * 0.36),
                control2: CGPoint(x: projection.center.x + projection.radius * 0.36, y: projection.center.y - projection.radius * 0.22)
            )
            context.stroke(aurora, with: .color(AtlasColor.aqua.opacity(0.12)), style: StrokeStyle(lineWidth: 18, lineCap: .round))

        case .animeJourney:
            context.fill(
                Path(ellipseIn: sphereRect.insetBy(dx: -26, dy: -26)),
                with: .radialGradient(
                    Gradient(colors: [Color(red: 0.98, green: 0.82, blue: 0.86).opacity(0.24), Color.clear]),
                    center: CGPoint(x: projection.center.x + projection.radius * 0.12, y: projection.center.y - projection.radius * 0.18),
                    startRadius: 0,
                    endRadius: projection.radius * 1.32
                )
            )

        case .vintageExplorer:
            context.stroke(
                Path(ellipseIn: sphereRect.insetBy(dx: -10, dy: -10)),
                with: .color(Color(red: 0.60, green: 0.43, blue: 0.21).opacity(0.22)),
                style: StrokeStyle(lineWidth: 1.2, dash: [3, 6])
            )

        default:
            break
        }
    }

    private func drawSurfaceTexture(in context: GraphicsContext, projection: GlobeProjection, sphereRect: CGRect) {
        switch style {
        case .realGeography:
            for latitude in stride(from: -52.0, through: 58.0, by: 14.0) {
                let samples = stride(from: -180.0, through: 180.0, by: 8.0).compactMap { longitude -> ProjectedPoint? in
                    let latitudeWave = latitude + sin((longitude + longitudeOffset) * .pi / 28) * 2.2
                    return projection.project(latitude: latitudeWave, longitude: longitude)
                }
                strokeRibbon(samples, in: context, color: Color.white.opacity(0.05), lineWidth: latitude > 0 ? 8 : 6)
            }

        case .vintageExplorer:
            for index in 0..<34 {
                let arcRect = sphereRect.insetBy(dx: CGFloat(12 + index * 2), dy: CGFloat(12 + index))
                context.stroke(
                    Path(ellipseIn: arcRect),
                    with: .color(Color(red: 0.24, green: 0.15, blue: 0.08).opacity(index.isMultiple(of: 3) ? 0.06 : 0.03)),
                    lineWidth: 0.8
                )
            }

            for longitude in stride(from: -150.0, through: 150.0, by: 30.0) {
                drawLongitudeLine(context: context, projection: projection, longitude: longitude, opacity: 0.032)
            }

        case .terrainExpedition:
            for latitude in stride(from: -44.0, through: 52.0, by: 10.0) {
                let samples = stride(from: -180.0, through: 180.0, by: 7.0).compactMap { longitude -> ProjectedPoint? in
                    let latitudeWave = latitude + sin((longitude + longitudeOffset) * .pi / 34) * 3.4
                    return projection.project(latitude: latitudeWave, longitude: longitude)
                }
                strokeRibbon(samples, in: context, color: Color(red: 0.92, green: 0.82, blue: 0.56).opacity(0.06), lineWidth: 2.1)
            }

        case .animeJourney:
            for index in 0..<18 {
                let sparkle = CGPoint(
                    x: sphereRect.minX + CGFloat((index * 23) % 220),
                    y: sphereRect.minY + CGFloat((index * 41) % 220)
                )
                let size: CGFloat = index.isMultiple(of: 4) ? 5.0 : 3.0
                var star = Path()
                star.move(to: CGPoint(x: sparkle.x, y: sparkle.y - size))
                star.addLine(to: CGPoint(x: sparkle.x, y: sparkle.y + size))
                star.move(to: CGPoint(x: sparkle.x - size, y: sparkle.y))
                star.addLine(to: CGPoint(x: sparkle.x + size, y: sparkle.y))
                context.stroke(star, with: .color(Color.white.opacity(0.14)), lineWidth: 0.85)
            }

        case .nightAtlas:
            context.fill(
                Path(ellipseIn: CGRect(
                    x: sphereRect.minX - 16,
                    y: sphereRect.minY + projection.radius * 0.08,
                    width: projection.radius * 1.42,
                    height: projection.radius * 1.06
                )),
                with: .radialGradient(
                    Gradient(colors: [Color.white.opacity(0.12), Color.clear]),
                    center: CGPoint(x: projection.center.x - projection.radius * 0.38, y: projection.center.y + projection.radius * 0.02),
                    startRadius: 0,
                    endRadius: projection.radius * 0.78
                )
            )

            for latitude in stride(from: -24.0, through: 52.0, by: 19.0) {
                let samples = stride(from: -180.0, through: 180.0, by: 8.0).compactMap { longitude -> ProjectedPoint? in
                    let latitudeWave = latitude + sin((longitude + longitudeOffset) * .pi / 25) * 2.8
                    return projection.project(latitude: latitudeWave, longitude: longitude)
                }
                strokeRibbon(samples, in: context, color: AtlasColor.aqua.opacity(0.022), lineWidth: 3.0)
            }

            for latitude in stride(from: -8.0, through: 44.0, by: 17.0) {
                let samples = stride(from: -180.0, through: 180.0, by: 7.0).compactMap { longitude -> ProjectedPoint? in
                    let latitudeWave = latitude + cos((longitude + longitudeOffset) * .pi / 22) * 1.6
                    return projection.project(latitude: latitudeWave, longitude: longitude)
                }
                strokeRibbon(samples, in: context, color: AtlasColor.paleGold.opacity(0.018), lineWidth: 1.4)
            }
        }
    }

    private func drawForegroundAccent(in context: GraphicsContext, projection: GlobeProjection, sphereRect: CGRect) {
        switch style {
        case .nightAtlas:
            context.fill(
                Path(ellipseIn: CGRect(
                    x: projection.center.x - projection.radius * 0.84,
                    y: projection.center.y - projection.radius * 0.80,
                    width: projection.radius * 1.05,
                    height: projection.radius * 0.56
                )),
                with: .radialGradient(
                    Gradient(colors: [Color.white.opacity(0.08), Color.clear]),
                    center: CGPoint(x: projection.center.x - projection.radius * 0.30, y: projection.center.y - projection.radius * 0.42),
                    startRadius: 0,
                    endRadius: projection.radius * 0.58
                )
            )

            var rim = Path()
            rim.move(to: CGPoint(x: sphereRect.minX + 12, y: projection.center.y + projection.radius * 0.34))
            rim.addCurve(
                to: CGPoint(x: projection.center.x + projection.radius * 0.14, y: sphereRect.minY + 18),
                control1: CGPoint(x: sphereRect.minX + 2, y: projection.center.y - projection.radius * 0.18),
                control2: CGPoint(x: projection.center.x - projection.radius * 0.52, y: sphereRect.minY + 10)
            )
            context.stroke(rim, with: .color(Color.white.opacity(0.11)), style: StrokeStyle(lineWidth: 2.4, lineCap: .round))

        case .realGeography:
            context.stroke(
                Path(ellipseIn: sphereRect.insetBy(dx: 18, dy: 18)),
                with: .color(Color.white.opacity(0.09)),
                lineWidth: 1.0
            )

        case .vintageExplorer:
            var diagonal = Path()
            diagonal.move(to: CGPoint(x: sphereRect.minX + 24, y: sphereRect.maxY - 16))
            diagonal.addCurve(
                to: CGPoint(x: sphereRect.maxX - 22, y: sphereRect.minY + 22),
                control1: CGPoint(x: projection.center.x - projection.radius * 0.36, y: projection.center.y + projection.radius * 0.20),
                control2: CGPoint(x: projection.center.x + projection.radius * 0.08, y: projection.center.y - projection.radius * 0.42)
            )
            context.stroke(diagonal, with: .color(Color(red: 0.25, green: 0.13, blue: 0.06).opacity(0.10)), style: StrokeStyle(lineWidth: 1.0, dash: [2, 5]))

        case .animeJourney:
            context.fill(
                Path(ellipseIn: CGRect(
                    x: projection.center.x - projection.radius * 0.14,
                    y: projection.center.y - projection.radius * 0.58,
                    width: projection.radius * 0.98,
                    height: projection.radius * 0.50
                )),
                with: .radialGradient(
                    Gradient(colors: [Color.white.opacity(0.12), Color.clear]),
                    center: CGPoint(x: projection.center.x + projection.radius * 0.20, y: projection.center.y - projection.radius * 0.30),
                    startRadius: 0,
                    endRadius: projection.radius * 0.52
                )
            )

        case .terrainExpedition:
            for latitude in stride(from: -20.0, through: 24.0, by: 11.0) {
                let samples = stride(from: -180.0, through: 180.0, by: 8.0).compactMap { longitude -> ProjectedPoint? in
                    let latitudeWave = latitude + sin((longitude + longitudeOffset) * .pi / 18) * 1.6
                    return projection.project(latitude: latitudeWave, longitude: longitude)
                }
                strokeRibbon(samples, in: context, color: Color.black.opacity(0.06), lineWidth: 1.0)
            }
        }
    }

    private func drawLatitudeLine(context: GraphicsContext, projection: GlobeProjection, latitude: Double, opacity: Double) {
        let samples = stride(from: -180.0, through: 180.0, by: 6.0).compactMap {
            projection.project(latitude: latitude, longitude: $0)
        }
        guard let first = samples.first else { return }
        var path = Path()
        path.move(to: first.point)
        for sample in samples.dropFirst() {
            path.addLine(to: sample.point)
        }
        context.stroke(path, with: .color(Color.white.opacity(opacity)), lineWidth: 0.75)
    }

    private func drawLongitudeLine(context: GraphicsContext, projection: GlobeProjection, longitude: Double, opacity: Double) {
        let samples = stride(from: -75.0, through: 75.0, by: 4.0).compactMap {
            projection.project(latitude: $0, longitude: longitude)
        }
        guard let first = samples.first else { return }
        var path = Path()
        path.move(to: first.point)
        for sample in samples.dropFirst() {
            path.addLine(to: sample.point)
        }
        context.stroke(path, with: .color(Color.white.opacity(opacity)), lineWidth: 0.65)
    }

    private func drawCloudBand(context: GraphicsContext, projection: GlobeProjection, latitude: Double, amplitude: Double, opacity: Double, lineWidth: CGFloat) {
        let samples = stride(from: -175.0, through: 175.0, by: 5.0).compactMap { longitude -> ProjectedPoint? in
            let offsetLatitude = latitude + sin((longitude + longitudeOffset) * .pi / 45) * amplitude
            return projection.project(latitude: offsetLatitude, longitude: longitude)
        }
        guard let first = samples.first else { return }
        var path = Path()
        path.move(to: first.point)
        for sample in samples.dropFirst() {
            path.addLine(to: sample.point)
        }
        context.stroke(path, with: .color(Color.white.opacity(opacity)), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }

    private func drawBlob(_ blob: GlobeBlob, in context: GraphicsContext, projection: GlobeProjection) {
        guard let projected = projection.project(latitude: blob.latitude, longitude: blob.longitude), projected.depth > -0.22 else {
            return
        }

        let width = blob.size * projected.scale * (0.82 + max(projected.depth, -0.1) * 0.14)
        let height = width * blob.aspect
        let rect = CGRect(
            x: projected.point.x - width / 2,
            y: projected.point.y - height / 2,
            width: width,
            height: height
        )
        context.fill(
            Path(ellipseIn: rect),
            with: .color(blob.color.opacity(blob.opacity * scene.palette.landOpacityMultiplier * (0.46 + max(projected.depth, 0) * 0.38)))
        )
    }

    private func drawPolygon(_ polygon: GlobePolygon, in context: GraphicsContext, projection: GlobeProjection) {
        let projectedPoints = polygon.points.compactMap {
            projection.project(latitude: $0.latitude, longitude: $0.longitude)
        }
        guard projectedPoints.count > 2 else { return }

        let visibleCount = projectedPoints.filter { $0.depth > -0.08 }.count
        guard visibleCount >= max(3, projectedPoints.count / 4) else { return }

        var path = Path()
        path.move(to: projectedPoints[0].point)
        for point in projectedPoints.dropFirst() {
            path.addLine(to: point.point)
        }
        path.closeSubpath()

        let averageDepth = projectedPoints.map(\.depth).reduce(0, +) / Double(projectedPoints.count)
        let opacity = polygon.opacity * scene.palette.landOpacityMultiplier * (0.42 + max(averageDepth, 0) * 0.36)
        context.fill(path, with: .color(polygon.color.opacity(opacity)))
        context.stroke(path, with: .color(polygon.stroke.opacity(opacity * 0.32)), lineWidth: polygon.lineWidth)
    }

    private func drawLight(_ light: GlobeLight, in context: GraphicsContext, projection: GlobeProjection) {
        guard let projected = projection.project(latitude: light.latitude, longitude: light.longitude), projected.depth > 0.02 else {
            return
        }

        let glowSize = light.size * projected.scale * 1.25
        let glowRect = CGRect(
            x: projected.point.x - glowSize / 2,
            y: projected.point.y - glowSize / 2,
            width: glowSize,
            height: glowSize
        )
        context.fill(
            Path(ellipseIn: glowRect),
            with: .radialGradient(
                Gradient(colors: [light.color.opacity(scene.palette.lightGlowOpacity), Color.clear]),
                center: projected.point,
                startRadius: 0,
                endRadius: glowSize / 2
            )
        )

        let coreSize = max(1.0, light.size * projected.scale * 0.22)
        context.fill(
            Path(ellipseIn: CGRect(
                x: projected.point.x - coreSize / 2,
                y: projected.point.y - coreSize / 2,
                width: coreSize,
                height: coreSize
            )),
            with: .color(light.color.opacity(scene.palette.lightCoreOpacity))
        )
    }

    private func drawCity(_ city: GlobeCity, in context: GraphicsContext, projection: GlobeProjection) {
        guard let projected = projection.project(latitude: city.latitude, longitude: city.longitude), projected.depth > 0.18 else {
            return
        }

        let glowSize = 20 * projected.scale
        context.fill(
            Path(ellipseIn: CGRect(
                x: projected.point.x - glowSize / 2,
                y: projected.point.y - glowSize / 2,
                width: glowSize,
                height: glowSize
            )),
            with: .radialGradient(
                Gradient(colors: [city.color.opacity(scene.palette.cityGlowOpacity), Color.clear]),
                center: projected.point,
                startRadius: 0,
                endRadius: glowSize / 2
            )
        )

        let nodeSize = max(4.6, 5.8 * projected.scale)
        let nodeRect = CGRect(
            x: projected.point.x - nodeSize / 2,
            y: projected.point.y - nodeSize / 2,
            width: nodeSize,
            height: nodeSize
        )
        context.fill(Path(ellipseIn: nodeRect), with: .color(AtlasColor.ink))
        context.stroke(Path(ellipseIn: nodeRect), with: .color(city.color.opacity(scene.palette.cityStrokeOpacity)), lineWidth: 1.5)

        if city.showsLabel {
            context.draw(
                Text(city.name)
                    .font(.atlasText(8, weight: .black))
                    .foregroundStyle(AtlasColor.ink.opacity(0.96)),
                at: CGPoint(x: projected.point.x + nodeSize + 4, y: projected.point.y - 1),
                anchor: .leading
            )
        }
    }

    private func drawRoute(_ route: GlobeRoute, in context: GraphicsContext, projection: GlobeProjection) {
        let samples = projectedRouteSamples(route: route, projection: projection)
        drawRouteSegments(samples.filter { $0.depth <= 0.05 }, in: context, color: route.color.opacity(scene.palette.backRouteOpacity), glow: route.color.opacity(scene.palette.backRouteGlowOpacity), lineWidth: scene.palette.backRouteWidth)
        drawRouteSegments(samples.filter { $0.depth > 0.05 }, in: context, color: route.color.opacity(scene.palette.frontRouteOpacity), glow: route.color.opacity(scene.palette.frontRouteGlowOpacity), lineWidth: scene.palette.frontRouteWidth)
    }

    private func projectedRouteSamples(route: GlobeRoute, projection: GlobeProjection) -> [ProjectedSample] {
        let from = GlobeVector3(latitude: route.from.latitude, longitude: route.from.longitude)
        let to = GlobeVector3(latitude: route.to.latitude, longitude: route.to.longitude)

        return stride(from: 0.0, through: 1.0, by: 1.0 / 42.0).compactMap { progress in
            let base = GlobeVector3.slerp(from: from, to: to, progress: progress)
            let lifted = base.normalized * (1.03 + sin(progress * .pi) * route.altitude)
            guard let projected = projection.project(vector: lifted) else {
                return nil
            }
            return ProjectedSample(point: projected.point, depth: projected.depth)
        }
    }

    private func drawRouteSegments(_ samples: [ProjectedSample], in context: GraphicsContext, color: Color, glow: Color, lineWidth: CGFloat) {
        guard samples.count > 1 else { return }

        var segment: [ProjectedSample] = []
        for sample in samples {
            if let last = segment.last, distance(from: last.point, to: sample.point) > 30 {
                strokeSegment(segment, in: context, color: color, glow: glow, lineWidth: lineWidth)
                segment = [sample]
            } else {
                segment.append(sample)
            }
        }
        strokeSegment(segment, in: context, color: color, glow: glow, lineWidth: lineWidth)
    }

    private func strokeSegment(_ samples: [ProjectedSample], in context: GraphicsContext, color: Color, glow: Color, lineWidth: CGFloat) {
        guard let first = samples.first, samples.count > 1 else { return }

        var path = Path()
        path.move(to: first.point)
        for sample in samples.dropFirst() {
            path.addLine(to: sample.point)
        }
        let dash: [CGFloat] = style == .vintageExplorer ? [3.5, 5.5] : []
        context.stroke(path, with: .color(glow), style: StrokeStyle(lineWidth: lineWidth + 2.6, lineCap: .round, dash: dash))
        context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, dash: dash))
    }

    private func strokeRibbon(_ samples: [ProjectedPoint], in context: GraphicsContext, color: Color, lineWidth: CGFloat) {
        guard let first = samples.first, samples.count > 1 else { return }

        var path = Path()
        path.move(to: first.point)
        for sample in samples.dropFirst() {
            path.addLine(to: sample.point)
        }
        context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }

    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        hypot(from.x - to.x, from.y - to.y)
    }
}

private struct GlobePalette {
    let oceanColors: [Color]
    let atmosphere: Color
    let sparkColor: Color
    let sparkOpacity: Double
    let cloudOpacity: Double
    let showsGrid: Bool
    let gridOpacity: Double
    let landOpacityMultiplier: Double
    let lightGlowOpacity: Double
    let lightCoreOpacity: Double
    let cityGlowOpacity: Double
    let cityStrokeOpacity: Double
    let frontRouteOpacity: Double
    let frontRouteGlowOpacity: Double
    let frontRouteWidth: CGFloat
    let backRouteOpacity: Double
    let backRouteGlowOpacity: Double
    let backRouteWidth: CGFloat
}

private func globePalette(for style: AtlasGlobeStyle) -> GlobePalette {
    switch style {
    case .nightAtlas:
        return GlobePalette(
            oceanColors: [Color(red: 0.30, green: 0.47, blue: 0.58), Color(red: 0.08, green: 0.20, blue: 0.29), Color(red: 0.01, green: 0.07, blue: 0.11), Color.black.opacity(0.99)],
            atmosphere: AtlasColor.aqua,
            sparkColor: AtlasColor.paleGold,
            sparkOpacity: 0.065,
            cloudOpacity: 0.045,
            showsGrid: true,
            gridOpacity: 0.015,
            landOpacityMultiplier: 0.92,
            lightGlowOpacity: 0.32,
            lightCoreOpacity: 0.96,
            cityGlowOpacity: 0.28,
            cityStrokeOpacity: 1.0,
            frontRouteOpacity: 0.90,
            frontRouteGlowOpacity: 0.12,
            frontRouteWidth: 1.25,
            backRouteOpacity: 0.08,
            backRouteGlowOpacity: 0.05,
            backRouteWidth: 1.65
        )
    case .realGeography:
        return GlobePalette(
            oceanColors: [Color(red: 0.77, green: 0.87, blue: 0.92), Color(red: 0.44, green: 0.67, blue: 0.78), Color(red: 0.18, green: 0.38, blue: 0.56), Color(red: 0.07, green: 0.21, blue: 0.34)],
            atmosphere: Color(red: 0.63, green: 0.82, blue: 0.95),
            sparkColor: Color.white,
            sparkOpacity: 0.03,
            cloudOpacity: 0.095,
            showsGrid: false,
            gridOpacity: 0.0,
            landOpacityMultiplier: 1.28,
            lightGlowOpacity: 0.0,
            lightCoreOpacity: 0.0,
            cityGlowOpacity: 0.12,
            cityStrokeOpacity: 0.72,
            frontRouteOpacity: 0.78,
            frontRouteGlowOpacity: 0.08,
            frontRouteWidth: 1.15,
            backRouteOpacity: 0.06,
            backRouteGlowOpacity: 0.03,
            backRouteWidth: 1.5
        )
    case .vintageExplorer:
        return GlobePalette(
            oceanColors: [Color(red: 0.77, green: 0.69, blue: 0.54), Color(red: 0.53, green: 0.44, blue: 0.30), Color(red: 0.28, green: 0.21, blue: 0.14), Color(red: 0.16, green: 0.11, blue: 0.08)],
            atmosphere: Color(red: 0.85, green: 0.71, blue: 0.46),
            sparkColor: Color(red: 0.34, green: 0.18, blue: 0.08),
            sparkOpacity: 0.04,
            cloudOpacity: 0.02,
            showsGrid: false,
            gridOpacity: 0.0,
            landOpacityMultiplier: 1.12,
            lightGlowOpacity: 0.05,
            lightCoreOpacity: 0.22,
            cityGlowOpacity: 0.10,
            cityStrokeOpacity: 0.75,
            frontRouteOpacity: 0.68,
            frontRouteGlowOpacity: 0.06,
            frontRouteWidth: 1.1,
            backRouteOpacity: 0.05,
            backRouteGlowOpacity: 0.02,
            backRouteWidth: 1.3
        )
    case .animeJourney:
        return GlobePalette(
            oceanColors: [Color(red: 0.84, green: 0.92, blue: 0.98), Color(red: 0.59, green: 0.78, blue: 0.94), Color(red: 0.31, green: 0.54, blue: 0.88), Color(red: 0.18, green: 0.29, blue: 0.52)],
            atmosphere: Color(red: 0.95, green: 0.74, blue: 0.78),
            sparkColor: Color(red: 1.0, green: 0.84, blue: 0.76),
            sparkOpacity: 0.06,
            cloudOpacity: 0.09,
            showsGrid: false,
            gridOpacity: 0.0,
            landOpacityMultiplier: 1.05,
            lightGlowOpacity: 0.16,
            lightCoreOpacity: 0.74,
            cityGlowOpacity: 0.24,
            cityStrokeOpacity: 0.9,
            frontRouteOpacity: 0.88,
            frontRouteGlowOpacity: 0.12,
            frontRouteWidth: 1.5,
            backRouteOpacity: 0.08,
            backRouteGlowOpacity: 0.04,
            backRouteWidth: 1.7
        )
    case .terrainExpedition:
        return GlobePalette(
            oceanColors: [Color(red: 0.56, green: 0.73, blue: 0.78), Color(red: 0.27, green: 0.50, blue: 0.47), Color(red: 0.16, green: 0.27, blue: 0.22), Color(red: 0.08, green: 0.13, blue: 0.11)],
            atmosphere: Color(red: 0.54, green: 0.74, blue: 0.47),
            sparkColor: AtlasColor.paleGold,
            sparkOpacity: 0.04,
            cloudOpacity: 0.045,
            showsGrid: true,
            gridOpacity: 0.014,
            landOpacityMultiplier: 1.2,
            lightGlowOpacity: 0.12,
            lightCoreOpacity: 0.42,
            cityGlowOpacity: 0.14,
            cityStrokeOpacity: 0.82,
            frontRouteOpacity: 0.74,
            frontRouteGlowOpacity: 0.08,
            frontRouteWidth: 1.25,
            backRouteOpacity: 0.05,
            backRouteGlowOpacity: 0.025,
            backRouteWidth: 1.45
        )
    }
}

private struct GlobeProjection {
    let size: CGSize
    let longitudeOffset: Double

    var center: CGPoint {
        CGPoint(x: size.width / 2, y: size.height / 2)
    }

    var radius: CGFloat {
        min(size.width, size.height) * 0.46
    }

    func project(latitude: Double, longitude: Double) -> ProjectedPoint? {
        project(vector: GlobeVector3(latitude: latitude, longitude: longitude))
    }

    func project(vector: GlobeVector3) -> ProjectedPoint? {
        let rotated = vector.rotatedY(angle: longitudeOffset * .pi / 180)
        let perspective = 0.74 + (rotated.z + 1) * 0.18
        let x = center.x + CGFloat(rotated.x) * radius * perspective
        let y = center.y - CGFloat(rotated.y) * radius * (0.88 + (rotated.z + 1) * 0.08)
        return ProjectedPoint(point: CGPoint(x: x, y: y), depth: rotated.z, scale: perspective)
    }
}

private struct ProjectedPoint {
    let point: CGPoint
    let depth: Double
    let scale: CGFloat
}

private struct ProjectedSample {
    let point: CGPoint
    let depth: Double
}

private struct GlobeVector3 {
    let x: Double
    let y: Double
    let z: Double

    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    init(latitude: Double, longitude: Double) {
        let lat = latitude * .pi / 180
        let lon = longitude * .pi / 180
        let cosLat = cos(lat)
        self.x = cosLat * sin(lon)
        self.y = sin(lat)
        self.z = cosLat * cos(lon)
    }

    var magnitude: Double {
        sqrt(x * x + y * y + z * z)
    }

    var normalized: GlobeVector3 {
        let value = magnitude
        guard value > 0 else { return self }
        return GlobeVector3(x: x / value, y: y / value, z: z / value)
    }

    func rotatedY(angle: Double) -> GlobeVector3 {
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        return GlobeVector3(
            x: x * cosAngle + z * sinAngle,
            y: y,
            z: z * cosAngle - x * sinAngle
        )
    }

    static func slerp(from: GlobeVector3, to: GlobeVector3, progress: Double) -> GlobeVector3 {
        let start = from.normalized
        let end = to.normalized
        let clampedDot = max(-1.0, min(1.0, start.x * end.x + start.y * end.y + start.z * end.z))

        if abs(clampedDot) > 0.999 {
            return GlobeVector3(
                x: start.x + (end.x - start.x) * progress,
                y: start.y + (end.y - start.y) * progress,
                z: start.z + (end.z - start.z) * progress
            ).normalized
        }

        let theta = acos(clampedDot)
        let sinTheta = sin(theta)
        let lhs = sin((1 - progress) * theta) / sinTheta
        let rhs = sin(progress * theta) / sinTheta

        return GlobeVector3(
            x: start.x * lhs + end.x * rhs,
            y: start.y * lhs + end.y * rhs,
            z: start.z * lhs + end.z * rhs
        )
    }

    static func * (lhs: GlobeVector3, rhs: Double) -> GlobeVector3 {
        GlobeVector3(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
}

private struct GlobeBlob {
    let latitude: Double
    let longitude: Double
    let size: CGFloat
    let aspect: CGFloat
    let color: Color
    let opacity: Double
}

private struct GlobeLight {
    let latitude: Double
    let longitude: Double
    let size: CGFloat
    let color: Color
}

private struct GlobePolygonPoint {
    let latitude: Double
    let longitude: Double
}

private struct GlobePolygon {
    let points: [GlobePolygonPoint]
    let color: Color
    let stroke: Color
    let opacity: Double
    let lineWidth: CGFloat
}

private struct GlobeCity {
    let name: String
    let latitude: Double
    let longitude: Double
    let color: Color
    let showsLabel: Bool
}

private struct GlobeRoute {
    let from: GlobeCity
    let to: GlobeCity
    let color: Color
    let altitude: Double
}

private struct AtlasGlobeScene {
    let palette: GlobePalette
    let landPolygons: [GlobePolygon]
    let landBlobs: [GlobeBlob]
    let cityLights: [GlobeLight]
    let cities: [GlobeCity]
    let routes: [GlobeRoute]

    init(style: AtlasGlobeStyle) {
        let palette = globePalette(for: style)
        let paris = GlobeCity(name: "Paris", latitude: 48.8566, longitude: 2.3522, color: AtlasColor.gold, showsLabel: style == .realGeography)
        let dubai = GlobeCity(name: "Dubai", latitude: 25.2048, longitude: 55.2708, color: AtlasColor.gold, showsLabel: false)
        let hoiAn = GlobeCity(name: "Hoi An", latitude: 15.8801, longitude: 108.3380, color: AtlasColor.aqua, showsLabel: style == .animeJourney)
        let cusco = GlobeCity(name: "Cusco", latitude: -13.5319, longitude: -71.9675, color: AtlasColor.gold, showsLabel: style == .terrainExpedition)
        let reykjavikLabeled = GlobeCity(name: "Reykjavik", latitude: 64.1466, longitude: -21.9426, color: AtlasColor.paleGold, showsLabel: style == .vintageExplorer)

        self.palette = palette
        self.landPolygons = AtlasGlobeScene.continentPolygons(for: style)
        self.landBlobs = AtlasGlobeScene.continentBlobs(for: style)
        self.cityLights = AtlasGlobeScene.lightBlobs(for: style)
        self.cities = [reykjavikLabeled, paris, dubai, hoiAn, cusco]
        self.routes = [
            GlobeRoute(from: cusco, to: paris, color: style == .vintageExplorer ? Color(red: 0.28, green: 0.14, blue: 0.06) : AtlasColor.gold, altitude: 0.085),
            GlobeRoute(from: paris, to: hoiAn, color: style == .animeJourney ? Color(red: 0.99, green: 0.73, blue: 0.70) : AtlasColor.gold, altitude: 0.05),
            GlobeRoute(from: dubai, to: hoiAn, color: style == .terrainExpedition ? AtlasColor.green : AtlasColor.aqua, altitude: 0.028),
            GlobeRoute(from: reykjavikLabeled, to: paris, color: style == .realGeography ? Color.white.opacity(0.82) : AtlasColor.paleGold, altitude: 0.024)
        ]
    }

    private static func continentPolygons(for style: AtlasGlobeStyle) -> [GlobePolygon] {
        let stroke: Color
        let northAmericaColor: Color
        let southAmericaColor: Color
        let afroEurasiaColor: Color
        let australiaColor: Color
        let greenlandColor: Color

        switch style {
        case .nightAtlas:
            stroke = Color(red: 0.72, green: 0.62, blue: 0.40)
            northAmericaColor = Color(red: 0.12, green: 0.19, blue: 0.11)
            southAmericaColor = Color(red: 0.14, green: 0.22, blue: 0.13)
            afroEurasiaColor = Color(red: 0.14, green: 0.20, blue: 0.11)
            australiaColor = Color(red: 0.16, green: 0.15, blue: 0.10)
            greenlandColor = Color(red: 0.38, green: 0.42, blue: 0.44)
        case .realGeography:
            stroke = Color(red: 0.35, green: 0.43, blue: 0.28)
            northAmericaColor = Color(red: 0.42, green: 0.56, blue: 0.30)
            southAmericaColor = Color(red: 0.46, green: 0.60, blue: 0.33)
            afroEurasiaColor = Color(red: 0.57, green: 0.59, blue: 0.34)
            australiaColor = Color(red: 0.67, green: 0.51, blue: 0.30)
            greenlandColor = Color.white.opacity(0.82)
        default:
            return []
        }

        return [
            GlobePolygon(
                points: [
                    .init(latitude: 72, longitude: -166), .init(latitude: 66, longitude: -150),
                    .init(latitude: 60, longitude: -139), .init(latitude: 52, longitude: -128),
                    .init(latitude: 48, longitude: -123), .init(latitude: 41, longitude: -122),
                    .init(latitude: 32, longitude: -117), .init(latitude: 24, longitude: -110),
                    .init(latitude: 18, longitude: -102), .init(latitude: 16, longitude: -94),
                    .init(latitude: 21, longitude: -86), .init(latitude: 27, longitude: -81),
                    .init(latitude: 31, longitude: -79), .init(latitude: 37, longitude: -75),
                    .init(latitude: 44, longitude: -67), .init(latitude: 52, longitude: -61),
                    .init(latitude: 58, longitude: -70), .init(latitude: 64, longitude: -83),
                    .init(latitude: 69, longitude: -98), .init(latitude: 72, longitude: -120)
                ],
                color: northAmericaColor,
                stroke: stroke,
                opacity: style == .nightAtlas ? 0.82 : 0.88,
                lineWidth: style == .nightAtlas ? 0.6 : 0.75
            ),
            GlobePolygon(
                points: [
                    .init(latitude: 12, longitude: -80), .init(latitude: 6, longitude: -77),
                    .init(latitude: -2, longitude: -76), .init(latitude: -10, longitude: -74),
                    .init(latitude: -18, longitude: -70), .init(latitude: -28, longitude: -66),
                    .init(latitude: -38, longitude: -63), .init(latitude: -50, longitude: -69),
                    .init(latitude: -54, longitude: -73), .init(latitude: -45, longitude: -75),
                    .init(latitude: -28, longitude: -61), .init(latitude: -13, longitude: -54),
                    .init(latitude: -2, longitude: -50), .init(latitude: 5, longitude: -54),
                    .init(latitude: 8, longitude: -60), .init(latitude: 10, longitude: -67)
                ],
                color: southAmericaColor,
                stroke: stroke,
                opacity: style == .nightAtlas ? 0.84 : 0.90,
                lineWidth: style == .nightAtlas ? 0.6 : 0.75
            ),
            GlobePolygon(
                points: [
                    .init(latitude: 71, longitude: -53), .init(latitude: 76, longitude: -44),
                    .init(latitude: 74, longitude: -26), .init(latitude: 68, longitude: -20),
                    .init(latitude: 61, longitude: -34), .init(latitude: 61, longitude: -49)
                ],
                color: greenlandColor,
                stroke: stroke,
                opacity: style == .nightAtlas ? 0.28 : 0.72,
                lineWidth: style == .nightAtlas ? 0.55 : 0.7
            ),
            GlobePolygon(
                points: [
                    .init(latitude: 71, longitude: -10), .init(latitude: 65, longitude: 12),
                    .init(latitude: 58, longitude: 28), .init(latitude: 54, longitude: 44),
                    .init(latitude: 58, longitude: 64), .init(latitude: 56, longitude: 90),
                    .init(latitude: 50, longitude: 113), .init(latitude: 42, longitude: 132),
                    .init(latitude: 32, longitude: 124), .init(latitude: 24, longitude: 118),
                    .init(latitude: 18, longitude: 108), .init(latitude: 10, longitude: 104),
                    .init(latitude: 4, longitude: 97), .init(latitude: 5, longitude: 83),
                    .init(latitude: 12, longitude: 73), .init(latitude: 24, longitude: 66),
                    .init(latitude: 32, longitude: 47), .init(latitude: 36, longitude: 32),
                    .init(latitude: 31, longitude: 19), .init(latitude: 26, longitude: 11),
                    .init(latitude: 18, longitude: 2), .init(latitude: 6, longitude: -5),
                    .init(latitude: -8, longitude: 8), .init(latitude: -20, longitude: 17),
                    .init(latitude: -32, longitude: 19), .init(latitude: -35, longitude: 28),
                    .init(latitude: -27, longitude: 39), .init(latitude: -10, longitude: 50),
                    .init(latitude: 8, longitude: 44), .init(latitude: 20, longitude: 36),
                    .init(latitude: 28, longitude: 28), .init(latitude: 35, longitude: 20),
                    .init(latitude: 43, longitude: 6), .init(latitude: 52, longitude: -6),
                    .init(latitude: 60, longitude: -12)
                ],
                color: afroEurasiaColor,
                stroke: stroke,
                opacity: style == .nightAtlas ? 0.82 : 0.90,
                lineWidth: style == .nightAtlas ? 0.6 : 0.75
            ),
            GlobePolygon(
                points: [
                    .init(latitude: -12, longitude: 113), .init(latitude: -18, longitude: 121),
                    .init(latitude: -22, longitude: 132), .init(latitude: -30, longitude: 139),
                    .init(latitude: -36, longitude: 149), .init(latitude: -41, longitude: 147),
                    .init(latitude: -38, longitude: 132), .init(latitude: -31, longitude: 117),
                    .init(latitude: -22, longitude: 113)
                ],
                color: australiaColor,
                stroke: stroke,
                opacity: style == .nightAtlas ? 0.80 : 0.88,
                lineWidth: style == .nightAtlas ? 0.55 : 0.72
            )
        ]
    }

    private static func continentBlobs(for style: AtlasGlobeStyle) -> [GlobeBlob] {
        guard style != .nightAtlas && style != .realGeography else { return [] }
        let northAmericaColor: Color
        let southAmericaColor: Color
        let afroEurasiaColor: Color
        let eurasiaColor: Color
        let australiaColor: Color
        let iceColor: Color

        switch style {
        case .nightAtlas:
            northAmericaColor = Color(red: 0.23, green: 0.31, blue: 0.18)
            southAmericaColor = Color(red: 0.26, green: 0.35, blue: 0.20)
            afroEurasiaColor = Color(red: 0.29, green: 0.35, blue: 0.19)
            eurasiaColor = Color(red: 0.23, green: 0.29, blue: 0.17)
            australiaColor = Color(red: 0.28, green: 0.24, blue: 0.15)
            iceColor = Color(red: 0.62, green: 0.64, blue: 0.68)
        case .realGeography:
            northAmericaColor = Color(red: 0.45, green: 0.58, blue: 0.31)
            southAmericaColor = Color(red: 0.47, green: 0.61, blue: 0.32)
            afroEurasiaColor = Color(red: 0.60, green: 0.61, blue: 0.35)
            eurasiaColor = Color(red: 0.50, green: 0.58, blue: 0.33)
            australiaColor = Color(red: 0.69, green: 0.53, blue: 0.31)
            iceColor = Color.white.opacity(0.86)
        case .vintageExplorer:
            northAmericaColor = Color(red: 0.49, green: 0.38, blue: 0.25)
            southAmericaColor = Color(red: 0.54, green: 0.42, blue: 0.26)
            afroEurasiaColor = Color(red: 0.59, green: 0.47, blue: 0.28)
            eurasiaColor = Color(red: 0.50, green: 0.39, blue: 0.22)
            australiaColor = Color(red: 0.56, green: 0.42, blue: 0.24)
            iceColor = Color(red: 0.75, green: 0.67, blue: 0.54)
        case .animeJourney:
            northAmericaColor = Color(red: 0.52, green: 0.72, blue: 0.56)
            southAmericaColor = Color(red: 0.57, green: 0.76, blue: 0.58)
            afroEurasiaColor = Color(red: 0.74, green: 0.79, blue: 0.52)
            eurasiaColor = Color(red: 0.57, green: 0.73, blue: 0.57)
            australiaColor = Color(red: 0.82, green: 0.64, blue: 0.46)
            iceColor = Color.white.opacity(0.92)
        case .terrainExpedition:
            northAmericaColor = Color(red: 0.38, green: 0.47, blue: 0.26)
            southAmericaColor = Color(red: 0.47, green: 0.52, blue: 0.24)
            afroEurasiaColor = Color(red: 0.53, green: 0.49, blue: 0.24)
            eurasiaColor = Color(red: 0.46, green: 0.42, blue: 0.20)
            australiaColor = Color(red: 0.58, green: 0.47, blue: 0.23)
            iceColor = Color(red: 0.78, green: 0.82, blue: 0.78)
        }

        return field(centerLat: 48, centerLon: -104, latRadius: 19, lonRadius: 34, rows: 14, cols: 18, baseSize: 7.6, color: northAmericaColor, opacity: 0.44, aspect: 0.68)
        + field(centerLat: -18, centerLon: -61, latRadius: 26, lonRadius: 16, rows: 16, cols: 10, baseSize: 7.0, color: southAmericaColor, opacity: 0.46, aspect: 1.02)
        + field(centerLat: 11, centerLon: 18, latRadius: 36, lonRadius: 28, rows: 20, cols: 13, baseSize: 6.8, color: afroEurasiaColor, opacity: 0.42, aspect: 0.88)
        + field(centerLat: 43, centerLon: 66, latRadius: 23, lonRadius: 66, rows: 15, cols: 28, baseSize: 6.3, color: eurasiaColor, opacity: 0.40, aspect: 0.62)
        + field(centerLat: -24, centerLon: 134, latRadius: 12, lonRadius: 18, rows: 8, cols: 9, baseSize: 6.0, color: australiaColor, opacity: 0.36, aspect: 0.72)
        + field(centerLat: 72, centerLon: -40, latRadius: 7, lonRadius: 12, rows: 5, cols: 7, baseSize: 5.3, color: iceColor, opacity: 0.10, aspect: 0.58)
    }

    private static func lightBlobs(for style: AtlasGlobeStyle) -> [GlobeLight] {
        guard style != .realGeography else { return [] }
        let baseColor: Color = style == .animeJourney ? Color.white : AtlasColor.paleGold
        let densityBoost: CGFloat = style == .nightAtlas ? 1.15 : 1.0
        let europe = lights(centerLat: 50, centerLon: 6, latRadius: 9, lonRadius: 16, rows: 10, cols: 16, size: 3.8 * densityBoost, color: baseColor)
        let eastCoast = lights(centerLat: 40, centerLon: -74, latRadius: 9, lonRadius: 13, rows: 10, cols: 12, size: 3.5 * densityBoost, color: baseColor)
        let eastAsia = lights(centerLat: 31, centerLon: 121, latRadius: 9, lonRadius: 18, rows: 10, cols: 14, size: 3.4 * densityBoost, color: baseColor)
        let india = lights(centerLat: 22, centerLon: 78, latRadius: 11, lonRadius: 14, rows: 8, cols: 12, size: 3.1 * densityBoost, color: baseColor)
        let africa = lights(centerLat: 0, centerLon: 24, latRadius: 18, lonRadius: 12, rows: 10, cols: 7, size: 2.7 * densityBoost, color: baseColor)
        let brazil = lights(centerLat: -23, centerLon: -46, latRadius: 6, lonRadius: 9, rows: 6, cols: 7, size: 2.9 * densityBoost, color: baseColor)
        let mediterranean = style == .nightAtlas ? lights(centerLat: 36, centerLon: 18, latRadius: 6, lonRadius: 18, rows: 5, cols: 12, size: 2.8, color: baseColor) : []
        let gulf = style == .nightAtlas ? lights(centerLat: 26, centerLon: 50, latRadius: 4, lonRadius: 8, rows: 4, cols: 8, size: 3.1, color: baseColor) : []
        let japan = style == .nightAtlas ? lights(centerLat: 36, centerLon: 139, latRadius: 7, lonRadius: 6, rows: 5, cols: 6, size: 3.0, color: baseColor) : []

        return europe + eastCoast + eastAsia + india + africa + brazil + mediterranean + gulf + japan
    }

    private static func field(
        centerLat: Double,
        centerLon: Double,
        latRadius: Double,
        lonRadius: Double,
        rows: Int,
        cols: Int,
        baseSize: CGFloat,
        color: Color,
        opacity: Double,
        aspect: CGFloat
    ) -> [GlobeBlob] {
        guard rows > 1, cols > 1 else { return [] }

        var blobs: [GlobeBlob] = []
        for row in 0..<rows {
            let v = Double(row) / Double(rows - 1)
            let lat = centerLat - latRadius + v * latRadius * 2
            for col in 0..<cols {
                let u = Double(col) / Double(cols - 1)
                let lon = centerLon - lonRadius + u * lonRadius * 2
                let distance = pow((lat - centerLat) / latRadius, 2) + pow((lon - centerLon) / lonRadius, 2)
                guard distance < 1.02 else { continue }

                let wobble = sin(Double(row * 17 + col * 11)) * 0.85
                blobs.append(
                    GlobeBlob(
                        latitude: lat + wobble * 1.4,
                        longitude: lon + wobble * 1.2,
                        size: baseSize - CGFloat(distance) * 5.4,
                        aspect: aspect,
                        color: color,
                        opacity: opacity - distance * 0.18
                    )
                )
            }
        }
        return blobs
    }

    private static func lights(
        centerLat: Double,
        centerLon: Double,
        latRadius: Double,
        lonRadius: Double,
        rows: Int,
        cols: Int,
        size: CGFloat,
        color: Color
    ) -> [GlobeLight] {
        guard rows > 1, cols > 1 else { return [] }

        var points: [GlobeLight] = []
        for row in 0..<rows {
            let v = Double(row) / Double(rows - 1)
            let lat = centerLat - latRadius + v * latRadius * 2
            for col in 0..<cols {
                let u = Double(col) / Double(cols - 1)
                let lon = centerLon - lonRadius + u * lonRadius * 2
                let distance = pow((lat - centerLat) / latRadius, 2) + pow((lon - centerLon) / lonRadius, 2)
                guard distance < 1 else { continue }

                let jitter = sin(Double(row * 13 + col * 7)) * 0.55
                points.append(
                    GlobeLight(
                        latitude: lat + jitter,
                        longitude: lon - jitter * 0.7,
                        size: size - CGFloat(distance) * 1.2,
                        color: color
                    )
                )
            }
        }
        return points
    }
}

struct RouteMapCanvas: View {
    var body: some View {
        Canvas { context, size in
            var base = Path()
            base.addRect(CGRect(origin: .zero, size: size))
            context.fill(base, with: .linearGradient(
                Gradient(colors: [
                    Color(red: 0.02, green: 0.23, blue: 0.28),
                    AtlasColor.night,
                    Color.black.opacity(0.82)
                ]),
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: size.width, y: size.height)
            ))

            context.fill(base, with: .radialGradient(
                Gradient(colors: [AtlasColor.aqua.opacity(0.12), Color.clear]),
                center: CGPoint(x: size.width * 0.26, y: size.height * 0.18),
                startRadius: 0,
                endRadius: size.width * 0.82
            ))

            let gridColor = Color.white.opacity(0.034)
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

            let segments: [(CGPoint, CGPoint, Color, Bool)] = [
                (CGPoint(x: size.width * 0.12, y: size.height * 0.20), CGPoint(x: size.width * 0.48, y: size.height * 0.44), Color(red: 0.23, green: 0.58, blue: 1.0), true),
                (CGPoint(x: size.width * 0.48, y: size.height * 0.44), CGPoint(x: size.width * 0.76, y: size.height * 0.34), AtlasColor.gold, true),
                (CGPoint(x: size.width * 0.76, y: size.height * 0.34), CGPoint(x: size.width * 0.68, y: size.height * 0.72), AtlasColor.aqua, false),
                (CGPoint(x: size.width * 0.68, y: size.height * 0.72), CGPoint(x: size.width * 0.86, y: size.height * 0.58), AtlasColor.coral, true)
            ]

            var land = Path()
            land.move(to: CGPoint(x: size.width * 0.08, y: size.height * 0.17))
            land.addCurve(
                to: CGPoint(x: size.width * 0.65, y: size.height * 0.23),
                control1: CGPoint(x: size.width * 0.26, y: size.height * 0.04),
                control2: CGPoint(x: size.width * 0.46, y: size.height * 0.13)
            )
            land.addCurve(
                to: CGPoint(x: size.width * 0.70, y: size.height * 0.82),
                control1: CGPoint(x: size.width * 0.84, y: size.height * 0.42),
                control2: CGPoint(x: size.width * 0.54, y: size.height * 0.58)
            )
            land.addCurve(
                to: CGPoint(x: size.width * 0.16, y: size.height * 0.78),
                control1: CGPoint(x: size.width * 0.46, y: size.height * 0.92),
                control2: CGPoint(x: size.width * 0.30, y: size.height * 0.88)
            )
            land.closeSubpath()
            context.fill(land, with: .linearGradient(
                Gradient(colors: [
                    Color(red: 0.36, green: 0.37, blue: 0.25).opacity(0.42),
                    Color(red: 0.17, green: 0.27, blue: 0.23).opacity(0.28)
                ]),
                startPoint: CGPoint(x: size.width * 0.10, y: size.height * 0.12),
                endPoint: CGPoint(x: size.width * 0.75, y: size.height * 0.82)
            ))
            context.stroke(land, with: .color(AtlasColor.paleGold.opacity(0.08)), lineWidth: 1)

            for index in 0..<14 {
                let y = size.height * (0.24 + CGFloat(index) * 0.045)
                var contour = Path()
                contour.move(to: CGPoint(x: size.width * 0.16, y: y))
                contour.addQuadCurve(
                    to: CGPoint(x: size.width * 0.70, y: y + 14),
                    control: CGPoint(x: size.width * 0.42, y: y - 18)
                )
                context.stroke(contour, with: .color(Color.white.opacity(0.025)), lineWidth: 1)
            }

            for segment in segments {
                var path = Path()
                path.move(to: segment.0)
                path.addQuadCurve(
                    to: segment.1,
                    control: CGPoint(x: (segment.0.x + segment.1.x) / 2, y: min(segment.0.y, segment.1.y) - 36)
                )
                context.stroke(path, with: .color(segment.2.opacity(0.20)), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                context.stroke(path, with: .color(segment.2), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: segment.3 ? [6, 6] : []))
            }

            let stops: [(String, CGPoint, Color)] = [
                ("Lima", CGPoint(x: size.width * 0.12, y: size.height * 0.20), Color(red: 0.23, green: 0.58, blue: 1.0)),
                ("Cusco", CGPoint(x: size.width * 0.76, y: size.height * 0.34), AtlasColor.gold),
                ("Puno", CGPoint(x: size.width * 0.68, y: size.height * 0.72), AtlasColor.aqua),
                ("Machu Picchu", CGPoint(x: size.width * 0.48, y: size.height * 0.44), AtlasColor.paleGold)
            ]

            for stop in stops {
                context.fill(Path(ellipseIn: CGRect(x: stop.1.x - 9, y: stop.1.y - 9, width: 18, height: 18)), with: .color(stop.2.opacity(0.18)))
                context.fill(Path(ellipseIn: CGRect(x: stop.1.x - 4.5, y: stop.1.y - 4.5, width: 9, height: 9)), with: .color(AtlasColor.ink))
                context.stroke(Path(ellipseIn: CGRect(x: stop.1.x - 4.5, y: stop.1.y - 4.5, width: 9, height: 9)), with: .color(stop.2), lineWidth: 1.6)
                context.draw(
                    Text(stop.0)
                        .font(.atlasText(10, weight: .bold))
                        .foregroundStyle(AtlasColor.ink.opacity(0.78)),
                    at: CGPoint(x: stop.1.x + 12, y: stop.1.y - 10),
                    anchor: .leading
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .background(.white.opacity(0.035), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.12))
        )
    }
}

struct BadgeEmblem: View {
    let badge: BadgeItem

    var body: some View {
        ZStack {
            ShieldShape()
                .fill(
                    LinearGradient(
                        colors: badge.locked
                        ? [Color.white.opacity(0.10), Color.black.opacity(0.34)]
                        : [AtlasColor.gold.opacity(0.95), Color(red: 0.35, green: 0.20, blue: 0.09)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            ShieldShape()
                .stroke(Color.white.opacity(badge.locked ? 0.12 : 0.38), lineWidth: 1.5)
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(badge.locked ? Color.white.opacity(0.28) : AtlasColor.ink)
        }
        .frame(width: 54, height: 62)
        .shadow(color: badge.locked ? Color.clear : AtlasColor.gold.opacity(0.20), radius: 10, y: 5)
    }

    private var iconName: String {
        switch badge.symbol {
        case "✈":
            return "airplane"
        case "☾":
            return "moon.stars.fill"
        case "◎":
            return "circle.circle.fill"
        case "♜":
            return "building.columns.fill"
        case "☄":
            return "sparkles"
        case "⌁":
            return "ferry.fill"
        case "▵":
            return "mountain.2.fill"
        default:
            return "questionmark"
        }
    }
}

struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.18))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.90, y: rect.minY + rect.height * 0.70))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.10, y: rect.minY + rect.height * 0.70))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.18))
        path.closeSubpath()
        return path
    }
}
