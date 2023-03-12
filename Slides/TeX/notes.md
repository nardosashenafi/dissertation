# TACON Slides

## Underactutated Control Problems
* Passivity-based control is a systematic approach for nonlinear control problems 
* This method is applicable to many types of systems, including a family of underactuated robots such as the simplified model of walking systems.

## Previous Methods (1/2)
* The main idea of PBC is to use the control authority such that the closed-loop system is rendered passive.
* The passive property of a dynamical system provides a way to infer stability in a transparent manner.  
* For underactuated robotic systems, this method requires a solution to a set of nonlinear partial differential equations.
* Obtaining this in closed-form is challenging, especially for systems with higher dimensional state space.
* Furthermore, PBC relies strongly on the knowledge of the system dynamics, and model uncertainties may negatively impact the performance of the controller

## Previous Methods (2/2)
* On the other hand, learning-based control designs are able to cope with uncertain (or even unknown!) dynamics.
* Reinforcement learning is one such example. 
* Here the control objective is to maximize an accumulated reward through repeated interactions with the environment.
* This method places utmost importance on generality and performance optimization at the expense of stability and safety.
* Furthermore, the amount of training data required to achieve a functional control law is often prohibitive.

## Our method {REREAD}
* In this work, we propose to leverage the strengths of both methods to formulate a systematic approach for control design of underactuated robotic systems
* We follow the PBC techniques for control synthesis and ease the burden of solving nonlinear PDEs using a learning-based framework
* The uncertainty of model parameters are addressed using Bayesian Neural Networks
* The framework is designed without any violations of the relevant physical constraints, preserving the passive property originally present in the PBC setting
* As a result, stability is an intrinsic property of our framework


## IDAPBC for Underactuated Mechanical System
* In particular, our method leverages the IDA-PBC approach, which begins by taking the Hamiltonian view to the system dynamics (shown on the left block)
* The Hamiltonian $H$ of a mechanical system is defined as the total energy (sum of kinetic and potential)
* In this setting, the main idea is to use the control authority $u$ to impose a port-Hamiltonian form on the closed-loop dynamics, such that the system is passive with respect to another (fictitious) Hamiltonian $H_d$
* For underactuated mechanical systems, determining $u$ requires a solution to the following PDEs (see slide):

## IDAPBC as an Optimization Problem {REREAD}
* We would like to obtain a solution without having to solve the PDEs in closed-form
* To this end, we formulate an optimization problem that achieves this objective 
* The objective function is defined as the squared-norm of the PDE constraint
* The problem is constrained by the positive definiteness of $M_d$, the skew-symmetry of $J_2$ and the $\argmin$ of $V_d$ at the desired equilibirum point $q^\star$
* In the paper, we rigorously show that as $J \to 0$ and the surrogates converge to a valid solution of the PDEs, the control law will steer the trajectories of the closed-loop system toward $x^\star$.
* We represent the solutions using stochastic neural networks as *surrogates*
* The stochasticity of the neural net parameters allows us to incorporate model uncertainties in the open-loop Hamiltonian $H$ and find the probability distributions for them accordingly.


## Addressing uncertainties via Bayesian inference {REREAD}
<!-- * We are handling system parameter uncertainties through the stochastic NN. -->
* But how do we ensure that stochastic controllers are more robust than deterministic controllers, which are parameterized by point estimates?
* To demonstrate the robustness properties of the Bayesian technique, we provide theoretical justification through this simple example. 
* The task at hand is to find an optimal control parameter $\theta^*$ for a linear dynamical system with limited knowledge on the exact system parameters $p$.
* While the deterministic solution finds the point estimate $\theta*$, the Bayesian solution finds a probability distribution over the control parameter.

##
* Given a Gaussian distribution over the system parameter $p$, the Bayesian solution to the optimization problem gives an exponential distribution over the optimal parameter $\theta$

##
* Shown in red is the point estimate of the deterministic solution

##
* and shown in black is the expectation over the Bayesian solution
* The disparity between the stability of the deterministic and the average optimal solutions shows that point estimates are overconfident.
* The complete details of this analysis can be found in the literature.

## Bayesian learning

## Simulated experiments {REREAD}

* We demonstrate the performance of the stochastic controller inferred through the IDAPBC technique on the swing-up task of the inertia wheel pendulum.
* In the original IDAPBC framework, the desired Hamiltonian serves as a Lyapunov
function of the system. 
* This experiment shows that our framework preserves this property, providing a
transparent connection between stability and controllers derived from learning
algorithms.

## Real-world experiment {REREAD}

* We also validate the robustness properties of the controller through real-world experiments.
* The IDAPBC optimization problem is solved for system parameters centered around a nominal system parameter of 4 rings on the wheel.
* We alter the number of rings and test the same controller on the system.
* It can be seen here that the controller can still take the system to the desired equilibrium.




