#!/usr/bin/python
from tasklib import TaskWarrior
from tabulate import tabulate
import datetime
import os
import re
import frontmatter
import argparse


home = os.environ['HOME']
JRNL         = f"{home}/area/mounts/mind_matrix/📒 jrnl"
tw           = TaskWarrior(data_location=f"{home}/.local/share/task/")
table        = []
trefs, trels = 0, 0

parser = argparse.ArgumentParser()
parser.add_argument(
    '-d', '--date',
    type=lambda s: (datetime.datetime.strptime(s, '%Y-%m-%d')).date(),
)
args = parser.parse_args()


# Get all the dates from the current
# week based on the current date
def get_week_dates(curr_date=None):
    if not curr_date:
        curr_date = datetime.date.today()
    weekday = curr_date.weekday()
    start = curr_date - datetime.timedelta(days=weekday)
    dates = [start + datetime.timedelta(days=d) for d in range(7)]
    return dates

def create_tasks_table(tasks):
    table   = []
    for t in reversed(tasks):
        tags = " ".join(t['tags'])
        table.append([t, t['end'].strftime("%c"), " ".join([f"`{t}`" for t in tags.split()])])
    return tabulate(table, headers=["Task", "Day", "Tags"], tablefmt="github")


def parse_day(day):
    pass

week = get_week_dates(args.date)
for day in week:
    day_path = f"{JRNL}/days/{day}.md"
    try:
        table_item = [f'[[{str(day)}\\|{day.strftime("%a")}]]']

        # Read each day file content
        with open(day_path) as fd:
            content = fd.read()
        fd.close()
        
        # Get from the meta section only the table
        meta = content[content.index("| ---"):].split('\n')[1:-3]
        # Extract references & related notes
        refs, rels = "", ""
        for line in meta:
            rel, ref = line[2:-2].split("|")
            rel, ref = rel.strip(), ref.strip()
            # TODO: handle when no rel is available (add [[]] manually if nonetype)

            if rel == "[[]]":
                rels = None
            else:
                rels += f"{rel.strip()} <br />"
                trels += 1

            if ref == "[]()":
                refs = None
            else:
                refs += f"{ref.strip()} <br />"
                trefs += 1
        table_item.append(refs)
        table_item.append(rels)

        # Get the day type
        fm = frontmatter.load(day_path)
        table_item.append(f"`{fm['day_type']}`")

        table.append(table_item)
    except Exception as e:
        # print(e)
        pass


days_table  = tabulate(table, headers=["Day", f"Refs <sub>({trefs})</sub>", f"Rels <sub>({trels})</sub>", "Type"], tablefmt="github")
done_tasks  = tw.tasks.filter('end.after:-8d', status="completed")
tasks_table = create_tasks_table(done_tasks)
summary     = '\n'.join(tw.execute_command(['summary']))
ghistory    = '\n'.join(tw.execute_command(['ghistory.weekly']))

with open("test.md", "w") as outf:
    outf.write('## Days\n')
    outf.write(days_table)

    outf.write('\n\n## Tasks\n')
    outf.write(tasks_table)
    outf.write(f"\n\n```bash{summary}\n```")
    outf.write(f"\n```bash{ghistory}\n```")
outf.close()

















# table = [
#     ["[[2022-04-04\|Mon]]", "[Battle for the South of Ukraine](https://www.youtube.com/watch?v=hhBfNDVs-PY) <br /> [Inside Irpin: Russian Forces on Kyiv's Doorstep](https://www.youtube.com/watch?v=KOao41OlzaU)", None, "`studio`"],
#     ["[[2022-04-05\|Tue]]", "[[(  2022-03-28 What is money, anyway?#2 Gold Standard]]", None, "`dev`"],
#     ["[[2022-04-06\|Wed]]", "[Were we wrong about web3.0?](https://terminusdb.com/blog/were-we-wrong-about-web3/) <br /> [ronin blockcain hack report](https://roninblockchain.substack.com/p/community-alert-ronin-validators?s=r)", "[[day]]", "`dev`"]
# ]

