@def rss_pubdate = Date(2016, 9, 10)
@def rss = """ BioJulia 2016 - online sequence search, sequence demultiplexing, new readers and much more! | We are pleased to announce releasing... """
@def published = "10 September 2016"
@def title = "BioJulia 2016 - online sequence search, sequence demultiplexing, new readers and much more!"
@def authors = "Kenta Sato"  
@def hascode = true


We are pleased to announce releasing
[Bio.jl](https://github.com/BioJulia/Bio.jl) 0.4, a minor release including
significant functionality improvements as I promised in [the previous blog
post](/blog/2016/04/biojulia2016/).

The following features are added since the post:

* Online sequence search algorithms.
* Sequence data structure for reference genomes.
* Data reader and writer for the .2bit file format.
* Data reader and writer for the SAM and BAM file formats.
* Sequence demultiplexing tool.
* Package to handle BGZF files.

And many other miscellaneous performance and usability improvements!  Tutorial
notebooks are available at <https://github.com/BioJulia/BioTutorials>.  Here I
briefly introduce you to these new features one by one.

## Online sequence search algorithms

Sequence search is an indispensable tool in sequence analysis.  Since the last
post, I have added exact, approximate and regex search algorithms.  The search
interface of Bio.jl mimics that of Julia's standard library.

```
julia> using Bio.Seq

julia> seq = dna"ACAGCGTAGCT"
11nt DNA Sequence:
ACAGCGTAGCT

# Exact search.
julia> search(seq, dna"AGCG")
3:6

# Approximate search with one error or less.
julia> approxsearch(seq, dna"AGGG", 1)
3:6

# Regular expression search.
julia> search(seq, biore"AGN*?G"d)
3:6
```

## Sequence data structure for reference genomes

In Bio.jl DNA sequences are encoded using 4 bits per base by default in order to
store ambiguous nucleotides and this encoding does well in most cases. However,
some biological sequences such as chromosomal sequences are so long especially
for eukaryotic organisms and the default DNA sequences may result in a waste of
memory space. `ReferenceSequence` is a new type introduced in Bio.jl that
compresses positions of ambiguous nucleotides using a sparse bit vector. This
type can achieve almost 2-bit encoding in common reference sequences because
most of the ambiguous nucleotides are clustered in a sequence and the number of
them is small compared to other unambiguous nucleotides.

```
# Converting a DNASequence object to ReferenceSequence.
julia> ReferenceSequence(dna"ACGT"^10000)
40000nt Reference Sequence:
ACGTACGTACGTACGTACGTACGTACGTACGTACGTACG…CGTACGTACGTACGTACGTACGTACGTACGTACGTACGT

# Reading chromosome 1 of human from a FASTA file.
julia> open(first, FASTAReader{ReferenceSequence}, "hg38.fa")
Bio.Seq.SeqRecord{Bio.Seq.ReferenceSequence,Bio.Seq.FASTAMetadata}:
  name: chr1
  sequence: NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN…NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
  metadata: Bio.Seq.FASTAMetadata("")

julia> sequence(ans)
248956422nt Reference Sequence:
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN…NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
```

## Data reader and writer for the 2bit file format

2bit is a binary file format to store reference sequences. This is a kind of
binary counterpart of [FASTA](https://en.wikipedia.org/wiki/FASTA_format) but
specialized for DNA reference sequences to enable smaller file size and faster
loading. Reference sequences of various organisms are distributed from [the
download page of UCSC](https://hgdownload.soe.ucsc.edu/downloads.html) in this
file format. An important advantage of 2bit is that sequences are indexed by its
name and can be accessed immediately.

```
# Opening a sequence file of yeast (S.cerevisiae).
julia> reader = open(TwoBitReader, "sacCer3.2bit");

# Loading a chromosome VI using random access index.
julia> reader["chrVI"]
Bio.Seq.SeqRecord{Bio.Seq.ReferenceSequence,Array{UnitRange{Int64},1}}:
  name: chrVI
  sequence: GATCTCGCAAGTGCATTCCTAGACTTAATTCATATCTGC…GTGTGGTGTGTGGGTGTGGTGTGTGGGTGTGGTGTGTGG
  metadata: UnitRange{Int64}[]
```

## Data reader and writer for the SAM and BAM file formats

The SAM and BAM file formats are designed for storing sequences aligned to
reference sequences. SAM is a line-oriented text file format and easy to handle
with UNIX command line tools. BAM is a compressed binary version of SAM and
suitable for storing data in disks and processing with purpose-built softwares
like [samtools](https://samtools.github.io/). The BAM data reader is carefully
tuned so that users can use it in real analysis with large files. It is also
feasible to read a [CRAM](https://www.ebi.ac.uk/ena/software/cram-toolkit) file
combining the BAM reader and `samtools view` command.

An experimental feature is parallel processing using multiple threads.
Multi-threading support is introduced in Julia 0.5 and we use it to parallelize
decompression of BAM files. Here is a simple benchmark script to show how
much reading speed can be improved with multiple threads:

```
using Bio.Align

# Count the number of mapped records.
function countmapped(reader)
    ret = 0
    record = BAMRecord()
    while !eof(reader)
        # in-place reading
        read!(reader, record)
        if ismapped(record)
            ret += 1
        end
    end
    return ret
end

println(open(countmapped, BAMReader, ARGS[1]))
```

`JULIA_NUM_THREADS` environment variable controls the number of worker threads.
The result below shows that the elapsed time is almost halved using two threads:

```
~/.j/v/Bio $ time julia countmapped.jl SRR1238088.sort.bam
28040186
       29.27 real        28.64 user         0.66 sys
~/.j/v/Bio $ env JULIA_NUM_THREADS=2 time julia countmapped.jl SRR1238088.sort.bam
28040186
       17.40 real        32.31 user         0.63 sys
```

## Package to handle BGZF files

BGZF (Blocked GZip Format) is a gzip-compliant file format commonly used in
bioinformatics. BGZF can be read using standard gzip tools but files in the
format are compressed block by block and special metadata are added to index the
compressed files for random access. BAM files are compressed in this file format
and sequence alignments in a specific genomic region can be retrieved
efficiently.  BGZFStreams.jl is a new package to handle BGZF files like usual
I/O streams and it is built on top of our
[Libz.jl](https://github.com/BioJulia/Libz.jl) package. Parallel decompression
mentioned above is implemented in this package layer.

```
julia> using BGZFStreams

julia> stream = BGZFStream("/Users/kenta/.julia/v0.5/BGZFStreams/test/bar.bgz")
BGZFStreams.BGZFStream{IOStream}(<mode=read>)

julia> readstring(stream)
"bar"
```

~~~
<https://github.com/BioJulia/BGZFStreams.jl>
~~~

## Sequence demultiplexing tool

Sequence demultiplexing is a technique to distinguish the origin of a sequence
using its artificially-attached "barcode" sequence. This is often used at a
preprocessing phase after [multiplexed
sequencing](https://www.illumina.com/technology/next-generation-sequencing/multiplexing-sequencing-assay.html),
a common technique to sequence multiple samples simultaneously.  A barcode
sequence, however, may be corrupted due to sequencing error, and we need to find
the best matching barcode from a barcode set.  The demultiplexer algorithm
implemented in Bio.jl is based on a trie-like data structure, and efficiently
finds the optimal barcode from the prefix of a given DNA sequence.

```
# Set DNA barcode pool.
julia> barcodes = DNASequence["ATGG", "CAGA", "GGAA", "TACG"];

# Create a sequence demultiplexer that allows one errors at most.
julia> dplxr = Demultiplexer(barcodes, n_max_errors=1, distance=:hamming)
Bio.Seq.Demultiplexer{Bio.Seq.BioSequence{Bio.Seq.DNAAlphabet{4}}}:
  distance: hamming
  number of barcodes: 4
  number of correctable errors: 1

# Demultiplex a given sequence from its prefix.
julia> demultiplex(dplxr, dna"ATGGCGNT")  # 1st barcode with no errors
(1,0)

julia> demultiplex(dplxr, dna"CAGGCGNT")  # 2nd barcode with one error
(2,1)
```

## Next step

This is still the first half of my project this year. The next term will come
with:

* Supporting more file formats including GFF3, VCF and BCF.
* Integration with databases.
* Integration with genome browsers.

And, of course, improving existing features of Bio.jl and other packages. We
welcome any contributions and feature requests from you all.  [Gitter chat
channel](https://gitter.im/BioJulia/Bio.jl) is the best place to communicate
with developers and other users. If you love Julia and/or biology, any reason
not to join us?


## Acknowledgements

I gratefully acknowledge the Moore Foundation and the Julia project for
supporting the BioJulia project. I also would like to thank [Ben J. Ward](https://github.com/BenJWard) and [Kevin Murray](https://github.com/kdmurray91) for comments on my program code and other
contributions.
