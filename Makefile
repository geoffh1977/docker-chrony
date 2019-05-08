# Project Makefile
$(shell sed -e 's/^---$$//g; s/^#.*$$//g; /^$$/d; s/:[^:\/\/]/="/g; s/$$/"/g; s/ *=/=/g' config.yml > /tmp/config.vars)
include /tmp/config.vars

.PHONY: all release dockerfile docs build update-version update-repo run clean clean-files clean-all

all: dockerfile build docs

release: dockerfile docs gitignore-delete update-repo clean-files

dockerfile:
	rm -f Dockerfile
	docker run --rm -v $(shell pwd):/project geoffh1977/jinja2 j2 -f yaml -o Dockerfile templates/Dockerfile.j2 config.yml

docs:
	rm -f README.md
	docker run --rm -v $(shell pwd):/project geoffh1977/jinja2 j2 -f yaml -o README.md templates/README.md.j2 config.yml
	[ ! -z ${license} ] && rm -f LICENSE.md && curl -s -o LICENSE.md https://raw.githubusercontent.com/IQAndreas/markdown-licenses/master/${license}.md

build:
	docker build -t ${dockerUser}/${finalImageName}:${finalImageVersion} .

update-repo:
	scripts/update_repo.sh

gitignore-delete:
	rm -f .gitignore

run:
	$(call colors)
	@echo -e Starting Container...
	@docker run -it --rm --name ${finalImageName} ${dockerUser}/${finalImageName}:${finalImageVersion}
	@echo -e Container Stopped

clean:
	docker rmi -f ${dockerUser}/${finalImageName}:${finalImageVersion}
	rm -f /tmp/config.vars

clean-files:
	rm -f README.md LICENSE.md Dockerfile

clean-all: clean clean-files
