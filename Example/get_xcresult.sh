#!/bin/bash

xcodebuild \
  -list \
  -project SampleApp/SampleApp.xcodeproj  

xcodebuild \
  test \
  -project SampleApp/SampleApp.xcodeproj \
  -scheme SampleAppTests \
  -resultBundlePath TestsResult.xcresult \
  -collect-test-diagnostics=never \
  -destination 'platform=iOS Simulator,name=iPhone 13' 
