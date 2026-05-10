import SwiftUI

struct HomeView: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasLanguage) private var language
    @Environment(\.atlasTheme) private var theme
    @Binding var globeStyle: AtlasGlobeStyle
    @State private var showsGlobeStyle = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [AtlasColor.bg(theme).opacity(0.9), AtlasColor.bg2(theme), AtlasColor.bg(theme)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            AtlasTexture()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                AtlasHeader(
                    title: "AtlasMe",
                    trailing: AnyView(
                        Button {
                            showsGlobeStyle = true
                        } label: {
                            Image(systemName: "globe.europe.africa.fill")
                                .foregroundStyle(AtlasColor.text(theme))
                        }
                    )
                )
                .padding(.top, 10)

                Text(copy.homeTitle)
                    .font(.atlasDisplay(31, weight: .semibold))
                    .foregroundStyle(AtlasColor.text(theme))
                    .lineSpacing(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 20)

                Text(copy.homeSubtitle)
                    .font(.atlasText(11.5, weight: .regular))
                    .foregroundStyle(AtlasColor.subtext(theme))
                    .lineSpacing(3)
                    .padding(.top, 8)

                GlobeShowcase(style: globeStyle)
                    .padding(.top, 4)
                    .padding(.bottom, 8)

                HStack(spacing: 10) {
                    StatTile(value: "52", label: copy.countries)
                    StatTile(value: "128", label: copy.cities)
                    StatTile(value: "312K", label: copy.kilometers)
                }

                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(copy.recentJourney)
                                .font(.atlasText(11, weight: .black))
                                .foregroundStyle(AtlasColor.gold)
                            Spacer()
                            Text(copy.viewAll)
                                .font(.atlasText(11, weight: .bold))
                                .foregroundStyle(AtlasColor.gold.opacity(0.85))
                        }

                        HStack(spacing: 12) {
                            ScenicThumb(colors: AtlasData.journeys[0].colors)
                                .frame(width: 92, height: 82)
                            VStack(alignment: .leading, spacing: 7) {
                                Text(AtlasData.journeys[0].title(language: language))
                                    .font(.atlasDisplay(18, weight: .semibold))
                                    .foregroundStyle(AtlasColor.text(theme))
                                Text(AtlasData.journeys[0].date)
                                    .font(.atlasText(11))
                                    .foregroundStyle(AtlasColor.subtext(theme))
                                HStack(spacing: 5) {
                                    Image(systemName: "location.circle")
                                    Text("\(AtlasData.journeys[0].distance)  ·  15 days")
                                }
                                .font(.atlasText(11, weight: .medium))
                                .foregroundStyle(AtlasColor.subtext(theme))
                            }
                            Spacer()
                            Image(systemName: "bookmark.circle.fill")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(AtlasColor.coral)
                        }
                    }
                }
                .padding(.top, 14)

                Spacer(minLength: 74)
            }
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $showsGlobeStyle) {
            GlobeStyleSheet(selectedStyle: $globeStyle)
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
                    .font(.atlasDisplay(23, weight: .semibold))
                    .foregroundStyle(AtlasColor.gold)
                Text(label)
                    .font(.atlasText(10, weight: .bold))
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
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 8) {
                        FilterPill(title: "All", active: true)
                        FilterPill(title: "Completed", active: false)
                        FilterPill(title: "Planned", active: false)
                    }

                    ForEach(Array(AtlasData.journeys.enumerated()), id: \.element.id) { index, journey in
                        if index == 0 || index == 2 {
                            Text(index == 0 ? "2024" : "2023")
                                .font(.atlasText(12, weight: .black))
                                .foregroundStyle(AtlasColor.gold)
                                .padding(.top, index == 0 ? 2 : 8)
                        }
                        HStack(alignment: .top, spacing: 12) {
                            VStack(spacing: 7) {
                                Circle()
                                    .fill(AtlasColor.gold)
                                    .frame(width: 7, height: 7)
                                Rectangle()
                                    .fill(AtlasColor.gold.opacity(0.24))
                                    .frame(width: 1, height: 108)
                            }

                            GlassCard {
                                HStack(spacing: 14) {
                                    ScenicThumb(colors: journey.colors)
                                        .frame(width: 104, height: 106)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                                .stroke(AtlasColor.paleGold.opacity(0.18), lineWidth: 1)
                                        )
                                    VStack(alignment: .leading, spacing: 7) {
                                        Text(journey.title(language: language))
                                            .font(.atlasDisplay(18, weight: .semibold))
                                            .foregroundStyle(AtlasColor.text(theme))
                                        Text(journey.date)
                                            .font(.atlasText(11))
                                            .foregroundStyle(AtlasColor.subtext(theme))
                                        Text(journey.route(language: language))
                                            .font(.atlasText(12, weight: .medium))
                                            .foregroundStyle(AtlasColor.subtext(theme))
                                        Text("\(journey.distance)  ·  \(journey.tags.count + 5) days")
                                            .font(.atlasText(11))
                                            .foregroundStyle(AtlasColor.subtext(theme))
                                        HStack(spacing: 6) {
                                            TransportIcon(name: "airplane", color: AtlasColor.aqua)
                                            TransportIcon(name: "tram.fill", color: AtlasColor.gold)
                                            TransportIcon(name: "figure.walk", color: AtlasColor.green)
                                            TransportIcon(name: "car.fill", color: AtlasColor.coral)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(AtlasColor.subtext(theme))
                                    .padding(13)
                            }
                        }
                    }
                }
                .padding(.bottom, 118)
            }
        }
        .sheet(isPresented: $showsAddJourney) {
            AddJourneySheet()
                .presentationDetents([.large])
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
                            ScenicThumb(colors: AtlasData.journeys[0].colors)
                                .frame(width: 82, height: 82)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(copy.currentSegment.uppercased())
                                    .font(.atlasText(11, weight: .black))
                                    .foregroundStyle(AtlasColor.gold)
                                Text("Train to Machu Picchu")
                                    .font(.atlasDisplay(19, weight: .semibold))
                                    .foregroundStyle(AtlasColor.text(theme))
                                Text("Ollantaytambo → Aguas Calientes\n1h 45m · 43 km")
                                    .font(.atlasText(12))
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
        DarkScreen(
            title: copy.exploreTitle,
            subtitle: copy.exploreSubtitle,
            trailing: AnyView(
                Button {
                } label: {
                    Image(systemName: "heart")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(AtlasColor.text(theme))
                }
                .buttonStyle(.plain)
            )
        ) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(AtlasColor.subtext(theme))
                    Text("Where to next?")
                        .font(.atlasText(13))
                        .foregroundStyle(AtlasColor.subtext(theme))
                    Spacer()
                }
                .frame(height: 44)
                .padding(.horizontal, 14)
                .background(theme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.58), in: Capsule())
                .overlay(
                    Capsule()
                        .stroke(AtlasColor.cardStroke(theme))
                )
                .padding(.top, 18)

                HStack {
                    FilterPill(title: "For you", active: true)
                    FilterPill(title: "Trending", active: false)
                    FilterPill(title: "Near you", active: false)
                    FilterPill(title: "New", active: false)
                }
                .padding(.top, 16)

                Text(copy.handpicked)
                    .font(.atlasText(14, weight: .semibold))
                    .foregroundStyle(AtlasColor.text(theme))
                    .padding(.top, 18)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 14) {
                        ForEach(Array(AtlasData.places.enumerated()), id: \.element.id) { index, place in
                            VStack(alignment: .leading, spacing: 0) {
                                ScenicThumb(colors: place.colors, label: index < 2 ? (index == 0 ? "Recommended" : "Trending") : nil)
                                    .frame(height: 142)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(place.name)
                                        .font(.atlasDisplay(19, weight: .semibold))
                                        .foregroundStyle(AtlasColor.text(theme))
                                    Text(place.country)
                                        .font(.atlasText(11, weight: .bold))
                                        .foregroundStyle(AtlasColor.gold)
                                    Text(place.description(language: language))
                                        .font(.atlasText(11))
                                        .foregroundStyle(AtlasColor.subtext(theme))
                                        .lineLimit(3)
                                    HStack(spacing: 5) {
                                        ChipLabel(title: "Culture")
                                        ChipLabel(title: "History")
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.top, 12)
                                .padding(.bottom, 14)
                            }
                            .background(
                                LinearGradient(
                                    colors: [
                                        theme == .dark ? AtlasColor.card(theme).opacity(0.98) : Color.white.opacity(0.88),
                                        theme == .dark ? AtlasColor.card(theme).opacity(0.72) : Color(red: 1.0, green: 0.96, blue: 0.89).opacity(0.88)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(AtlasColor.cardStroke(theme))
                            )
                            .shadow(color: theme == .dark ? Color.black.opacity(0.24) : Color.black.opacity(0.08), radius: 16, y: 10)
                        }
                    }
                    .padding(.bottom, 210)
                }
                .padding(.top, 12)
            }
        }
    }
}

