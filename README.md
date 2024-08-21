<p align="center">
  <img src="https://github.com/rokon-uddin/DevHub/blob/main/screenshots/logo.jpeg" alt="DevHub Logo" height="80" >
</p>

<p align="center">
  GitHub iOS client in SwiftUI, Composable, and Modular Architecture.
</p>

## Content
- [Screenshots](#screenshots)
- [Architecture Overview](#architecture-overview)
- [App Features](#app-features)
- [Technologies](#technologies)
- [Build Configurations](#build-configurations)

## Screenshots

<pre>
<img alt="trending_developer" src="https://github.com/rokon-uddin/DevHub/blob/main/screenshots/home.png?raw=true" width="250">&nbsp; <img alt="developer_detail" src="https://github.com/rokon-uddin/DevHub/blob/main/screenshots/repos.png?raw=true" width="250">&nbsp; <img alt="repository_detail" src="https://github.com/rokon-uddin/DevHub/blob/main/screenshots/repo.png?raw=true" width="250">&nbsp; <img alt="profile_summary" src="https://github.com/rokon-uddin/DevHub/blob/main/screenshots/summary.png?raw=true" width="250">&nbsp;</pre>

## Architecture Overview

The app is structured using a Clean Architecture to promote modularity, maintainability, and testability.

<p align="center">
    <img alt="Clean Architecture" src="https://github.com/rokon-uddin/DevHub/blob/main/screenshots/clean.jpeg?raw=true" height="640">
</p>

### Presentation Layer
* **Purpose:** This layer is responsible for rendering the user interface (UI) and handling user interactions. It uses SwiftUI to build views and the Composable Architecture (TCA) for state management.

* **Responsibilities:**
	* UI Rendering: Displays the product title, description, and interactive buttons.
	* User Input: Captures button taps and other user interactions.
	* State Management (TCA): Manages the application state.
	* Navigation: Handles transitions between screens (e.g., showing a sheet or full-screen cover).
	
### Domain Layer
* **Purpose:** This layer contains the core business logic and models of the application. It defines how data is structured. Additionally, it defines repository protocols to create an abstraction for data access.

* **Responsibilities:**
	* Business Logic: Implements the rules and operations that define the core functionality of the app.
	* Data Modeling: Defines the structure of the Product data and other entities relevant to the domain.
	* Use Cases: Defines abstract interactions with the domain (e.g., ProductUseCase for fetching a product).
	* Repository Protocols: Defines interfaces for interacting with data sources. These protocols act as contracts, specifying the operations (e.g., read, create, update) that the data access layer must implement. This separation of concerns keeps the domain layer clean and independent of specific data access technologies.

### Data Access Layer
* **Purpose:** This layer handles the communication with external data sources, such as remote APIs or local databases. It implements the repository protocols defined in the domain layer.

* **Responsibilities:**
	* Data Retrieval: Fetches product data from a remote API.
	* Networking: Manages network requests, error handling, and authentication.
	* Data Mapping: Translates data between the format used by the data source and the domain models.
	* Repository Implementations: Provides concrete implementations of the repository protocols, defining how data is retrieved or stored.


## App Features
- [x] Browse trending developer
- [x] See developer detail
- [x] Search developer repositories
- [x] Open repo in Browser
- [x] View developer profile summary
- [x] Support Dark Appearance

## Technologies
- [x] The Composable Architecture ([TCA](https://github.com/pointfreeco/swift-composable-architecture))
- [x] REST API v3 ([Moya](https://github.com/Moya/Moya))
- [x] SwiftUI, [SwiftUI](https://developer.apple.com/xcode/swiftui/), Structure Concurrency [concurrency](https://developer.apple.com/documentation/swift/concurrency/) and [Combine](https://developer.apple.com/documentation/combine)
- [x] Dependency injection ([swift-dependencies](https://github.com/pointfreeco/swift-dependencies))
- [x] Add UITests
- [x] Add SnapshotTests

## Build Configurations
DevHub uses `.xcconfig` and `BuildConfiguration.plist` for managing environment-specific settings.

