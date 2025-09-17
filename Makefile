container = athornton/export-org:latest

.PHONY: help
help:
	@echo "Make targets for export-org rubin-talk"
	@echo "make pdf - Make PDF of rubin-talk"
	@echo "make reveal - Make Reveal.js version of rubin-talk"
	@echo "make site - Make Reveal.js website directory"
	@echo "make clean - Remove artifacts"

.PHONY: docker-container
docker-container:
	docker run --rm $(container) /bin/true || \
	docker buildx build -t $(container) .

rubin-talk.pdf: rubin-talk.org docker-container
	./exporter.sh pdf rubin-talk.org

rubin-talk.html: rubin-talk.org docker-container
	./exporter.sh html rubin-talk.org

pdf: rubin-talk.pdf

html: rubin-talk.html

site: pdf html
	@mkdir -p ./site/assets
	@mkdir -p ./site/css
	cp rubin-talk.html ./site/index.html
	cp rubin-talk.pdf ./site/rubin-talk.pdf
	cp -rp css ./site
	cp -rp assets ./site

clean:
	-@rm -rf ./site
	-@rm -f ./rubin-talk.html
	-@rm -f ./rubin-talk.pdf
	-@rm -f ./rubin-talk.tex
	-@docker rmi athornton/export-org

