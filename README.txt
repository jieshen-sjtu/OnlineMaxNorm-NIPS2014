This code is used for the NIPS 2014 work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
Feel free to use it for research purpose.

We make the code highly separable and thus flexible, i.e., each file only include one function to do one thing.

There are three tasks: {diff_rank_rho, ev_samples, large}, and four methods {OMRMD, OR-PCA, PCP, OPCA}.

=======How to Use=======
See DEMO.m. If there is any problem, feel free to contact: js2007@rutgers.edu

=======Baseline Code=======
OR-PCA and OPCA is implemented by Jiashi Feng in his work "Online Robust PCA via Stochastic Optimization"
PCP is implemented by Zhouchen Lin, see his homepage http://www.cis.pku.edu.cn/faculty/vision/zlin/zlin.htm for a newly released version of inexact ALM.

=======How to Cite=======
If you use this code, please kindly cite our NIPS work:

@inproceedings{shen2014online,
  author    = {Jie Shen and
               Huan Xu and
               Ping Li},
  title     = {Online Optimization for Max-Norm Regularization},
  booktitle = {Proceedings of the 28th Annual Conference on Neural Information Processing Systems},
  pages     = {1718--1726},
  year      = {2014}
}
