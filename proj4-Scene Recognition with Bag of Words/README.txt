Project 4: Scene Recognition with Bag of Words 
http://www.cc.gatech.edu/~hays/compvision/results/proj4/html/wxian3/index.html

# Extra credit: 
1.Experiment with many different vocabulary sizes and report performance.
2.Use GMM & Fisher encoding, one of the more sophisticated feature encoding schemes analyzed in the comparative study of Chatfield et al. 
3.Train the SVM with Gaussian/RBF kernel.

# How to test the result:
The best result I got is 81.6% and 81.8% with fisher encoding and SVM.
%FEATURE = 'tiny image';
%FEATURE = 'bag of sift';
%FEATURE = 'placeholder';
please uncomment —> FEATURE = 'fisher encoding';

%CLASSIFIER = 'nearest neighbor';
please uncomment —> CLASSIFIER = 'support vector machine';
%CLASSIFIER = 'placeholder';
