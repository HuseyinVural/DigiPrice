# DigiPrice

DigiPrice is a fast test project for iOS platform that allows you to list coin pairs, manage your favorites, and view a 3-day chart for the selected coin.

This project is designed in accordance with the MVVM (Model-View-ViewModel) and SOLID principles and is suitable for future growth and scalability.

In this project, I have employed various software design patterns and techniques to achieve testability and maintainability. For instance, I have made use of interface separation/segregation and dependency injection to enable easy testing and flow management. I have also utilized the repository pattern to establish low coupling relations between high-level and lower-level classes.

To simplify screen flow manipulation, I adopted the Compositional Layout Injection technique. Moreover, by separating the DataSource and delegate methods of UIKit into distinct objects, I aimed to carry out testing independently of the UIViewController lifecycle.

I have also strived to balance time complexity and readability through my parse logics. In summary, my goal for this project was to deliver a testable, well-designed solution that meets all requirements. Of course, there are many different approaches one can take, but my focus remained on producing high-quality code.

## Attention
Since it is a lighter way solution and not affecting user interaction, the ```core-data``` object references are registered in the app's background, suspend, and interrupt cases.

If you are testing with the simulator, your favorites ```will not be recorded in the Xcode rebuild case```. This is an expected exception specific to the development environment.

<p align="center">
    <img src= "https://i.imgur.com/i5HmXM4.png" width="35%" >
    <img src= "https://i.imgur.com/jJm4lhR.png" width="35%" >
</p>


## Features

- [x] List coin pairs.
- [x] Manage your favorite coins.
- [x] View a 3-day chart for the selected coin.

## Requirements

- iOS 14.0+
- Xcode 14

## Libraries Used

- DigiPrice uses Charts and CryptoSwift libraries.

## Installation

1. Download or clone ```DigiPrice Repo```.  
2. Run with Xcode!  
