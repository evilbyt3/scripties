#!/usr/bin/python
from tasklib import TaskWarrior
from tabulate import tabulate
import datetime
import os
import re
import frontmatter


home = os.environ['HOME']
JRNL         = f"{home}/area/mounts/mind_matrix/📒 jrnl"
tw           = TaskWarrior(data_location=f"{home}/.local/share/task/")
table        = []
trefs, trels = 0, 0



# Get all the dates from the current
# week based on the current date
def get_week_dates():
    curr_date = datetime.date.today()
    weekday = curr_date.weekday()
    start = curr_date - datetime.timedelta(days=weekday)
    dates = [start + datetime.timedelta(days=d) for d in range(7)]
    return dates

def parse_day(day):
    pass



week = get_week_dates()
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
summary     = '\n'.join(tw.execute_command(['summary']))
projects    = 

with open("test.md", "w") as outf:
    outf.write('## Days\n')
    outf.write(days_table)

    outf.write('\n\n## Tasks\n')
    for task in done_tasks:

        outf.write(f"- [X] {task} ({task['project']}, {task['tags']})\n")
    outf.write(f"\n```bash{summary}\n```")



outf.close()

















# table = [
#     ["[[2022-04-04\|Mon]]", "[Battle for the South of Ukraine](https://www.youtube.com/watch?v=hhBfNDVs-PY) <br /> [Inside Irpin: Russian Forces on Kyiv's Doorstep](https://www.youtube.com/watch?v=KOao41OlzaU)", None, "`studio`"],
#     ["[[2022-04-05\|Tue]]", "[[(  2022-03-28 What is money, anyway?#2 Gold Standard]]", None, "`dev`"],
#     ["[[2022-04-06\|Wed]]", "[Were we wrong about web3.0?](https://terminusdb.com/blog/were-we-wrong-about-web3/) <br /> [ronin blockcain hack report](https://roninblockchain.substack.com/p/community-alert-ronin-validators?s=r)", "[[day]]", "`dev`"]
# ]

