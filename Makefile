THIS_DIR = $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
DOCKER_CMD=docker
DOCKER=$(DOCKER_CMD) run --rm --label=jekyll --volume $(THIS_DIR):/srv/jekyll \
 		-v $(THIS_DIR)/.cache:/usr/local/bundle \
	  -p 127.0.0.1:4000:4000 jekyll/builder:stable

IGNORE_HREFS=""

build: install
	$(DOCKER) bundle exec jekyll build

serve: build
	$(DOCKER) -it bundle exec jekyll serve

new:
	$(DOCKER) bundle exec jekyll new /srv/jekyll/site

install:
	$(DOCKER) bundle install

gemfile.lock:
	$(DOCKER) bundle update

check: build
	$(DOCKER) bundle exec htmlproofer _site --allow-hash-href --url-ignore $(IGNORE_HREFS)

.PHONY: new serve build
