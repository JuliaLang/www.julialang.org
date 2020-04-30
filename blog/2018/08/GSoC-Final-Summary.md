@def rss_pubdate = Date(2018, 8, 6)
@def rss = """ GSoC 2018: Reinforcement Learning and Generative models using Flux | In this post I'm going to briefly summarize about the machine learning models I have worked on during this summer for GSoC. I worked towards enriching model zoo of Flux.jl (https://github.com/FluxML), a machine learning library written in Julia (https://github.com/JuliaLang/julia). My project cover... """
@def published = "6 August 2018"
@def title = "GSoC 2018: Reinforcement Learning and Generative models using Flux"
@def authors = """ <a href="https://github.com/tejank10">Tejan Karmali</a>"""  

Hello, world!

In this post I'm going to briefly summarize about the machine learning models I have worked on during this summer for GSoC. I worked towards enriching model zoo of [Flux.jl](https://github.com/FluxML), a machine learning library written in [Julia](https://github.com/JuliaLang/julia). My project covered Reinforcement Learning and computer vision models.

The project is spread over these 4 codebases
1. [Flux-baselines](https://github.com/tejank10/Flux-baselines)
2. [AlphaGo.jl](https://github.com/tejank10/AlphaGo.jl)
3. [GAN models](https://github.com/tejank10/model-zoo/tree/GAN)
4. [DNI model](https://github.com/tejank10/model-zoo/tree/DNI)

In the process, I could achieve most of my targets. I had to skip a few of them, and also made some unplanned models. Below, I discuss about these issues repository wise.

## 1. Flux Baselines

[Flux-baselines](https://github.com/tejank10/Flux-baselines) is a collection of various Deep Reinforcement Learning models. This includes Deep Q Networks, Actor-Critic and DDPG.

Basic structure of an RL probem is as folowd: There is an environment, let's say game of pong is our environment. The environment may contain many ojects which interact with each other. In pong there are 3 objects: a ball and 2 paddles. The environment has a *state*. It is the current situation present in the environment in terms of various features of the objects in it. These features could be position, velocity, color etc. pertaining to the objects in the it. An actions needs to be chosed to play a move in the environment and obtain the next state. Actions will be chosen till the game ends. An RL model basically finds the actions that needs to be chosen.

Over past few years, deep q learning has gained  lot of popularity. After the paper by Deep Mind about the Human level control sing reinforcement learning, there was no looking back. It combined the advanced in RL as well as deep learning to get an AI player which had superhuman performance. I made the basic [DQN](https://github.com/tejank10/Flux-baselines/blob/master/dqn/dqn.jl) and [Double DQN](https://github.com/tejank10/Flux-baselines/blob/master/dqn/double-dqn.jl) during the pre-GSoC phase, followed by [Duel DQN](https://github.com/tejank10/Flux-baselines/blob/master/dqn/duel-dqn.jl) in the first week on GSoC.

The idea used in the [A2C model](https://github.com/tejank10/Flux-baselines/blob/master/actor-critic/a2c.jl) is different from the one in DQN. A2C falls in the class of "Actor-Critic" models. In AC models we have 2 neural networks, policy network and value network. policy network accepts the state of the game and returns a probability distribution over the action space. Value Nework takes the state and action chosen using policy network as input and determines how suitable is that action for that state.

[DDPG](https://github.com/tejank10/Flux-baselines/tree/master/ddpg) is particularly useful when the actions which needs to be chosed are spread over a continuous space. one possible solution you may have in mind is that what if we discretize the action space? If we discretize it narrowly we end up with a large number of actions. If we discretize it sparsely then we lose important data.

~~~
<img src="https://raw.githubusercontent.com/tejank10/tejank10.github.io/master/assets/ddpg.png" alt="DDPG"/>
~~~

DDPG: Score vs Episodes

Some of these models have been deployed on Flux's [website](https://fluxml.ai/experiments). [CartPole example](https://fluxml.ai/experiments/cartPole/) has been trained on Deep Q Networks. An Atari-Pong example will also be added in a few days. It is trained on Duel-DQN. [Here](https://www.youtube.com/watch?v=L3pqMUDVrT0) is a demo of Pong trained using Flux.

#### Targets achieved

1. [Advantage Actor-Critic](https://github.com/tejank10/Flux-baselines/blob/master/actor-critic/a2c.jl)
2. [Duel DQN](https://github.com/tejank10/Flux-baselines/blob/master/dqn/duel-dqn.jl)

#### Extra mile

1. [DDPG](https://github.com/tejank10/Flux-baselines/tree/master/ddpg)
2. [Prioritized DQN](https://github.com/tejank10/Flux-baselines/blob/master/dqn/prioritized-replay-dqn.jl)

#### Future Work

1. Add more variety of models, especially the ones which have come up in the last 18 months.
2. Create an interface to easily train and test any environment from [OpenAIGym.jl](https://github.com/JuliaML/OpenAIGym.jl).

## 2. AlphaGo.jl

[AlphaGo.jl](https://github.com/tejank10/AlphaGo.jl)

This mini-project of the GSoC phase 2 was the most challenging part. AlphaGo Zero is a breakthrough AI by Google DeepMind. It is an AI to play Go, which is considered to be one of most challeenging games in the world, mainly  due to number of states it can lead to. AlphaGo Zero defeated the best Go player in the world. AlphaFo.jl's objective is achieve the results produced by AlphaGo Zero algorithm over Go, and achieve similar results on any zero-sum game.

Now, we have a package to train AlphaGo zero model in Julia! And it is really simple to train the model. We just have to pass the training parameters, the environment on which we want to train the model and then play with it.
For more info in the AlphaGo.jl refer to the [blog post](https://tejank10.github.io/jekyll/update/2018/07/08/GSoC-Phase-2.html).

#### Targets achieved

1. Game of Go
2. Monte Carlo tree search

#### Targets couldn't achieve

1. Couldn't train the model well

#### Extra Mile

1. Game of Gomoku to test the algorithm (since it is easier game)

#### Future work

1. Train a model on any game
2. AlphaChess

## 3. Generative Adversarial Networks

[Generative Adversarial Networks](https://github.com/tejank10/model-zoo/tree/GAN/vision/mnist)

GANs have been extremely suceessful in learning the underlying representation of any data. By doing so, it can reproduce some fake data. For example the GANs trained on MNIST Human handwritten digits dataset can produce some fake images which look very similar to those in the MNIST. These neural nets have great application in image editing. It can remove certain features from the image, add some new ones; depending on the dataset. The GANs contain of two networks: generator and discriminator. Generator's objective os to generate fake images awhereas the discriminator's objective is to differentiate between the fake images generted by thhe generator and the real images in the  dataset.  

~~~
<img src="https://raw.githubusercontent.com/tejank10/tejank10.github.io/master/assets/lsgan.gif" alt="LSGAN" width="170px"/>
<img src="https://raw.githubusercontent.com/tejank10/tejank10.github.io/master/assets/dcgan.gif" alt="DCGAN" width="170px"/>
<img src="https://raw.githubusercontent.com/tejank10/tejank10.github.io/master/assets/giphy.gif" alt="WGAN" width="170px"/>
<img src="https://raw.githubusercontent.com/tejank10/tejank10.github.io/master/assets/made.gif" alt="MADE" width="170px"/>

<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LSGAN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DCGAN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WGAN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MADE
~~~

#### Targets acheived

1. [`ConvTranspose` layer](https://github.com/FluxML/Flux.jl/pull/311)
2. [DCGAN](https://github.com/tejank10/model-zoo/blob/GAN/vision/mnist/dcgan.jl)

#### Extra Mile

1. [LSGAN](https://github.com/tejank10/model-zoo/blob/GAN/vision/mnist/lsgan.jl)
2. [WGAN](https://github.com/tejank10/model-zoo/blob/GAN/vision/mnist/wgan.jl)

#### Future work

1. More models of GAN like infoGAN, BEGAN, CycleGAN
2. Some cool animations with GANs
3. Data pipeline for training and producing images with dataset, and GAN type as input.

## 4. Decoupled Neural Interface

[Decoupled Neural Interface](https://github.com/tejank10/model-zoo/tree/DNI/vision/mnist/dni.jl) is a new technique to train the model. It does not use the backpropagation from the output layer right upto the input layer. Instead it uses a trick to "estimate" the gradient. It has a small linear layer neural network to predict the gradients, instead of running the backpropagation rather than finding the true gradients. The advantage of such a model is that it can be parallelized. This technique results in slight dip in the accuracy, but we have improved speed if we have parallelized the layers in the network.

~~~
<img src="https://raw.githubusercontent.com/tejank10/tejank10.github.io/master/assets/loss.png" alt="loss" width="362.5px"/>
<img src="https://raw.githubusercontent.com/tejank10/tejank10.github.io/master/assets/acc.png" alt="loss" width="362.5px"/>
~~~

#### Targets achieved:
- [DNI model](https://github.com/tejank10/model-zoo/tree/DNI/vision/mnist/dni.jl)

## Conclusion

During the past three months, I learn a lot about Reinforcement Learning and AlphaGo in particular. I experienced training an RL model for days, finally saw it working well! I encountered the issues faced in training the models and learnt to overcome them. All in all, as an aspiring ML engineer these three months have been the most productive months. I am glad that I could meet most of my objectives. I have worked on some extra models to make up for the objectives I could not meet.

## Acknowledgements

I really would like to thank my mentor [Mike Innes](https://github.com/MikeInnes) for guiding me throughout the project, and [James Bradbury](https://github.com/jekbradbury) for his valuable inputs for improving the code in the Reinforcement Learning models. I also would like to thank [Neethu Mariya Joy](https://github.com/roboneet) for deploying the trained models on the web. And last but not the least, The Julia Project and NumFOCUS: for sponsoring me and all other JSoC students for JuliaCon'18 London.
