#!/usr/bin/python
from tasklib import TaskWarrior
import datetime
import subprocess

TASKW = "~/.local/share/task"
tw = TaskWarrior(TASKW)
tasks    = {}

def copy2clip(text):
    cmd=f'echo "{text.strip()}" | xclip -in -sel clip'
    print(cmd)
    return subprocess.check_call(cmd, shell=True)


def main():

    # task status:completed end.after:yesterday all
    tasks = tw.tasks.filter('end.after:yesterday', status='completed')
    todo  = ""
    for t in tasks:
        todo += f"- [X] {t}\n"
        annots = t['annotations']
        if len(annots):
            for annot in annots:
                todo += f"\t- {annot}\n"
    copy2clip(todo)



if __name__ == "__main__":
    main()

