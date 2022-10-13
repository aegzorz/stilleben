.PHONY: docs clean

clean:
	@xcodebuild clean -scheme Stilleben -destination generic/platform=iOS

docs: 
	@make clean
	@xcodebuild docbuild -scheme Stilleben \
    -destination generic/platform=iOS \
    OTHER_DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path Stilleben --output-path docs"

test:
	@make clean
	@rm -rf TestResults.xcresult
	@xcodebuild -scheme Stilleben \
	-destination "platform=iOS Simulator,name=iPhone 14" \
	-sdk iphonesimulator \
	-resultBundlePath TestResults.xcresult \
	-enableCodeCoverage YES \
	test | xcbeautify
	