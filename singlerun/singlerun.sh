#!/bin/bash 
# Version 18.02.2018-R8

#################### Job Settings #################################################################
# Specific Commands for the work load manager SLURM are lines beginning with "#SBATCH"
# For SBATCH lines. Double pound sign is commented out. Single pound is uncommented.

#SBATCH -t 10:00:00                     # Set walltime for DM submission in hhh:mm:ss
#SBATCH -J template_DM                  # Set display name for job submission
#SBATCH --output=output.%j.starccmDM    # Set output name

#SBATCH --nodes=2                       # Set number of compute nodes to use
#SBATCH --ntasks-per-node=48            # Set number of tasks per node
#SBATCH --mem-per-cpu=4G                # Set memory/RAM per cpu
#SBATCH --cpus-per-task=1               # Set number of cpus per task


## Node inclusion and exclusion
##SBATCH --nodelist=ec4                      # Set node to run on
##SBATCH --exclude=ec[1-9],ec[10-76],ec122   # Set node exclusions

# Detailed Notes:
# --nodes: Specifies the number of compute nodes. Each node is a separate 
#          physical machine.
# --ntasks-per-node: Sets the number of tasks to run on each node. Typically
#                    corresponds to the number of cores per node.
# --mem-per-cpu: Defines the amount of memory allocated to each core. Take
#                note for how much memory is dedicated per node
# --cpus-per-task: Allocates the number of cores per task. Enables
#                  multi-threading when set greater than 1. StarCCM+ has no
#                  benefit from multi-threading so set to 1.

## Work directory. No "/" at the end.
WORKDIR=$PWD
###################################################################################################

## USER INPUT IS ONLY REQUIRED IN SIMULATION SETTINGS


#################### Simulation Settings ##########################################################

## Name of sim file. Must be in the WORKDIR
SIMFILE = "NACA0012.sim"

## Name of the output file
OUTPUTFILE = "sim.out"

## List any macros
## Note: You can list mesh and run as inputs along with java macros
MACROS="RotateBody.java,mesh,run,PostProcess.java"

## License options. POD vs. License Server
# Comment to use POD key
LICS="-licpath <LICENSESERVER>"
# Uncomment to use POD key
PERSONAL_PODKEY="<PODKEY>"
#LICS="-podkey $PERSONAL_PODKEY -licpath 1999@flex.cd-adapco.com"
###################################################################################################


#################### Extra Settings ###############################################################
## Add additional settings here (Creating directories, etc)
# mkdir results

# Create a directory and place a file that contains the list of nodes used
mkdir machineFiles 
MACHINEFILE="machineFiles/machinefile.$SLURM_JOBID.txt"
scontrol show hostnames $SLURM_JOB_NODELIST > $MACHINEFILE 
###################################################################################################



### The rest of the script should not require user input. Although certain clusters may need script
### revisions. For example, PBS vs. SLURM or the type of MPI used for Star-CCM+.



######### Running the simulation ##################################################################
# Load Modules and purge any other modules
module purge
module load starccm/starccm-18.02.008-R8


# Start job timer
echo "$(date)" >> job.timer

# run star-ccm+ with settings above
starccm+ -np $SLURM_NTASKS -pio -rsh ssh -machinefile $MACHINEFILE -power -licpath $LICS -batch $MACROS $SIMFILE &> "$OUTPUTFILE"

# End job timer
echo "$(date)" >> job.timer


# Calculate elapsed time
start_timestamp=$(date -d "$start_time" +%s)
end_timestamp=$(date -d "$end_time" +%s)
elapsed_time=$((end_timestamp - start_timestamp))
formatted_elapsed_time=$(date -u -d @"$elapsed_time" +'%H hours %M minutes %S seconds')

# Report mesh statistics to stat.out file
grep 'Cells:' sim.out | awk 'END {print "Number of cells: " $2}' &>>stat.out
echo "Start Time: $start_time" >> stat.out
echo "End Time: $end_time" >> stat.out
echo "Elapsed Time: $formatted_elapsed_time" >> stat.out

