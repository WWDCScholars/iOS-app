#!/bin/sh

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
    fastlane crashlytics
elif  [[ "$TRAVIS_BRANCH" == "beta" ]]; then
    fastlane testflight
elif  [[ "$TRAVIS_BRANCH" == "release" ]]; then
    fastlane appstore
fi
