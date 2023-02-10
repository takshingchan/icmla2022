Identifying Metering Hierarchies with Distance Correlation and Dominance Constraints
------------------------------------------------------------------------------------

This repository implements Section III of T.-S. T. Chan and A. Gibberd,
"Identifying metering hierarchies with distance correlation and dominance
constraints," in *Proc. IEEE Int. Conf. Mach. Learn. Appl.*, 2022, pp.
1551-1558. We require MATLAB 2019b and the Statistics and Machine Learning
Toolbox.

Research on hierarchical time series typically assumes that the hierarchy is
known. Our paper addresses the case where the hierarchy is unknown.

The following functions are included:

| Function     | Description                                        |
| ------------ | -------------------------------------------------- |
| `aggpaths`   | Finds all aggregation paths.                       |
| `dcorrcoef`  | Distance correlation coefficients.                 |
| `evaltree`   | Evaluate a predicted tree.                         |
| `experiment` | Generate random trees and simulate energy usage.   |
| `fillci`     | Plot the results with shaded confidence intervals. |
| `gentree`    | Generate a random tree.                            |
| `printtab`   | Script to print the tables.                        |

### Dependencies

This code depends on fastDcov and getDirectedTree.

1. To get fastDcov, download source from https://arxiv.org/abs/1810.11332 and
   untar it.

2. To obtain getDirectedTree, download ZIP from
   https://github.com/nineisprime/optimal-branch then unzip and
   `mex getDirectedTree.cpp` from MATLAB.

### Running

To reproduce our results, follow the steps below.

- For Experiment 1:

    ```matlab
    rng('default')
    experiment(true,[1.5 2],2:5,31,0,[10 20 50 100 200 500],2000)
    movefile results.mat results_1.mat
    experiment(false,[1.5 2],3,31,0,[10 20 50 100 200 500],2000)
    movefile results.mat results_2.mat
    ```

- For Experiment 2:

    ```matlab
    rng('default')
    experiment(true,[1.5 2],3,31,16,[10 20 50 100 200 500],2000)
    movefile results.mat results_3.mat
    ```

To plot all results, follow the steps below.

- For Experiment 1:

    ```matlab
    load results_1.mat
    fillci(results,true,1.5,3,31,0,[10 20 50 100 200 500],.99)
    fillci(results,true,2,3,31,0,[10 20 50 100 200 500],.99)
    printtab
    load results_2.mat
    fillci(results,false,1.5,3,31,0,[10 20 50 100 200 500],.99)
    fillci(results,false,2,3,31,0,[10 20 50 100 200 500],.99)
    ```

- For Experiment 2:

    ```matlab
    load results_3.mat
    fillci(results,true,1.5,3,31,16,[10 20 50 100 200 500],.99)
    fillci(results,true,2,3,31,16,[10 20 50 100 200 500],.99)
    ```

Tak-Shing Chan

14 December 2022

### References

\[1\] T.-S. T. Chan and A. Gibberd, "Identifying metering hierarchies with
distance correlation and dominance constraints," in *Proc. IEEE Int. Conf.
Mach. Learn. Appl.*, 2022, pp. 1551-1558.

\[2\] A. Chaudhuri and W. Hu, "A fast algorithm for computing distance
correlation," *Comput. Statist. Data Anal.*, vol. 135, pp. 15-24, 2019.
