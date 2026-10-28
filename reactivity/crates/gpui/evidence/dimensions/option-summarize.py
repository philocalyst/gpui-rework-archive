import csv,json,pathlib,statistics
root=pathlib.Path('/tmp/gpui-dimensions-measure')
records=[]
for path in sorted(root.glob('[0-9][0-9]-*.csv')):
 r,case,variant=path.stem.split('-')
 rows=list(csv.reader(path.read_text().splitlines()))
 if case=='styles':
  for row in rows[rows.index(['styles','count','prepare_us','retained_bytes','peak_bytes','allocations','nodes'])+1:]:
   for metric,i in [('time_us',2),('retained',3),('peak',4),('allocations',5)]:
    records.append((case+'_'+row[0]+'_'+row[1],int(r),variant,metric,float(row[i])))
 elif case in ['none','sparse','sparse_cpu']:
  for row in rows[1:]:
   for metric,i in [('time_us',5),('retained',7),('peak',8),('allocations',9)]:
    records.append((case+'_'+row[4],int(r),variant,metric,float(row[i])))
 else:
  row=rows[1]
  for metric,i in [('mount_us',3),('retained',4),('peak',5),('allocations',6),('scroll_us',10)]:
   records.append((case,int(r),variant,metric,float(row[i])))
with (root/'samples.csv').open('w') as out:
 writer=csv.writer(out);writer.writerow(['case','round','variant','metric','value']);writer.writerows(records)
summary=[]
for case,metric in sorted(set((r[0],r[3]) for r in records)):
 values={label:{r[1]:r[4] for r in records if r[0]==case and r[2]==label and r[3]==metric} for label in ['baseline','candidate']}
 b,c=values['baseline'],values['candidate']
 paired=[(c[r]/b[r]-1)*100 for r in b if b[r]!=0]
 summary.append([case,metric,statistics.median(b.values()),statistics.median(c.values()),statistics.median(paired) if paired else 0])
with (root/'summary.csv').open('w') as out:
 writer=csv.writer(out);writer.writerow(['case','metric','baseline_median','candidate_median','paired_percent_median']);writer.writerows(summary)
for row in summary:
 if row[1] in ['time_us','mount_us','scroll_us'] or (row[1]=='retained' and row[0].endswith('mount')) or row[0].startswith('styles_false_10000'):
  print(','.join(str(round(x,3)) if isinstance(x,float) else str(x) for x in row))
