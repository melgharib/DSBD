SBD is shot boundary detection for scene transition: This code is based on caffe and the c3d models from dutran (https://github.com/facebook/C3D)
The contribution of this work is in creating a data set for shot boundary detection: normal scenes and sharp and gradual transitions.
Similar to c3d code you can generate features using feature_extraction_frm.sh

After features being generated you should run two scripts:
1. classifySequences.m
2. evaluate.m

After evaulate you will have files for transition results that you could take as is or do whatever postprocessing you want. In our paper we did non maxima supression for overlapping segments and histogram of color similarity check in order to reduce the false positives. 
