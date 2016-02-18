all:
	@#Requires pandoc and pandoc-citeproc installed, e.g. with cabal
	PATH=$(PATH):~/.cabal/bin pandoc --reference-links -s -S --biblio julia.bib --csl jlwebpage.csl -o index_new.html _EDIT_ME_index.md
	@#Horrible hacks to insert vertical whitespace for abstracts
	@sed -i.bak -e "s/<em>Abstract:/<p><blockquote><em>Abstract:/g" index_new.html
	@sed -i.bak -e "s/<\/span>/<\/blockquote><\/p><\/span>/g" index_new.html
	@#Pipe Jekyll header into new file
	@head -5 _EDIT_ME_index.md > index_new.md
	@#Delete HTML header
	@sed -i.bak -e "1,13d" index_new.html
	@#Delete last 5 lines
	@sed -i.bak -e :a -e "1,5!{P;N;D;};N;ba" index_new.html
	@cat index_new.md index_new.html > index.md
	@rm -f index_new.md index_new.html *.bak

