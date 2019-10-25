# Building

I'm using Cocoapods for now but once this project switches to Xcode 11, will probably just switch out to SPM. I'm just using the simplest solution possible for now.

    gem install cocoapods
    pod install
    # ... wait like for a long time

    ## when that day comes you want to uninstall Coacoapods
    gem install cocoapods-deintegrate cocoapods-clean
    pod deintegrate
    pod clean
    rm Podfile

# Android app

I gave a talk at [Mobilization IX](https://twitter.com/mobilizationpl/status/1184008559157219328?s=20) showing how we can use the same concepts across Android too. [You can take a look at the Android app here](https://github.com/kaushikgopal/movies-usf-android/).
