# PokemonCards - SwiftUI + Composable Architecture Example 

This repository has a small example using the [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture) and the [Pokemon TGC API](https://pokemontcg.io)
This small example also inspired [This](https://github.com/pointfreeco/swift-composable-architecture) Coletiv Blog post 

## 🚧 Dependencies

- [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture) (`~> 0.9.0`)
- [Kingfisher](https://github.com/onevcat/Kingfisher) (`~> 5.15.8`)
- [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) (`~> 1.8.2`)

## 🏎 Kickstart

### Initial setup

1. Install [SwiftLint](https://github.com/realm/SwiftLint) `brew install swiftlint`
2. Install [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) pre-commit hook following [this](https://github.com/nicklockwood/SwiftFormat#git-pre-commit-hook)
    - If you are using the SourceTree client please also follow [this link](https://github.com/typicode/husky/issues/390#issuecomment-577008221)
3. Use the `.xcodeproj` file to open the Xcode project
4. Go to the `.xconfig` files under `PokemonCards/Resources/Configs` and insert your API Key on `API_KEY` var. You can get yours from the [Pokemon TGC](https://dev.pokemontcg.io/) website.