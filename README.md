# YelpSearchApp

An iOS app built with Swift and SwiftUI that allows users to search for businesses using the Yelp Fusion API, favorite them for later, and view details inside the app or in Safari.

## Features

- Search businesses by keyword using Yelp Fusion API
- Autocomplete suggestions
- Infinite scrolling for results
- Favorite/unfavorite businesses
- View favorites with persistent local storage
- View business detail (in-app or via Safari)
- Reactive UI with clean architecture
- Unit tests for core components

## Technologies & Architecture

- **Swift** / **SwiftUI**
- **MVVM Architecture**
- **Combine** for reactivity
- **UserDefaults** for local persistence
- **URLSession** for networking
- **XCTest** for unit testing
- **Clean separation of concerns** using:
  - `Repositories` for data (API + local)
  - `ViewModels` for business logic
  - `Services` for API calls

## Run Tests
	- Press ⌘U to run the test suite
	- Or use the Test navigator in Xcode

## Test Coverage

### Includes tests for:
	- ViewModel business logic
	- Repository save/load flow
	- API stubbing via mocks