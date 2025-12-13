# Submission Notes

## Works in progress

- I have a couple things that are not completed yet within this project.  One very notable one is the `gbff_to_gff.sh` script. Currently it creates a gff3 file that has no data in it. Since this script is non-functional, I do not have annotation tracks prepared for the Heinz 1706 SL4.0 alignment or the M82 alignment.

- I cannot figure out why the *LA 1416* alignment to the *M82* reference genome is causing an error when added as a track on JBrowse. I have tried readding the track, resorting the BAM file, reindexing the BAM file, and re-downloading the files from OSC to my local computer. Unforatunately, non of these approaches solved the problem, so the *LA 1416* alignment is unvailable to view through JBrowse.

## Rerunning the code

- The top-level `README.md` document should provide some insight into each script and should guide you how to complete the workflow from start to finish. You may begin by redownloading the raw data files as outlined in the `README.md`, but you can begin at in the first script within **File Preparation** header section. 

- I found it easier to monitor the batch jobs by keeping the slurm logs in the top level directory as the code is running. Within the scripts I have code that creates the necessary subdirectories to house the logs once you are no longer monitoring an ongoing job. Once the batch job is complete, I reccomend move the slurm logs to the directory created within the script.

## Additional Notes

- If you would like to see what the JBrowse alignments looked like from my computer, I have provided screenshots of each alignment within the `imgs` directory within the top-level of my working directory.

- The `sandbox` directory is full of scripts that may be ignored because they served a previous project plan.