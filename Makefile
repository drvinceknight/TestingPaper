NOTEBOOKS=$(filter-out combined.ipynb %.nbconvert.ipynb,$(wildcard *.ipynb))

HTMLS=$(NOTEBOOKS:.ipynb=.html)

EXECUTED=$(NOTEBOOKS:.ipynb=.nbconvert.ipynb)

default: testing.pdf

%.html: %.nbconvert.ipynb Makefile jekyll.tpl
	ipython nbconvert --to html  --template jekyll.tpl --stdout $< > $@

%.nbconvert.ipynb: %.ipynb
	ipython nbconvert --to notebook --ExecutePreprocessor.timeout=120 --execute --stdout $< > $@

testing.pdf: combined.ipynb Makefile latex.tplx
	ipython nbconvert --to pdf --template latex.tplx $<
	mv combined.pdf testing.pdf

combined.ipynb: $(EXECUTED)
	python nbmerge.py $^ $@

testing.tex: combined.ipynb Makefile
	ipython nbconvert --to latex --template latex.tplx $<
	mv combined.tex testing.tex

ready: $(HTMLS) testing.pdf

.PHONY: ready

site: ready
	jekyll build --verbose

preview: ready
	jekyll serve --verbose

clean:
	rm -f *.nbconvert.ipynb
	rm -rf combined*
	rm -f testing.pdf
	rm -f testing.tex
