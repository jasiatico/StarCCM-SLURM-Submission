#!/bin/bash 
# Version 18.02.2018-R8

#################### Job Settings #################################################################
# Specific Commands for the work load manager SLURM are lines beginning with "#SBATCH"
# For SBATCH lines. Double pound sign is commented out. Single pound is uncommented.

#SBATCH -t 10:00:00                    # Set walltime for DM submission in hhh:mm:ss
#SBATCH --ntasks=1                      # Set number of cores (Design Manager only runs in serial)
#SBATCH -J template_DM                  # Set display name for job submission
#SBATCH --output=output.%j.starccmDM    # Set output name

## Node inclusion and exclusion
##SBATCH --nodelist=ec4                # Set node to run on
##SBATCH --exclude=ec[1-9],ec[10-87]   # Set node exclusions

## Work directory. No "/" at the end.
WORKDIR=$PWD
###################################################################################################


## USER INPUT IS ONLY REQUIRED IN SIMULATION SETTINGS
## MAKE SURE LINUX CLUSTER IS SELECTED "COMPUTE RESOURCES" IN DMPRJ FILE


#################### Simulation Settings ##########################################################

## Name of DM Project. Must be in the WORKDIR
PROJECTFILE="DesignManagerFile.dmprj"

## Name of the StarCCM+ script file. If not in WORKDIR, specify full path
STARRUNSCRIPT="runStarDM.sh"

## Number of processors per job
NPROC_PER_JOB=32

## Number of simultaneous jobs
NSIMULT_JOB=15

## Number of nodes per jobs
NODES_JOB=1

## Personal POD Key (22 characters. Replace <PODKEY> with PODKEY)
PERSONAL_PODKEY="<PODKEY>"

## License options. POD vs. License Server
# Comment to use POD key
LICENSEOPTIONS="-licpath <LicenseServer>"
# Uncomment to use POD key
#LICENSEOPTIONS="-podkey $PERSONAL_PODKEY -licpath 1999@flex.cd-adapco.com"
###################################################################################################

#################### Extra Settings ###############################################################
## Add additional settings here (Creating directories, etc)
# mkdir results

###################################################################################################



### The rest of the script should not require user input. Although certain clusters may need script
### revisions. For example, PBS vs. SLURM or the type of MPI used for Star-CCM+.



########## Modify DM File #########################################################################
# Set command line options in DM
sed -r -i "s|'CcmpCmd': *'[^']*'|'CcmpCmd': ''|" $WORKDIR/$PROJECTFILE

# Set job submit command in DM
JOBSUB="sbatch --nodes=$NODES_JOB --ntasks-per-node=$NPROC_PER_JOB"
sed -r -i "s|'JobSubmitCmd': '[^']+'|'JobSubmitCmd': '$JOBSUB'|" $WORKDIR/$PROJECTFILE

# Set Name Identifier in DM
sed -r -i "s|'JobNameIdentifier': *'[^']*'|'JobNameIdentifier': ''|" $WORKDIR/$PROJECTFILE

# Set Prefix in DM
sed -r -i "s|'JobNamePrefix': *'[^']*'|'JobNamePrefix': ''|" $WORKDIR/$PROJECTFILE

# Set script file in DM
SCRIPTFILE=$WORKDIR/$STARRUNSCRIPT
sed -r -i "s|'ScriptFile': *'[^']*'|'ScriptFile': '${SCRIPTFILE}'|" $WORKDIR/$PROJECTFILE

# Set number of processors per job in DM
sed -r -i "s/'NumComputeProcesses': [0-9]+/'NumComputeProcesses': ${NPROC_PER_JOB}/" $WORKDIR/$PROJECTFILE

# Set number of simultaneous jobs in DM
sed -r -i "s/'NumSimultaneousJobs': [0-9]+/'NumSimultaneousJobs': ${NSIMULT_JOB}/" $WORKDIR/$PROJECTFILE


# Settings for individual simulations during Design Study
PASSTODESIGN="-collab -mpi openmpi"
###################################################################################################


#### Cleaning/Processing ##########################################################################
# Convert text files with DOS/MAC line breaks to Unix line breaks
# Sometimes scripts will not work if modified on windows machine
dos2unix $STARRUNSCRIPT

# Create caseLogs file if it does not exist
[ -d "caseLogs" ] || mkdir -p caseLogs
###################################################################################################


######### Running the simulation ##################################################################
# Load StarCCM+ Module
module load starccm/starccm-18.02.008-R8

# Write start time stamp to log file
echo "Starting the StarCCM+ Design Manager"
date +%Y-%m-%d_%H:%M:%S_%s_%Z # date as YYYY-MM-DD_HH:MM:SS_Ww_ZZZ

# Open StarCCM+ DM
starccm+ -batch run $WORKDIR/$PROJECTFILE -passtodesign " -rsh /usr/bin/ssh $PASSTODESIGN ${LICENSEOPTIONS}" \
> $WORKDIR/caseLogs/$PROJECTFILE.$SLURM_JOBID.log 2>&1

echo "Ending the StarCCM+ Design Manager"
# Write final time stamp to the log file
echo "Job finalised at:"
date +%Y-%m-%d_%H:%M:%S_%s_%Z

mv output* $WORKDIR/caseLogs
####################################################################################################
