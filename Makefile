PROJECT_NAME := $(shell basename $(shell pwd))
PROJECT_VER  ?= $(shell git describe --tags --always --abbrev=0)
PROJECT_VER_TAGGED  := $(shell git describe --tags --always --abbrev=0)


delete-tag:
	git push --delete origin $(version)  && git tag -d $(version)

release:
	git tag -a -m "$(message)" $(version)
	git push --follow-tags