# TourDeWorld

## App Overview
TourDeWorld is an iOS App which takes User around the World on a photographic journey. 
User can Tap and Hold at any place on the Map to drop a pin and can then tap that pin to view images geo tagged for that location.
The app locally store already downloaded images to save User from costly network call. 

## Components

1. A Networking Layer which separate UI from Networking Code
2. Core Data Stack which handle all code related to saving, fetching and deleting of managed Objects in and out of persistent storage
3. View Controllers to manage all User interaction.
  1. MapViewController: Manage user interaction on Map View.
  2. ImageViewController: Interact with Networking Layer to download images from Flickr
  3. PreferenceViewController: Modal View Controller where user can manage his preferences.
4. Model Layer to manage App Data. This layer is responsible for modelling the json response into managed objects and then manage those objects into persistent store.

## How to use the code

To checkout and use this repository follow steps as listed below:
```
$ git clone https://github.com/pritamhinger/TourDeWorld.git
$ cd TourDeWorld
```

Double click **TourDeWorld.xcodeproj** or open the project in Xcode

## License

`TourDeWorld` is released under an [MIT License] (https://opensource.org/licenses/MIT). See `License` for details
