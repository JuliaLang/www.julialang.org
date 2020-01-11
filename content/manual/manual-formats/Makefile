# General settings
PANDOC = pandoc
TARGET = julia-manual
LITTER = $(TARGET).aux $(TARGET).out $(TARGET).log $(TARGET).pdf $(TARGET).tex \
		$(TARGET).toc $(TARGET).texi $(TARGET).info

# PDF generation settings
PDFLAGS_LATEX = --toc -V title="The Julia Manual" --template=latex.template -N -s -t latex
LATEX  = xelatex

# Texinfo settings.
PDFLAGE_TEXI = -s -t texinfo 
MAKEINFO = makeinfo --force

MDFILES = \
	../introduction/index.md \
	../getting-started/index.md \
	../integers-and-floating-point-numbers/index.md \
	../mathematical-operations/index.md \
	../complex-and-rational-numbers/index.md \
	../strings/index.md \
	../functions/index.md \
	../control-flow/index.md \
	../variables-and-scoping/index.md \
	../types/index.md \
	../methods/index.md \
	../constructors/index.md \
	../conversion-and-promotion/index.md \
	../arrays/index.md \
	../running-external-programs/index.md \
	../metaprogramming/index.md \
	../parallel-computing/index.md \
	../calling-c-and-fortran-code/index.md \
	../standard-library-reference/index.md \
	../potential-features/index.md \
	../performance-tips/index.md

all: $(TARGET).pdf $(TARGET).info

$(TARGET).pdf: $(MDFILES)
	pandoc $(PDFLAGS_LATEX) $(MDFILES) -o $(TARGET).tex
	sed -i '/^\\begin{center}/,/^\\\\/d' $(TARGET).tex     # Rube Goldberg would be proud.
	sed -i '/^\\\\/,/\\end{center}/d' $(TARGET).tex
	sed -i 's/^title: \(.*\)/\\section{\1}/' $(TARGET).tex
	$(LATEX) $(TARGET).tex
	$(LATEX) $(TARGET).tex  # To get the TOC in.

$(TARGET).info: $(MDFILES)
	pandoc $(PDFLAGS_TEXI) $(MDFILES) -o $(TARGET).texi
	$(MAKEINFO) --force $(TARGET).texi

clean:
	rm -f $(LITTER)