struct ProfileView: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasLanguage) private var language
    @Environment(\.atlasTheme) private var theme
    @Binding var globeStyle: AtlasGlobeStyle
    let toggleLanguage: () -> Void
    let toggleTheme: () -> Void
    @State private var showsGlobeStyle = false
    @State private var showsBadgeWall = false

    var body: some View {
        DarkScreen(title: copy.profileTitle, subtitle: copy.travelPersonality) {
            ScrollView {
                VStack(spacing: 14) {
                    // User card
                    GlassCard {
                        HStack(spacing: 14) {
                            Circle()
                                .fill(LinearGradient(colors: [AtlasColor.paleGold, AtlasColor.gold], startPoint: .top, endPoint: .bottom))
                                .frame(width: 58, height: 58)
                                .overlay(Image(systemName: "person.fill").foregroundStyle(AtlasColor.bg(theme)))
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Alex Morgan")
                                    .font(.atlasDisplay(19, weight: .semibold))
                                    .foregroundStyle(AtlasColor.text(theme))
                                Text(copy.travelPersonality)
                                    .font(.atlasText(12))
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
                            HStack(alignment: .firstTextBaseline) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(copy.badgeWall)
                                        .font(.atlasDisplay(21, weight: .semibold))
                                        .foregroundStyle(AtlasColor.text(theme))
                                    Text("37 \(copy.earnedBadges.lowercased())")
                                        .font(.atlasText(11, weight: .semibold))
                                        .foregroundStyle(AtlasColor.subtext(theme))
                                }
                                Spacer()
                                Button {
                                    showsBadgeWall = true
                                } label: {
                                    Text(copy.viewAll)
                                        .font(.atlasText(11, weight: .bold))
                                        .foregroundStyle(AtlasColor.gold)
                                }
                                .buttonStyle(.plain)
                            }

                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .stroke(AtlasColor.gold.opacity(0.20), lineWidth: 7)
                                    Circle()
                                        .trim(from: 0, to: 0.72)
                                        .stroke(AtlasColor.gold, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                                        .rotationEffect(.degrees(-90))
                                    Text("37")
                                        .font(.atlasDisplay(18, weight: .semibold))
                                        .foregroundStyle(AtlasColor.gold)
                                }
                                .frame(width: 52, height: 52)

                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Rare badges 4/5")
                                        .font(.atlasText(12, weight: .black))
                                        .foregroundStyle(AtlasColor.text(theme))
                                    ProgressView(value: 0.8)
                                        .tint(AtlasColor.gold)
                                    Text("Route mastery, night arrivals, and culture finds.")
                                        .font(.atlasText(10, weight: .medium))
                                        .foregroundStyle(AtlasColor.subtext(theme))
                                }
                            }

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                                ForEach(AtlasData.badges.prefix(4)) { badge in
                                    VStack(spacing: 6) {
                                        BadgeEmblem(badge: badge)
                                        Text(badge.title(language: language))
                                            .font(.atlasText(9, weight: .bold))
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
                                        .font(.atlasDisplay(17, weight: .semibold))
                                        .foregroundStyle(AtlasColor.text(theme))
                                    Text(globeStyle.title)
                                        .font(.atlasText(12))
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
            GlobeStyleSheet(selectedStyle: $globeStyle)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showsBadgeWall) {
            BadgeWallSheet()
                .presentationDetents([.large])
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
                    .font(.atlasText(15, weight: .semibold))
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
            AtlasTexture()
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                AtlasHeader(title: "AtlasMe", trailing: trailing)
                    .padding(.top, 10)
                Text(title)
                    .font(.atlasDisplay(30, weight: .semibold))
                    .foregroundStyle(AtlasColor.text(theme))
                    .padding(.top, 26)
                Text(subtitle)
                    .font(.atlasText(13))
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
            .font(.atlasText(12, weight: .bold))
            .foregroundStyle(active ? AtlasColor.bg(theme) : AtlasColor.subtext(theme))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(active ? AtlasColor.gold : (theme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.05)), in: Capsule())
    }
}

struct GlobeStyleSheet: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasTheme) private var theme
    @Binding var selectedStyle: AtlasGlobeStyle

    var body: some View {
        ZStack {
            AtlasColor.bg(theme).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(copy.globeStyle)
                        .font(.atlasDisplay(25, weight: .semibold))
                        .foregroundStyle(AtlasColor.text(theme))
                    Text("Choose how AtlasMe draws your world.")
                        .font(.atlasText(13))
                        .foregroundStyle(AtlasColor.subtext(theme))

                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Globe Atelier")
                                    .font(.atlasDisplay(18, weight: .semibold))
                                    .foregroundStyle(AtlasColor.text(theme))
                                Spacer()
                                Text("5 skins")
                                    .font(.atlasText(10, weight: .black))
                                    .foregroundStyle(AtlasColor.gold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(AtlasColor.gold.opacity(0.12), in: Capsule())
                            }
                            Text("AtlasMe's globe is now treated like a collectible surface system: core mode, signature mode, and premium skins.")
                                .font(.atlasText(12))
                                .foregroundStyle(AtlasColor.subtext(theme))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    ForEach(AtlasGlobeStyle.allCases, id: \.rawValue) { style in
                        Button {
                            selectedStyle = style
                        } label: {
                            GlassCard {
                                HStack(spacing: 14) {
                                    GlobeModePreview(style: style)
                                        .frame(width: 84, height: 70)
                                    VStack(alignment: .leading, spacing: 5) {
                                        HStack(spacing: 6) {
                                            Text(style.title)
                                                .font(.atlasDisplay(17, weight: .semibold))
                                                .foregroundStyle(AtlasColor.text(theme))
                                            Text(style.capsule.uppercased())
                                                .font(.atlasText(8, weight: .black))
                                                .foregroundStyle(AtlasColor.gold)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 3)
                                                .background(AtlasColor.gold.opacity(0.12), in: Capsule())
                                        }
                                        Text(style.subtitle)
                                            .font(.atlasText(12))
                                            .foregroundStyle(AtlasColor.subtext(theme))
                                        Text(style.story)
                                            .font(.atlasText(10.5, weight: .medium))
                                            .foregroundStyle(AtlasColor.subtext(theme).opacity(0.88))
                                            .lineLimit(2)
                                        if style.isPremium {
                                            Text("PREMIUM SKIN")
                                                .font(.atlasText(9, weight: .black))
                                                .foregroundStyle(AtlasColor.gold)
                                                .padding(.horizontal, 7)
                                                .padding(.vertical, 3)
                                                .background(AtlasColor.gold.opacity(0.12), in: Capsule())
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: selectedStyle == style ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 23, weight: .semibold))
                                        .foregroundStyle(selectedStyle == style ? AtlasColor.gold : AtlasColor.subtext(theme).opacity(0.7))
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .overlay {
                            if selectedStyle == style {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(AtlasColor.gold.opacity(0.78), lineWidth: 1.5)
                            }
                        }
                    }

                    Spacer(minLength: 32)
                }
                .padding(22)
            }
        }
    }
}

