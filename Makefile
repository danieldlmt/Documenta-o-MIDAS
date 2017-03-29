all: test

test: RT-PGCOMP-Modelo2014.bbl RT-PGCOMP-Modelo2014.dvi RT-PGCOMP-Modelo2014.pdf

%.dvi: %.tex pgcomprt.sty 
	latex $<

%.pdf: %.tex pgcomprt.sty 
	pdflatex $<

%.bbl  : %.aux
	bibtex $<

%.aux : %.tex
	latex $<

dist: $(TARBALL)

$(TARBALL): pgcomprt.sty abntex2-alf.bst
	tar czf $(TARBALL) $^

index.html: README.md
	(pandoc -s -f markdown -t html $< | sed -e 's/##VERSION##/$(VERSION)/g' > $@) || ($(RM) $@; false)

upload: $(TARBALL) index.html RT-PGCOMP-Modelo2014.tex .htaccess
	rsync -avp $^ $(UPLOAD_TO)

clean:
	$(RM) $(TARBALL)
	$(RM) *.aux *.lof *.log *.lot *.toc *.out RT-PGCOMP-Modelo2014.pdf RT-PGCOMP-Modelo2014.dvi
	$(RM) index.html
