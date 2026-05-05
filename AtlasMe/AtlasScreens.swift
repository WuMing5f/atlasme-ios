import SwiftUI

struct HomeView: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasLanguage) private var language
    @Environment(\.atlasTheme) private var theme
    @State private var showsGlobeStyle = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [AtlasColor.bg(theme).opacity(0.9), AtlasColor.bg2(theme), AtlasColor.bg(theme)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                AtlasHeader(
                    title: "AtlasMe",
                    trailing: AnyView(
                        Button {
                            showsGlobeStyle = true
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(AtlasColor.text(theme))
                        }
                    )
                )
                .padding(.top, 10)

                Text(copy.homeTitle)
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundStyle(AtlasColor.text(theme))
                    .lineSpacing(-3)
                    .padding(.top, 28)

                Text(copy.homeSubtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(AtlasColor.subtext(theme))
                    .lineSpacing(4)
                    .padding(.top, 12)

                GlobeCanvas()
                    .padding(.vertical, 20)

                HStack(spacing: 10) {
                    StatTile(value: "52", label: copy.countries)
                    StatTile(value: "128", label: copy.cities)
                    StatTile(value: "312K", label: copy.kilometers)
                }

                GlassCard {
                    HStack(spacing: 12) {
                        GradientThumb(colors: AtlasData.journeys[0].colors)
                            .frame(width: 86, height: 86)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(copy.recentJourney)
                                .font(.system(size: 11, weight: .black))
                                .foregroundStyle(AtlasColor.gold)
                            Text(AtlasData.journeys[0].title(language: language))
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(AtlasColor.text(theme))
                            Text("\(AtlasData.journeys[0].route(language: language))\n\(AtlasData.journeys[0].date)")
                                .font(.system(size: 12))
                                .foregroundStyle(AtlasColor.subtext(theme))
                        }
                        Spacer()
                    }
                }
                .padding(.top, 14)

                Spacer(minLength: 74)
            }
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $showsGlobeStyle) {
            GlobeStyleSheet()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct StatTile: View {
    @Environment(\.atlasTheme) private var theme
    let value: String
    let label: String

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(AtlasColor.gold)
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(AtlasColor.subtext(theme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct JourneysView: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasLanguage) private var language
    @Environment(\.atlasTheme) private var theme
    @State private var showsAddJourney = false

    var body: some View {
        DarkScreen(title: copy.archiveTitle, subtitle: copy.archiveSubtitle, trailing: AnyView(
            Button {
                showsAddJourney = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AtlasColor.text(theme))
            }
        )) {
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(AtlasData.journeys) { journey in
                        GlassCard {
                            HStack(spacing: 14) {
                                GradientThumb(colors: journey.colors)
                                    .frame(width: 92, height: 102)
                                VStack(alignment: .leading, spacing: 7) {
                                    Text(journey.title(language: language))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(AtlasColor.text(theme))
                                    Text("\(journey.route(language: language))\n\(journey.distance)")
                                        .font(.system(size: 12))
                                        .foregroundStyle(AtlasColor.subtext(theme))
                                    HStack {
                                        ForEach(journey.tags, id: \.self) { tag in
                                            ChipLabel(title: tag)
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.bottom, 118)
            }
        }
        .sheet(isPresented: $showsAddJourney) {
            AddJourneySheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

struct MapReplayView: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasTheme) private var theme

    var body: some View {
        DarkScreen(title: copy.replayTitle, subtitle: copy.replaySubtitle) {
            VStack(spacing: 16) {
                RouteMapCanvas()
                    .frame(maxHeight: .infinity)

                GlassCard {
                    VStack(spacing: 18) {
                        HStack(spacing: 14) {
                            GradientThumb(colors: AtlasData.journeys[0].colors)
                                .frame(width: 82, height: 82)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(copy.replayTitle.uppercased())
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundStyle(AtlasColor.gold)
                                Text("Train to Machu Picchu")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(AtlasColor.text(theme))
                                Text("Ollantaytambo → Aguas Calientes\n1h 45m · 43 km")
                                    .font(.system(size: 12))
                                    .foregroundStyle(AtlasColor.subtext(theme))
                            }
                            Spacer()
                        }

                        ProgressView(value: 0.48)
                            .tint(AtlasColor.gold)

                        HStack(spacing: 30) {
                            Image(systemName: "gobackward.10")
                            ZStack {
                                Circle()
                                    .fill(AtlasColor.gold)
                                    .frame(width: 56, height: 56)
                                Image(systemName: "play.fill")
                                    .foregroundStyle(AtlasColor.bg(theme))
                            }
                            Image(systemName: "goforward.10")
                        }
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(AtlasColor.text(theme))
                    }
                }
                .padding(.bottom, 86)
            }
        }
    }
}

struct ExploreView: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasLanguage) private var language
    @Environment(\.atlasTheme) private var theme

    var body: some View {
        DarkScreen(title: copy.exploreTitle, subtitle: copy.exploreSubtitle, trailing: AnyView(
            Image(systemName: "heart")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(AtlasColor.text(theme))
        )) {
            ScrollView {
                VStack(spacing: 14) {
                    Text("Search cities, nature, food, rail routes")
                        .font(.system(size: 13))
                        .foregroundStyle(AtlasColor.subtext(theme))
                        .frame(maxWidth: .infinity, minHeight: 46, alignment: .leading)
                        .padding(.horizontal, 16)
                        .background(theme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 17, style: .continuous))

                    HStack {
                        FilterPill(title: "For you", active: true)
                        FilterPill(title: "Trending", active: false)
                        FilterPill(title: "Near you", active: false)
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(AtlasData.places) { place in
                            VStack(alignment: .leading, spacing: 0) {
                                GradientThumb(colors: place.colors)
                                    .frame(height: 132)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(place.name)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(AtlasColor.text(theme))
                                    Text(place.country)
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(AtlasColor.subtext(theme))
                                    Text(place.description(language: language))
                                        .font(.system(size: 11))
                                        .foregroundStyle(AtlasColor.subtext(theme))
                                        .lineLimit(3)
                                }
                                .padding(12)
                            }
                            .background(AtlasColor.bg2(theme), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .stroke(AtlasColor.cardStroke(theme))
                            )
                        }
                    }
                }
                .padding(.bottom, 96)
            }
        }
    }
}

struct ProfileView: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasLanguage) private var language
    @Environment(\.atlasTheme) private var theme
    let toggleLanguage: () -> Void
    let toggleTheme: () -> Void
    @State private var showsGlobeStyle = false

    var body: some View {
        DarkScreen(title: copy.profileTitle, subtitle: copy.travelPersonality) {
            ScrollView {
                VStack(spacing: 14) {
                    // User card
                    GlassCard {
                        HStack(spacing: 14) {
                            Circle()
                                .fill(AtlasColor.gold)
                                .frame(width: 58, height: 58)
                                .overlay(Image(systemName: "person.fill").foregroundStyle(AtlasColor.bg(theme)))
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Alex Morgan")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(AtlasColor.text(theme))
                                Text(copy.travelPersonality)
                                    .font(.system(size: 12))
                                    .foregroundStyle(AtlasColor.subtext(theme))
                            }
                            Spacer()
                        }
                    }

                    // Settings card
                    GlassCard {
                        VStack(spacing: 0) {
                            settingsRow(
                                icon: "globe",
                                title: copy.languageToggle,
                                action: toggleLanguage
                            )
                            Divider().background(AtlasColor.cardStroke(theme))
                            settingsRow(
                                icon: theme == .dark ? "sun.max.fill" : "moon.fill",
                                title: theme == .dark ? "Light Mode" : "Dark Mode",
                                action: toggleTheme
                            )
                        }
                    }

                    // Badge wall
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(copy.badgeWall)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(AtlasColor.text(theme))
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                                ForEach(AtlasData.badges) { badge in
                                    VStack(spacing: 6) {
                                        Text(badge.symbol)
                                            .font(.system(size: 20, weight: .black))
                                            .frame(width: 44, height: 44)
                                            .background(
                                                RadialGradient(colors: [AtlasColor.gold, Color(red: 0.56, green: 0.37, blue: 0.14)], center: .center, startRadius: 0, endRadius: 32),
                                                in: Circle()
                                            )
                                            .opacity(badge.locked ? 0.45 : 1)
                                        Text(badge.title(language: language))
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundStyle(AtlasColor.text(theme))
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .opacity(badge.locked ? 0.45 : 1)
                                    }
                                }
                            }
                        }
                    }

                    // Globe style
                    Button {
                        showsGlobeStyle = true
                    } label: {
                        GlassCard {
                            HStack {
                                Image(systemName: "globe.europe.africa.fill")
                                    .foregroundStyle(AtlasColor.gold)
                                VStack(alignment: .leading) {
                                    Text(copy.globeStyle)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(AtlasColor.text(theme))
                                    Text("Night Atlas, Real Geography, Vintage, Anime, Terrain")
                                        .font(.system(size: 12))
                                        .foregroundStyle(AtlasColor.subtext(theme))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(AtlasColor.subtext(theme))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 118)
            }
        }
        .sheet(isPresented: $showsGlobeStyle) {
            GlobeStyleSheet()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private func settingsRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AtlasColor.gold)
                    .frame(width: 28)
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AtlasColor.text(theme))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AtlasColor.subtext(theme))
            }
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct DarkScreen<Content: View>: View {
    @Environment(\.atlasTheme) private var theme
    let title: String
    let subtitle: String
    let trailing: AnyView?
    let content: () -> Content

    init(title: String, subtitle: String, trailing: AnyView? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
        self.content = content
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [AtlasColor.bg(theme).opacity(0.9), AtlasColor.bg2(theme)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                AtlasHeader(title: "AtlasMe", trailing: trailing)
                    .padding(.top, 10)
                Text(title)
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundStyle(AtlasColor.text(theme))
                    .padding(.top, 26)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(AtlasColor.subtext(theme))
                    .lineSpacing(4)
                    .padding(.top, 8)
                content()
                    .padding(.top, 22)
            }
            .padding(.horizontal, 24)
        }
    }
}