struct AddJourneySheet: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasTheme) private var theme

    var body: some View {
        ZStack {
            LinearGradient(colors: [AtlasColor.bg(theme), AtlasColor.bg2(theme)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(copy.addJourney)
                        .font(.atlasDisplay(26, weight: .semibold))
                        .foregroundStyle(AtlasColor.text(theme))

                    sectionTitle(copy.route)
                    GlassCard {
                        VStack(spacing: 0) {
                            RouteStopRow(name: "Lima, Peru", icon: "airplane", color: AtlasColor.aqua, isLast: false)
                            RouteStopRow(name: "Cusco, Peru", icon: "tram.fill", color: AtlasColor.gold, isLast: false)
                            RouteStopRow(name: "Machu Picchu", icon: "figure.walk", color: AtlasColor.green, isLast: false)
                            RouteStopRow(name: "Puno, Peru", icon: "car.fill", color: AtlasColor.coral, isLast: true)
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                Text("Add stop")
                                    .font(.atlasText(13, weight: .semibold))
                            }
                            .foregroundStyle(AtlasColor.aqua)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 12)
                        }
                    }

                    sectionTitle(copy.travelDates)
                    GlassCard {
                        HStack {
                            Text("May 10, 2024")
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundStyle(AtlasColor.gold)
                            Spacer()
                            Text("May 24, 2024")
                        }
                        .font(.atlasText(14, weight: .semibold))
                        .foregroundStyle(AtlasColor.text(theme))
                    }

                    sectionTitle(copy.mood)
                    HStack {
                        MoodChip(title: "Inspiring", active: true)
                        MoodChip(title: "Relaxing", active: false)
                        MoodChip(title: "Adventurous", active: false)
                    }

                    sectionTitle(copy.mapPreview)
                    RouteMapCanvas()
                        .frame(height: 150)

                    Button {
                    } label: {
                        Text(copy.saveJourney)
                            .font(.atlasText(16, weight: .black))
                            .foregroundStyle(AtlasColor.bg(theme))
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(
                                LinearGradient(colors: [AtlasColor.aqua, AtlasColor.gold], startPoint: .leading, endPoint: .trailing),
                                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                            )
                    }
                    .padding(.top, 6)
                }
                .padding(22)
            }
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.atlasText(13, weight: .black))
            .foregroundStyle(AtlasColor.text(theme))
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
                    .font(.atlasText(11, weight: .black))
                    .foregroundStyle(AtlasColor.subtext(theme))
                Text(value)
                    .font(.atlasText(16, weight: .bold))
                    .foregroundStyle(AtlasColor.text(theme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct RouteStopRow: View {
    @Environment(\.atlasTheme) private var theme
    let name: String
    let icon: String
    let color: Color
    let isLast: Bool

    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .stroke(color.opacity(0.85), lineWidth: 1.5)
                    .frame(width: 9, height: 9)
                if !isLast {
                    Rectangle()
                        .fill(AtlasColor.cardStroke(theme))
                        .frame(width: 1, height: 27)
                }
            }
            .frame(width: 12)

            Text(name)
                .font(.atlasText(13, weight: .semibold))
                .foregroundStyle(AtlasColor.text(theme))
            Spacer()
            TransportIcon(name: icon, color: color)
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AtlasColor.subtext(theme))
        }
        .padding(.vertical, 3)
    }
}

