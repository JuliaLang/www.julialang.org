If you would like to suggest a publication to be listed here,

1. Edit `julia.bib` and create a new BibTeX entry.
   We recommend that the citation key be the initials of every author followed by the last two digits of the year, plus
   an extra lowercase letter if necessary for disambiguation.
   If you use [BibDesk](http://bibdesk.sourceforge.net/), be sure to strip out all the extra fields that it adds!
   
   Example:
   
   ```
    @incollection{H48,
      author = {Robert Herrick},
      title = {His Request to {Julia}},
      booktitle = {Hesperides: Or, The Works Both Humane \& Divine of Robert Herrick Esq.},
      year = {1648},
      volume = {1},
      number = {59},
      pages = {23},
    }
   ```

2. Edit `_EDIT_ME_index.md` and add the citekey (`[@H48]` in this example) to the relevant section.

3. Submit a new [pull request](https://github.com/JuliaLang/julialang.github.com/pulls) and ask for help.

If you're feeling really ambitions and/or already have Pandoc and Jekyll installed, instead of step 3 you can do these:

4. Run `make` in the `publications` directory. You will need
   - [pandoc](http://johnmacfarlane.net/pandoc/) and
   - [pandoc-citeproc](https://github.com/jgm/pandoc-citeproc)
   installed.
   
   Be sure to check the output produced by `make`.

5. In the main directory, run `jekyll build` to make sure that the website builds correctly.
   You will need [Jekyll](http://jekyllrb.com/) installed.

6. Submit a new [pull request](https://github.com/JuliaLang/julialang.github.com/pulls).
