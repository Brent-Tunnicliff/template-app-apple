fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android build

```sh
[bundle exec] fastlane android build
```

Build the project

### android tests

```sh
[bundle exec] fastlane android tests
```

Run unit tests

----


## iOS

### ios signing_get

```sh
[bundle exec] fastlane ios signing_get
```

Syncs the signing certificates and provisioning profiles

### ios signing_update

```sh
[bundle exec] fastlane ios signing_update
```

Sets the signing certificates and provisioning profiles

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
