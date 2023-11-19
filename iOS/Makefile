generate:
	tuist fetch
	TUIST_ROOT_DIR=${PWD} tuist generate

feature:
	chmod +x Scripts/create_feature_module.sh
	@./Scripts/create_feature_module.sh
	tuist edit

test:
	tuist clean
	tuist fetch
	TUIST_ROOT_DIR=${PWD} tuist test

build:
	TUIST_ROOT_DIR=${PWD} tuist build

clean:
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
