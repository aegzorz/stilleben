docs: 
	@xcodebuild docbuild -scheme Stilleben \
    -destination generic/platform=iOS \
    OTHER_DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path Stilleben --output-path docs"