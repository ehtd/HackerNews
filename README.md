HackerNews
==========

A cross-platform Hacker News Reader. 

Makes use of Hacker News Firebase API to display:
- Top
- New `(//: TODO)`
- Ask `(//: TODO)`
- Show `(//: TODO)`
- Jobs `(//: TODO)`

A `Java Core` is shared among all the platforms. Each platform is responsible of implementing its own UI.

## General Setup
The projects depend on [HNCore library](https://github.com/ehtd/HNCore). It is added as a submodule.

### First checkout
1. Initialize submodules:

```git submodule init```

2. Update submodules:

```git submodule update```

## Android Setup
Once submodules are initialized and updated, open the project with [Android Studio](https://developer.android.com/studio/index.html). The project uses Gradle and should sync the project automatically.

## iPhone Setup
iOS project requires [J2ObjC](https://developers.google.com/j2objc/) to be able to build the project. 

1. Initialize and update submodules.
2. Follow https://developers.google.com/j2objc/guides/getting-started to download the latest Release or download the Sources and build it.
3. In: `Config.xcconfig` update the `J2OBJC_HOME` to your J2ObjC path.

Notes:
- The iOS project relies on `java sources build rules`. When a `build / run` is triggered the java sources generate the `.h/.m` files required.

