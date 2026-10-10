# Event-chain Monte Carlo methods – Summer of Code

## Massive parallel factorized bouncy particle sampler

At JuliaCon 2021 a new sampler Monte Carlo method (for example as sampling algorithm for the posterior in Bayesian inference) was 
introduced [1]. The method exploits the factorization structure to sample *a single* continuous time Markov chain targeting a joint distribution
in parallel. In contrast to parallel Gibbs sampling in the method at no time a subset of coordinates is kept fixed. In Gibbs sampling keeping 
a subset fixed is the main device to achieve massive parallelism: given a separating set of coordinates, the conditional posterior
factorizes into independent subproblems. In the presented method, a particle representing a parameter vector sampled from the posterior never 
ceases to move, and it is only the decisions about changes of the direction of the movement which happen in parallel on subsets of coordinates.

There are already two implementations available which make use of Julias multithreading capabilities. Starting from that, the contributor 
implements a version of the algorithm using GPU computing techniques as the methods is are suitable for these approaches.

**Expected Results**: Implement massive parallel factorized bouncy particle sampler [1,2] using GPU computing.

**Recommended Skills**: GPU computing, Markov processes, Bayesian inference.

**Mentors**: [Moritz Schauer](https://github.com/mschauer)

**Rating**: Hard, 350 hours

[1] Moritz Schauer: ZigZagBoomerang.jl - parallel inference and variable selection. JuliaCon 2021 contribution [https://pretalx.com/juliacon2021/talk/LUVWJZ/], Youtube: [https://www.youtube.com/watch?v=wJAjP_I1BnQ], 2021.

[2] Joris Bierkens, Paul Fearnhead, Gareth Roberts: The Zig-Zag Process and Super-Efficient Sampling for Bayesian Analysis of Big Data. The Annals of Statistics, 2019, 47. Vol., Nr. 3, pp. 1288-1320. [https://arxiv.org/abs/1607.03188].
