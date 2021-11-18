#!/usr/bin/zsh
#   _..__.          .__.._
#  .^"-.._ '-(\__/)-' _..-"^.
#         '-.' oo '.-'
#            `-..-'
#   Author : vlaghe
#   Website: vlaghe.com
#
#   Description
#   -----------
#   Polybar module to display the active context
#   its associated tasks & time since last changed
#   to another context
#
#
#   TODO
#   ----
#   Refactor & retest

# Display: 
#   ctx  :time - nr tasks
#   @home:2h   - 10 

# Get current context
ctx=$(task _get rc.context)

# Get tasks 
task_count=$(task -in count due:tomorrow)

# zsh: read history
#HISTORY_IGNORE="(history -i)"
#fc -R
#fc -l -20

# Get time since last $ctx has been active
#   FIXME: sometimes it works, sometimes not idfkwhy
# date_time=$(history -i | grep "task @ $ctx" | tail -n 1 | awk '{print $2, $3}')
# curr=$(date +"%Y-%m-%d %H:%M")
# elapsed=$(datediff $date_time $curr -f "%Hh:%Mm")

#echo "$ctx:$elapsed - $task_count"
echo "@$ctx - $task_count"


# bash
# Bash disables history for noninteractive shells by default appareently
# export HISTIGNORE='history'
# HISTFILE=~/.cache/zsh/history
# HISTTIMEFORMAT="%F %T "
# HISTCONTROL="ignoredups"
# set -o history
#history | grep "task @ $ctx" | awk '{print $2, $3}'
