# StarCCM-SLURM-Submission
StarCCM+ Design Manager submission for cluster with SLURM job scheduler. 
This project is currently a work in progress. 

This design manager submission is a "General Job Submission" as per the Star-CCM+ manual. If you would
like to use a pre-allocation job submission visit: "REPO Work in Progress"


The current version supported is V18.02.2018-R8, although other versions may work. This submission
is designed to work with our cluster, so minor changes may need to be made for other clusters with
other job schedulers (PBS, SLURM, etc) or different Star-CCM+ configurations (MPI, etc).

# Running a job
Before running a job, ensure that "Linux Cluster" is selected inside the Design Manager project under
single resource for each design study. The submit.sh script takes care of modifying the compute
resource properties via the "sed" commands.

The general job submission uses two scripts: submit.sh and runStarDM.sh. The submit.sh script is the
main script that needs to be modified. Most of the settings will be changed under "Simulation Settings"
and additional modifications, such as creating directories or other personal scripts can be created 
under "Extra Settings". Small modifications may need to be made to the rest of the script.

*NOTE: Ensure that you add your POD key or license server details

The submit.sh script is submitted to the job scheduler first via "sbatch submit.sh". This script opens
up a design manager job on a single node (preferable to select a weaker node). This node will be responsible
for distributing each case to its own node based on the settings selected in the submit.sh script.



