.PHONY: init test deploy clean

REPO_NAME    = stav.hugo
REPO_URI    := git@github.com:stav/$(REPO_NAME).git
REPO_REMOTE := $(shell git remote)
RENDER_DIR  := ~/Work/Hugo/stav.github.io

init:
	@echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	@echo ~Initializing
ifeq ($(strip $(REPO_REMOTE)),)
	@echo Remote is empty
else
	-git remote rm origin
endif
	git remote add origin $(REPO_URI)
	git fetch
	git branch --set-upstream-to=origin/master master

test:
	@echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	@echo ~Testing
	@echo Tests passed

clean:
	@echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	@echo ~Cleaning
	rm -rf ./public
	rm -rf $(RENDER_DIR)/*

publish:
	@echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	@echo ~Publishing
	cd $(RENDER_DIR) && git commit -a -m 'Deploy' && git push

deploy:
	@echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	@echo ~Deploying
	@make test
	@make clean
	hugo
	cp -r public/* $(RENDER_DIR)
	@make publish
	git push
