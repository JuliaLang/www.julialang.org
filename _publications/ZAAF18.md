---
title: "Autonomous Parking Using Optimization-Based Collision Avoidance"
authors:
 - Xiaojing Zhang
 - Alexander Liniger
 - Atsushi Sakai
 - Francesco Borrelli
year: 2018
booktitle: "2018 IEEE Conference on Decision and Control (CDC)"
publisher: "IEEE"
doi: "10.1109/CDC.2018.8619433"
link: https://ieeexplore.ieee.org/document/8619433
packages:
  H-OBCA: https://github.com/XiaojingGeorgeZhang/H-OBCA
---
We present an optimization-based approach for autonomous parking. Building on recent advances in the area of optimization-based collision avoidance (OBCA), we show that the autonomous parking problem can be formulated as a smooth non-convex optimization problem. Unfortunately, such problems are numerically challenging to solve in general and require appropriate warm-starting. To address this limitation, we propose a novel algorithm called Hierarchical OBCA (H-OBCA). The main idea is to first use a generic path planner, such as Hybrid A*, to compute a coarse trajectory using a simplified vehicle model and by discretizing the state-input space. This path is subsequently used to warm-start the OBCA algorithm, which optimizes and smoothens the coarse path using a full vehicle model and continuous optimization. Our studies indicate that the proposed H-OBCA parking algorithm combines Hybrid A*'s global path planning capability with OBCA's ability to generate smooth, collision-free, and dynamically feasible paths. Extensive simulations suggest that the proposed H-OBCA algorithm is robust and admits realtime parking for autonomous vehicles. Sample code is provided at https://github.com/XiaojingGeorgeZhang/H-OBCA.
