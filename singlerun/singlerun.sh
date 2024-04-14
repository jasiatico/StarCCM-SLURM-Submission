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
PROJECTFILE = "NACA0012.sim"

## Name of the output file
OUTPUTFILE = "sim.out"

## List any macros
## Note: You can list mesh and run as inputs along with java macros
MACROS="RotateBody.java,mesh,run,PostProcess.java"

###NOT FINISHED
###################################################################################################





