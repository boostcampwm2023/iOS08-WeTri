generate:
	tuist fetch
	TUIST_ROOT_DIR=${PWD} TUIST_SCHEME=DEBUG tuist generate

release:
	tuist fetch
	TUIST_ROOT_DIR=${PWD} TUIST_SCHEME=RELEASE tuist generate

feature:
	chmod +x Scripts/create_module.sh
	@./Scripts/create_module.sh Feature
	tuist edit

demo:
	chmod +x Scripts/create_module.sh
	@./Scripts/create_module.sh Demo
	tuist edit

ci:
	tuist clean
	tuist fetch
	TUIST_ROOT_DIR=${PWD} TUIST_CI=TRUE tuist test

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
