Project 4: Scene Recognition with Bag of Words 
Student name: Wenqi Xian (wxian3)

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

vocab.mat and stats.mat are pre-generated, so that the whole program will take around five minutes to run.

Thank you and wish you a wonderful day!! :)
(If there is any problem, please email me! wxian3@gatech.edu)