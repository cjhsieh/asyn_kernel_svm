Asynchronous Parallel Kernel SVM (Asyn-KSVM) on multicore shared memory system
========================

Asyn-KSVM is based on the parallal asynchronous greedy coordinate descent
algorithm. For more details about this algorithm please refer to the following 
papers:

```
Asynchronous Parallel Greedy Coordinate Descent,
Yang You, Xiangru Lian, Ji Liu, Hsiang-Fu Yu, Inderjit Dhillon, James Demmel, Cho-Jui Hsieh. 
In NIPS 2016. 
```

Build
---------------

We require the following environment to build Asyn-KSVM:

- Unix Systems (We haven't tested on Mac OS). 

To build the program, simply run `make`. Two binaries, `svm-train` (for training) 
and `svm-predict` (for prediction) will be built.  

Data Preparation 
----------------

Please download the datasets from LIBSVM datasets
http://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets

We already have the ijcnn1.tr (training) and ijcnn1.t (testing) set
in the folder. 

Usage
----------------

./svm-train is used for parallel training, and it can print out the prediction 
accuracy at each step. 

```
Usage: svm-train [options] training_set_file testing_set_file [model_file]
options:
-s svm_type : set type of SVM (default 0)
	0 -- C-SVC (allow multi-class classification)
-t kernel_type : set type of kernel function (default 2)
	0 -- linear: u'*v
	1 -- polynomial: (gamma*u'*v + coef0)^degree
	2 -- radial basis function: exp(-gamma*|u-v|^2)
	3 -- sigmoid: tanh(gamma*u'*v + coef0)
-d degree : set degree in kernel function (default 3)
-g gamma : set gamma in kernel function (default 1/num_features)
-r coef0 : set coef0 in kernel function (default 0)
-c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
-m cachesize : set total cache memory size in MB (default 2000); each thread will use cachesize/n memory
-e epsilon : set tolerance of termination criterion (default 0.001)
-wi weight : set the parameter C of class i to weight*C, for C-SVC (default 1)
-v n: n-fold cross validation mode
-T maxiter : Maximum number of iterations (default 10*(number of samples))
-I i : print accuracy after every i iterations (default maxiter/10)
-N nthreads : number of threads
```

Note that the prediction accuracy printed out at each iteration is for each 
1-vs-1 subproblem for multi-class classification. 

./svm-predict is used for prediction: 
```
Usage: svm-predict [options] test_file model_file output_file
options:
-b probability_estimates: whether to predict probability estimates, 0 or 1 (default 0)
-q : quiet mode (no outputs)
```

Generating the Paper's Results
------------------------------

```
export OMP_NUM_THREADS=20; ./svm-train -c 32 -g 2 ijcnn1.tr ijcnn1.t
export OMP_NUM_THREADS=20; ./svm-train -c 8 -g 32 -m 64000 webspam_train webspam_test
export OMP_NUM_THREADS=20; ./svm-train -c 32 -g 32 -m 64000 covtype_train covtype_test
```

Additional Information
----------------------

If your have any questions or comments, please open an issue on Github,
or send an email to chohsieh@ucdavis.edu. We appreciate your feedback.


