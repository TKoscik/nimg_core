#!/bin/bash

umask 002 # Ensure that group write is activated when making new files.
echo $(lsb_release -d) |grep "release 7"
if [[ $? -eq 0 ]]; then
  hostname |grep psychiatry.uiowa.edu
  if [[ $? -eq 0 ]]; then
    env=RHEL7PINC
    BAW_BINDIR=/Shared/pinc/sharedopt/20170302/RHEL7/NEP-11
  else
    env=RHEL7ARGON
    BAW_BINDIR=/Shared/pinc/sharedopt/20170302/RHEL7/NEP-intel
  fi
else
  echo $(lsb_release -d) |grep "release 6"
  if [[ $? -eq 0 ]]; then
    env=RHEL6
    BAW_BINDIR=FILLIT
  else
    env=OSX
    BAW_BINDIR=/Shared/pinc/sharedopt/20170302/Darwin10.10/NEP-11
  fi
fi

echo "XXXXXXXXXXX ENV: ${env}"
echo "USING Binaries from: ${BAW_BINDIR}"

HERE=$(dirname ${0})
echo "--${HERE}--"
if [ -z "${HERE}" ]; then
   HERE=$(pwd)
fi
echo "--${HERE}--"

configFile=${HERE}/XXX_MISSING_-c
#source /Shared/pinc/sharedopt/20160202/${env}/anaconda2/bin/activate
echo $PATH
echo $PYTHONPATH

PHASE_TO_RUN="ERROR: NO PHASE SPECIFIED must provide -p"

runtype=local
subsetToRun="INVALID"
#MYECHO="echo"
MYECHO=""
US="--use-sentinal"
LOGGER_NAME=last_run.logger

while getopts "fp:r:s:l:c:" opt; do
  case $opt in
    p)
      echo "-p was triggered! Parameter for phase: $OPTARG" >&2
      PHASE_TO_RUN=$OPTARG
      ;;
    r)
      echo "-r was triggered! Parameters for runype: $OPTARG" >&2
      runtype=$OPTARG
      ;;
    s)
      echo "subset to run (either session or subject list:  $OPTARG" >&2
      subsetToRun="$OPTARG"
      ;;
    e)
      MYECHO=echo
      ;;
    f)
      ### Force running of pipeline
      US=""
      ;;
    l)
      LOGGER_NAME=$OPTARG
      ;;
    c)
      configFile="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

case  $runtype in
    SGEGraph)
      ;;
    SGE)
      ;;
    local)
      ;;
    *)
      echo "ONLY VALID -r [SGEGraph|SGE|local]"
      exit -1
      ;;
esac

(
if [ ${PHASE_TO_RUN} -eq 1 ]; then
${MYECHO} python ${BAW_BINDIR}/BRAINSTools/AutoWorkup/singleSession.py \
  --wfrun ${runtype} \
  --workphase atlas-based-reference \
  --pe ${env} \
  ${US} \
  --ExperimentConfig ${configFile} \
$(echo ${subsetToRun})
fi

if [ ${PHASE_TO_RUN} -eq 2 ]; then

#template.py [--rewrite-datasinks] [--wfrun PLUGIN] [--dotfilename PFILE]
#            --workphase WORKPHASE --pe ENV --ExperimentConfig FILE SUBJECTS...
python ${BAW_BINDIR}/BRAINSTools/AutoWorkup/template.py \
  --wfrun ${runtype} \
  --workphase subject-template-generation \
  --pe ${env} \
  ${US} \
  --ExperimentConfig ${configFile} \
$(echo ${subsetToRun})
fi

if [ ${PHASE_TO_RUN} -eq 3 ]; then
python ${BAW_BINDIR}/BRAINSTools/AutoWorkup/singleSession.py \
  --wfrun ${runtype} \
  --workphase subject-based-reference \
  --pe ${env} \
  --ExperimentConfig ${configFile} \
  ${US} \
$(echo ${subsetToRun})
fi
) |tee ${LOGGER_NAME} 2>&1
