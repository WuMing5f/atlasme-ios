import SwiftUI

struct Journey: Identifiable {
    let id = UUID()
    let titleEnglish: String
    let titleChinese: String
    let routeEnglish: String
    let routeChinese: String
    let date: String
    let distance: String
    let colors: [Color]
    let tags: [String]

    func title(language: AtlasLanguage) -> String {
        language == .chinese ? titleChinese : titleEnglish
    }

    func route(language: AtlasLanguage) -> String {
        language == .chinese ? routeChinese : routeEnglish
    }
}

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let descriptionEnglish: String
    let descriptionChinese: String
    let colors: [Color]

    func description(language: AtlasLanguage) -> String {
        language == .chinese ? descriptionChinese : descriptionEnglish
    }
}

struct BadgeItem: Identifiable {
    let id = UUID()
    let symbol: String
    let titleEnglish: String
    let titleChinese: String
    let locked: Bool

    func title(language: AtlasLanguage) -> String {
        language == .chinese ? titleChinese : titleEnglish
    }
}

enum AtlasData {
    static let journeys = [
        Journey(
            titleEnglish: "Peru Uncovered",
            titleChinese: "秘鲁山谷之旅",
            routeEnglish: "Lima → Cusco → Puno",
            routeChinese: "利马 → 库斯科 → 普诺",
            date: "May 10 - May 24, 2024",
            distance: "2,128 km",
            colors: [.red.opacity(0.7), AtlasColor.gold, AtlasColor.green],
            tags: ["flight", "rail", "walking"]
        ),
        Journey(
            titleEnglish: "Vietnam in Slow Motion",
            titleChinese: "越南慢行",
            routeEnglish: "Hanoi, Hoi An, Da Nang",
            routeChinese: "河内、会安、岘港",
            date: "Mar 3 - Mar 17, 2024",
            distance: "1,145 km",
            colors: [.orange, AtlasColor.aqua, .blue.opacity(0.55)],
            tags: ["food", "walk"]
        ),
        Journey(
            titleEnglish: "Andalusia Road Trip",
            titleChinese: "安达卢西亚自驾",
            routeEnglish: "Seville, Ronda, Granada",
            routeChinese: "塞维利亚、龙达、格拉纳达",
            date: "Oct 8 - Oct 15, 2023",
            distance: "1,026 km",
            colors: [AtlasColor.coral, AtlasColor.gold, .blue.opacity(0.55)],
            tags: ["drive", "history"]
        )
    ]

    static let places = [
        Place(name: "Granada", country: "Spain", descriptionEnglish: "Moorish heritage and soulful streets.", descriptionChinese: "摩尔遗产与有灵魂的街巷。", colors: [AtlasColor.coral, AtlasColor.gold, .blue.opacity(0.56)]),
        Place(name: "Hoi An", country: "Vietnam", descriptionEnglish: "Lantern nights and coastal food.", descriptionChinese: "灯笼夜色与海岸美食。", colors: [.orange, AtlasColor.aqua, .blue.opacity(0.65)]),
        Place(name: "Cusco", country: "Peru", descriptionEnglish: "Ancient routes and vibrant Andes.", descriptionChinese: "古老路线与鲜活安第斯。", colors: [.red.opacity(0.7), AtlasColor.gold, AtlasColor.green]),
        Place(name: "Reykjavik", country: "Iceland", descriptionEnglish: "Nordic nature and open roads.", descriptionChinese: "北欧自然与开阔公路。", colors: [AtlasColor.aqua, .gray, .blue.opacity(0.5)])
    ]

    static let badges = [
        BadgeItem(symbol: "✈", titleEnglish: "Cross-Continent", titleChinese: "跨洲飞行", locked: false),
        BadgeItem(symbol: "☾", titleEnglish: "Night Arrival", titleChinese: "午夜抵达", locked: false),
        BadgeItem(symbol: "◎", titleEnglish: "Ring Road", titleChinese: "环岛公路", locked: false),
        BadgeItem(symbol: "♜", titleEnglish: "World Heritage", titleChinese: "世界遗产", locked: false),
        BadgeItem(symbol: "☄", titleEnglish: "Aurora Seeker", titleChinese: "极光追寻者", locked: false),
        BadgeItem(symbol: "⌁", titleEnglish: "Ocean Crossing", titleChinese: "跨海航线", locked: false),
        BadgeItem(symbol: "▵", titleEnglish: "High Altitude", titleChinese: "高海拔", locked: false),
        BadgeItem(symbol: "?", titleEnglish: "Hidden Route", titleChinese: "隐藏路线", locked: true)
    ]
}

