# StarCCM-SLURM-Submission
StarCCM+ Design Manager and single run submission for cluster with SLURM job scheduler. 
This project is currently a work in progress. 

Design manager has two possible ways to submit: "General Job Submission" and "Pre-Allocation Job Submission"
Both are detailed in the Star-CCM+ manual.

The current version supported is V18.02.2018-R8, although other versions may work. This submission
is designed to work with our cluster, so minor changes may need to be made for other clusters with
other job schedulers (PBS, SLURM, etc) or different Star-CCM+ configurations (MPI, etc).

# Single run (No Design Manager)
The single run submission is for cases where you only want to submit a single simulation without the
use of Design Manager. This submission only has one submission file: singlerun.sh. To submit to the
cluster, ensure the sim file, any macros, and the singlerun.sh file are all in the same directory.
Modify the Job Settings and Simulation Settings in the script then use the following command:
"sbatch singlerun.sh"


# General Job Submission (Design Manager)
Before running a job, ensure that "Linux Cluster" is selected inside the Design Manager project under
single resource for each design study. The submit.sh script takes care of modifying the compute
resource properties via the "sed" commands. You do not need to make any other modifications to the 
design manager file other than setting up reports/parameters.

The general job submission uses two scripts: submit.sh and runStarDM.sh. The submit.sh script is the
main script that needs to be modified. Most of the settings will be changed under "Simulation Settings"
and additional modifications, such as creating directories or other personal scripts can be created 
under "Extra Settings". Small modifications may need to be made to the rest of the script.

*NOTE: Ensure that you add your POD key or license server details

The submit.sh script is submitted to the job scheduler first via "sbatch submit.sh". This script opens
up a design manager job on a single node (preferable to select a weaker node). This node will be responsible
for distributing each case to its own node based on the settings selected in the submit.sh script.

To  submit the job, have the two scripts in the same directory and preferably the sim + DM file in the same directory.
Since this script was designed with the intention of running on a SLURM-based cluster. Submit the job with the following:
"sbatch submit.sh"

# Pre-Allocation Job Submission (Design Manager)
WIP