struct MoodChip: View {
    @Environment(\.atlasTheme) private var theme
    let title: String
    let active: Bool

    var body: some View {
        Text(title)
            .font(.atlasText(12, weight: .bold))
            .foregroundStyle(active ? AtlasColor.gold : AtlasColor.subtext(theme))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(active ? AtlasColor.gold.opacity(0.15) : AtlasColor.card(theme), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(active ? AtlasColor.gold.opacity(0.7) : AtlasColor.cardStroke(theme))
            )
    }
}

struct BadgeWallSheet: View {
    @Environment(\.copy) private var copy
    @Environment(\.atlasLanguage) private var language
    @Environment(\.atlasTheme) private var theme

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        ZStack {
            AtlasColor.bg(theme).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(copy.badgeWall)
                        .font(.atlasDisplay(26, weight: .semibold))
                        .foregroundStyle(AtlasColor.text(theme))

                    GlassCard {
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(AtlasColor.gold.opacity(0.25), lineWidth: 10)
                                    .frame(width: 76, height: 76)
                                Circle()
                                    .trim(from: 0, to: 0.72)
                                    .stroke(AtlasColor.gold, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .frame(width: 76, height: 76)
                                    .rotationEffect(.degrees(-90))
                                VStack(spacing: 0) {
                                    Text("37")
                                        .font(.atlasDisplay(26, weight: .semibold))
                                        .foregroundStyle(AtlasColor.gold)
                                    Text("badges")
                                        .font(.atlasText(9, weight: .bold))
                                        .foregroundStyle(AtlasColor.subtext(theme))
                                }
                            }
                            Spacer()
                            badgeStat("24", "Common")
                            badgeStat("8", "Rare")
                            badgeStat("4", "Epic")
                            badgeStat("1", "Legendary")
                        }
                    }

