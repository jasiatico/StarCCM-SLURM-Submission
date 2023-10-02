#!/bin/bash 
# Version 18.02.2018-R8

#################### Job Settings #################################################################
# Specific Commands for the work load manager SLURM are lines beginning with "#SBATCH"

#SBATCH -t 48:00:00                     # Set walltime for DM submission in hhh:mm:ss
#SBATCH -J template_run                 # Set display name for job submission
#SBATCH --output=output.%j.star_run     # Set output name

## Node inclusion and exclusion
##SBATCH --nodelist=ec4                # Set node to run on
##SBATCH --exclude=ec[1-9],ec[10-87]   # Set node exclusions

## Work directory. No "/" at the end.
WORKDIR=$PWD
###################################################################################################


###################################################################################################
# Design Manager definitions:                     #################################################
# Used to read execution and output options in DM #################################################
# ----------------------------------
# dm_design_execute_options.txt contains starccm+ command line arguments.
# dm_design_output_info.msg contains log output file name to dump.
STARTCASE=`cat dm_design_execute_options.txt`
CASELOG=`cat dm_design_output_info.msg`
###################################################################################################


######### Running the simulation ##################################################################
# Load StarCCM+ Module
module load starccm/starccm-18.02.008-R8

# Write start time stamp to log file
echo "Starting the StarCCM+ Design Manager"
date +%Y-%m-%d_%H:%M:%S_%s_%Z # date as YYYY-MM-DD_HH:MM:SS_Ww_ZZZ


# Open StarCCM+ DM
starccm+ -rsh ssh -batchsystem slurm $STARTCASE &> $CASELOG

echo "Ending the StarCCM+ Design Manager"
# Write final time stamp to the log file
echo "Job finalised at:"
date +%Y-%m-%d_%H:%M:%S_%s_%Z

####################################################################################################
