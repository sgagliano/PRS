#Example usage
#grep eagle Phase_tt.sh > Phase_tt-PHASE.sh #get list of phase commands from Phase_tt-PHASE.sh
#python2 Commands2Array.py --in-commandlist Phase_tt-PHASE.sh > Phase_tt-ARRAY-PHASE.sh
#grep -v eagle Phase_tt.sh > Phase_tt-INDEX.sh #get list of index commands from Phase_tt-PHASE.sh
#python2 Commands2Array.py --in-commandlist Phase_tt-INDEX.sh > Phase_tt-ARRAY-INDEX.sh

#Modified code written by Daniel Taliun

import argparse

argparser = argparse.ArgumentParser(description = 'Transform a list of commands to SLURM jobarray without dependicies.')
argparser.add_argument('--in-commandlist', metavar = 'CommandList', dest = 'CommandList', required = True, help = 'Input command list.')

def ReadList(CommandList):
        array=[]
        with open(CommandList, 'r') as f:
                for l in f:
                        array.append(l.rstrip())        
        return array

if __name__ == "__main__":
        args = argparser.parse_args()
        commands = ReadList(args.CommandList)

        print "#!/bin/bash"
        print "#SBATCH --array=0-%d" % (len(commands) - 1)
        print "#SBATCH --job-name=%d" % len(commands)
        print "#SBATCH --partition=inpsyght" #specify the partition name, or hash out if unncessary
        print "#SBATCH --mem=4000" #specify the memory, or hash out if unnecessary
        print "#SBATCH --time=100:00:00" #specify the running time, or hash out if unnecessary
        print "#SBATCH --output=../logs/%a.log" #writes out logs to the ../logs directory, modify as needed
        print "declare -a jobs"

        for i in xrange(0, len(commands)):
                print "jobs[%d]=\"%s\"" % (i, commands[i])

        print "eval ${jobs[${SLURM_ARRAY_TASK_ID}]}"
