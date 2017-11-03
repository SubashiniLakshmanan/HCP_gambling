#!/bin/bash

BASEDIR=`pwd`
cd ..
MAINDATADIR=`pwd`/Data
MAINOUTPUTDIR=`pwd`/Analysis
cd $BASEDIR

##bash L1_Gam_PPI.sh $subj $task $run
subj=$1

INPUT01=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_LR/L1_Gam_PPI.feat
INPUT02=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_RL/L1_Gam_PPI.feat
OUTPUT=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/L2_Gam_PPI

for RUN in LR RL; do
  mkdir -p ${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_${RUN}/L1_Gam_PPI.feat/reg
  ln -s $FSLDIR/etc/flirtsch/ident.mat ${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_${RUN}/L1_Gam_PPI.feat/reg/example_func2standard.mat
  ln -s $FSLDIR/etc/flirtsch/ident.mat ${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_${RUN}/L1_Gam_PPI.feat/reg/standard2example_func.mat
  ln -s $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz ${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_GAMBLING_${RUN}/L1_Gam_PPI.feat/reg/standard.nii.gz
done

#find and replace
ITEMPLATE=${BASEDIR}/templates/L2GamPPI.fsf
OTEMPLATE=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/L2_Gam_PPI.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@INPUT01@'$INPUT01'@g' \
-e 's@INPUT02@'$INPUT02'@g' \
<$ITEMPLATE> $OTEMPLATE

#runs feat on output template
feat $OTEMPLATE