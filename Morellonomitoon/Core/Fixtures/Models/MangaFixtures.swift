//
//  MangaFixtures.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import Foundation

enum MangaFixtures {
    
    static let manga: Manga = Manga(
        id: "solo-leveling",
        title: "Solo Leveling",
        authors: ["Chugong", "Sung-rak Jang", "Disciples"],
        url: URL(string: "https://www.mangabats.com/manga/solo-leveling"),
        thumbnailURL: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1735554741i/57989928.jpg"),
        description: """
            Sung Jinwoo, also known as "the weakest hunter of all mankind," resides in a world full of awakened beings known as "Hunters" whose sole purpose is to protect humanity by battling deadly monsters. Jinwoo struggles to survive in this world, faced with constant threats. However, after a brutal encounter leaves his party and his life in danger, he is chosen by a mysterious System as its only player. This is a rare opportunity for Jinwoo to level up his abilities beyond known limits. Join Jinwoo on his journey as he faces increasingly stronger enemies, both human and monster, to uncover the secrets hidden within the dungeons and push his abilities to the ultimate extent. This epic adventure includes a prologue, making it a complete story with several chapters.
            """,
        genres: [
            Genre(
                id: "fantasy",
                name: "Fantasy",
                url: URL(string: "https://mangabats.com/genre/drama"),
                properties: GenreProperties(
                    icon: "sparkles",
                    colorHex: "#4B63D1"
                )
            ),
            Genre(
                id: "adventure",
                name: "Adventure",
                url: URL(string: "https://mangabats.com/genre/adventure"),
                properties: GenreProperties(
                    icon: "figure.hiking",
                    colorHex: "#FF8A34"
                )
            ),
        ],
        status: .completed,
        sourceID: "mangabats",
        latestChapter: "Chapter 1",
        statistics: MangaStatistics(
            views: 1022698103,
            rating: 4.615
        )
    )
    
    static let popularManga: [Manga] = [
        Manga(
            id: "solo-leveling",
            title: "Solo Leveling",
            thumbnailURL: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1735554741i/57989928.jpg"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        ),
        Manga(
            id: "omniscient-readers-viewpoint",
            title: "Omniscient Reader's Viewpoint",
            thumbnailURL: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1696899289i/194805543.jpg"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        ),
        Manga(
            id: "tower-of-god",
            title: "Tower of God",
            thumbnailURL: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1653283653i/60653006.jpg"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        ),
        Manga(
            id: "versatile-mage",
            title: "Versatile Mage",
            thumbnailURL: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1519288444i/38719331.jpg"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        ),
        Manga(
            id: "the-beginning-after-the-end",
            title: "The Beginning After The End",
            thumbnailURL: URL(string: "https://m.media-amazon.com/images/M/MV5BMTIzNDFjY2QtZTY3NC00NzY0LWE5NjQtOGY1NjliMDY0YmE0XkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        )
    ]
    
    static let latestManga: [Manga] = [
        Manga(
            id: "the-extras-academy-survival-guide",
            title: "The Extra’s Academy Survival Guide",
            thumbnailURL: URL(string: "https://cdn.wuxiaworld.eu/original/the-extras-academy-survival-guide_cover_Oqe2tqB.jpg"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        ),
        Manga(
            id: "solo-max-level-newbie",
            title: "Solo Max Level Newbie",
            thumbnailURL: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1667961586i/63260525.jpg"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        ),
        Manga(
            id: "infinite-mage",
            title: "Infinite Mage",
            thumbnailURL: URL(string: "https://static.wikia.nocookie.net/infinite-mage/images/d/d4/The_Infinite_Mage_%28Webtoon%29.jpg/revision/latest/scale-to-width-down/536?cb=20250722222629"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        ),
        Manga(
            id: "leveling-with-the-gods",
            title: "Leveling With The Gods",
            thumbnailURL: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1656910151i/61389922.jpg"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        ),
        Manga(
            id: "the-great-mage-of-the-heros-party-reincarnates",
            title: "The Great Mage Of The Hero’s Party Reincarnates",
            thumbnailURL: URL(string: "https://i.pinimg.com/736x/03/85/6d/03856d8e2b1b257b252eaf981a8c31e6.jpg"),
            sourceID: "mangabats",
            latestChapter: "Chapter 1"
        )
    ]
}
