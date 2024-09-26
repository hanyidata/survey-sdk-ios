rm -rf build
mkdir build

# 打包模拟器
xcodebuild archive \
-workspace Example/surveySDK.xcworkspace \
-scheme HYSurveySDK \
-destination "generic/platform=iOS Simulator" \
-archivePath build/simulator.xcarchive \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


# 打包真机
xcodebuild archive \
-workspace Example/surveySDK.xcworkspace \
-scheme HYSurveySDK \
-destination "generic/platform=iOS" \
-archivePath build/ios.xcarchive \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild -create-xcframework \
-framework build/ios.xcarchive/Products/Library/Frameworks/surveySDK.framework/ \
-framework build/simulator.xcarchive/Products/Library/Frameworks/surveySDK.framework/ \
-output build/surveysdk.xcframework