                    badgeSection("Rare Badges", badges: Array(AtlasData.badges.prefix(4)))
                    badgeSection("Route Mastery", badges: Array(AtlasData.badges.dropFirst(2).prefix(4)))
                    badgeSection("Hidden Achievements", badges: Array(AtlasData.badges.suffix(4)))
                }
                .padding(22)
            }
        }
    }

    private func badgeStat(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.atlasDisplay(19, weight: .semibold))
                .foregroundStyle(AtlasColor.text(theme))
            Text(label)
                .font(.atlasText(9, weight: .bold))
                .foregroundStyle(AtlasColor.subtext(theme))
        }
    }

    private func badgeSection(_ title: String, badges: [BadgeItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.atlasDisplay(18, weight: .semibold))
                    .foregroundStyle(AtlasColor.gold)
                Spacer()
                Text("\(badges.filter { !$0.locked }.count)/\(badges.count)")
                    .font(.atlasText(12, weight: .semibold))
                    .foregroundStyle(AtlasColor.subtext(theme))
            }
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(badges) { badge in
                    VStack(spacing: 7) {
                        BadgeEmblem(badge: badge)
                        Text(badge.title(language: language))
                            .font(.atlasText(9, weight: .bold))
                            .foregroundStyle(AtlasColor.text(theme))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
            }
        }
    }
}