struct FilterPill: View {
    @Environment(\.atlasTheme) private var theme
    let title: String
    let active: Bool

    var body: some View {
        Text(title)
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(active ? AtlasColor.bg(theme) : AtlasColor.subtext(theme))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(active ? AtlasColor.gold : (theme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.05)), in: Capsule())
    }
}

struct GlobeStyleSheet: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasTheme) private var theme

    private let styles: [(String, String, Color)] = [
        ("Night Atlas", "City lights, golden arcs, private map.", Color(red: 0.18, green: 0.51, blue: 0.63)),
        ("Real Geography", "Satellite land, terrain, coastlines.", Color(red: 0.42, green: 0.56, blue: 0.70)),
        ("Vintage Explorer", "Old map paper, compass, ink routes.", Color(red: 0.84, green: 0.68, blue: 0.45)),
        ("Anime Journey", "Soft cities and playful routes.", Color(red: 0.96, green: 0.70, blue: 0.64)),
        ("Terrain Expedition", "Mountains, deserts, forests, roads.", Color(red: 0.65, green: 0.76, blue: 0.48))
    ]

    var body: some View {
        ZStack {
            AtlasColor.bg(theme).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                Text(copy.globeStyle)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundStyle(AtlasColor.text(theme))
                    .padding(.bottom, 4)

                ForEach(styles, id: \.0) { style in
                    GlassCard {
                        HStack(spacing: 14) {
                            Circle()
                                .fill(style.2)
                                .frame(width: 52, height: 52)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(style.0)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(AtlasColor.text(theme))
                                Text(style.1)
                                    .font(.system(size: 12))
                                    .foregroundStyle(AtlasColor.subtext(theme))
                            }
                            Spacer()
                            if style.0 == "Night Atlas" {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AtlasColor.gold)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(22)
        }
    }
}

struct AddJourneySheet: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasTheme) private var theme

    var body: some View {
        ZStack {
            AtlasColor.bg(theme).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 14) {
                Text(copy.addJourney)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundStyle(AtlasColor.text(theme))
                PrototypeField(label: "JOURNEY NAME", value: "Iceland Ring Road")
                PrototypeField(label: "DATE RANGE", value: "Sep 3 - Sep 12, 2026")
                PrototypeField(label: "TRANSPORT MIX", value: "Flight + self-drive + walking")
                Button {
                } label: {
                    Text("Save journey draft")
                        .font(.system(size: 16, weight: .black))
                        .foregroundStyle(AtlasColor.bg(theme))
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(AtlasColor.gold, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                Spacer()
            }
            .padding(22)
        }
    }
}

struct PrototypeField: View {
    @Environment(\.atlasTheme) private var theme
    let label: String
    let value: String

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(label)
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(AtlasColor.subtext(theme))
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AtlasColor.text(theme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
