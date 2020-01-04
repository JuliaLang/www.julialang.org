To add a publication to the website, create a markdown file with YAML frontmatter in this directory. By convention, the file is named according to the author initials + year, e.g. _publications/ABC17.md.

The frontmatter is sort of a YAML version of bibtex (but using unicode instead of TeX).

The following fields are required:
- title: the name of the paper
- authors: the list of the authors. Note that this should be a YAML list, not "and" separated like bibtex
- year

The format will also make use of the following fields:
- journal
- booktitle
- volume
- issue
- pages: ranges should be separated by double hyphens (--)
- doi
- pmid
- arxiv: should be of the form XXXX.YYYYY
- link: a generic URL, should only be used if it points to a different location than the other identifiers
- packages: a yaml map of package names to package URLs which the paper is about.

The abstract of the publication can go below the frontmatter. This isn't used at the moment, but may be in future.