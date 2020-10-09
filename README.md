# DeepSBD
Large-scale, Fast and Accurate Shot Boundary Detection through Spatio-temporal Convolutional Neural Networks
https://arxiv.org/abs/1705.03281


SBD is shot boundary detection for scene transition: This code is based on caffe and the c3d models from dutran (https://github.com/facebook/C3D)
The contribution of this work is in creating a data set for shot boundary detection: normal scenes and sharp and gradual transitions.
Similar to c3d code you can generate features using feature_extraction_frm.sh

After features being generated you should run two scripts:
1. classifySequences.m
2. evaluate.m

After evaulate you will have files for transition results that you could take as is or do whatever postprocessing you want. In our paper we did non-maxima supression for overlapping segments and histogram of color similarity check, in order to reduce the false positives. 

The dataset can be downloaded from: https://nextcloud.mpi-klsb.mpg.de/index.php/s/A9JcEmkfDjeWAws?fbclid=IwAR1xOBAB-BiU5JN9h-Y2lSkkOnSEpzMH69IXhTyrNmubQrm9Ggs34GPrArU
The data set description and experiments in details can be found in the paper and supplementary materials. However, here is a brief description:
The data set contains 6 folders, 5 folders (tv2001, tv2007d, tv22007t, tv2008 and tv2009) for 5 different development trecvid releases that we use in order to generate synthetic sharp and gradual transitions. tv7789 contains hard samples from the other tv2007-d&t, 8 and 9. You should always include tv7789 in your training set as in our experiments we show how important are they.
Each folder, sorry I know it is not consistent, has two directories synsetic and segments. Synthetic contains sharp and gradual transitions. Segments contains no-transition segments.
