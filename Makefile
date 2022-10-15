.PHONY: docs clean resolve test

clean:
	@xcodebuild clean -scheme Stilleben -destination generic/platform=iOS
resolve:
	@xcodebuild -resolvePackageDependencies
docs: 
	@make clean
	@make resolve
	@xcodebuild docbuild -scheme Stilleben \
    -destination generic/platform=iOS \
    OTHER_DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path Stilleben --output-path docs"

test:
	@make clean
	@make resolve
	@rm -rf TestResults.xcresult
	@xcodebuild -scheme Stilleben \
	-destination "platform=iOS Simulator,name=iPhone 14" \
	-sdk iphonesimulator \
	-resultBundlePath TestResults.xcresult \
	-enableCodeCoverage YES \
	test | xcbeautify
	