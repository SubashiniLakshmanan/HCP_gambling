#!/bin/bash

BASEDIR=`pwd`
cd ..
MAINDATADIR=`pwd`/Data
MAINOUTPUTDIR=`pwd`/Analysis
cd $BASEDIR

#bash runAROMA.sh $subj $task $run
subj=$1
task=$2
run=$3

#make paths to reflect lab directory
DATADIR=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
OUTPUTDIR=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}

mkdir -p $OUTPUTDIR

OUTPUT=${OUTPUTDIR}/smoothing
DATA=${DATADIR}/tfMRI_${task}_${run}.nii.gz
NVOLUMES=`fslnvols ${DATA}`
aromaoutput=${OUTPUT}.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz

#delete old output if it exists to avoid +.feat directories
if [ -e ${OUTPUT}.feat ]; then
  rm -rf ${OUTPUT}.feat
fi

#find and replace: run feat for smoothing
ITEMPLATE=${BASEDIR}/templates/prep_aroma.fsf
OTEMPLATE=${OUTPUTDIR}/${subj}_${task}_${run}_PrepAroma.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
<$ITEMPLATE> ${OTEMPLATE}

#runs smoothing in fsl
feat ${OTEMPLATE}

#create variables for ICA AROMA (splitmotion)
myinput=${OUTPUT}.feat/filtered_func_data.nii.gz
myoutput=${OUTPUT}.feat/ICA_AROMA
mcfile=${OUTPUTDIR}/motion_6col.txt
rawmotion=${DATADIR}/Movement_Regressors.txt

#deleting any preexisting files
if [ -e $myoutput ]; then
  rm -rf $myoutput
fi
python splitmotion.py $rawmotion $mcfile

#running AROMA
python ${BASEDIR}/ICA-AROMA-master/ICA_AROMA_Nonormalizing.py -in $myinput -out $myoutput -mc $mcfile