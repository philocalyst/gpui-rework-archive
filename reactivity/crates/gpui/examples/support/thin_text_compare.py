#!/usr/bin/env python3
"""Paired fresh-process requested-allocation and phase times; no RSS claim."""
import csv
import io
import os
import subprocess
import sys

if sys.argv[1]=="--clone":
    cpu=min(os.sched_getaffinity(0));os.sched_setaffinity(0,{cpu});writer=None
    for repetition in range(int(sys.argv[2])):
        order="reverse" if repetition%2 else "forward"
        run=subprocess.run([sys.argv[3],"2000000",order],capture_output=True,text=True,check=True)
        for row in csv.DictReader(io.StringIO(run.stdout)):
            result=dict(repetition=repetition,order=order,cpu=cpu,**row)
            if writer is None:writer=csv.DictWriter(sys.stdout,fieldnames=list(result));writer.writeheader()
            writer.writerow(result)
    sys.exit()

repeats = int(sys.argv[1])
variants = [entry.split("=", 1) for entry in sys.argv[2:]]
cpu = min(os.sched_getaffinity(0))
os.sched_setaffinity(0, {cpu})
# count,every,ports,length,sharing,mode. Ports: visual=1,name=2,description=4.
fixtures = [
    (99999, 0, 0, "3", "source", "recording"),
    (10000, 1000, 1, "3", "source", "recording"),
    *[(1000, 1, 1, str(length), "unique", "recording") for length in (0, 3, 8, 23, 24, 25, 64)],
    (1, 1, 6, "4096", "source", "recording"),
    (128, 1, 1, "utf8", "source", "recording"),
    (10000, 1, 2, "8", "source", "recording"),
    (10000, 1, 6, "3", "unique", "recording"),
    (512, 1, 7, "8", "source", "recording"),
    (32, 1, 7, "3", "unique", "cpu"),
    (32, 1, 1, "24", "source", "cpu"),
    (1, 1, 1, "8", "source", "cpu"),
]
writer = None
start=int(os.environ.get("THIN_START_FIXTURE", "0"))
for fixture, arguments in enumerate(fixtures):
    if fixture<start or fixture>=int(os.environ.get("THIN_END_FIXTURE",str(len(fixtures)))): continue
    for repetition in range(repeats):
        results = []
        ordered = variants if repetition % 2 == 0 else variants[::-1]
        for order, (variant, binary) in enumerate(ordered):
            run = subprocess.run([binary, *map(str, arguments)], capture_output=True, text=True, check=True)
            rows = list(csv.DictReader(io.StringIO(run.stdout)))
            proofs = [(row["stage"], row["semantic_hash"], row["pixel_digest"], row["promotions"], row["compares"], row["paint_passes"]) for row in rows]
            if results:
                assert proofs == results[0], (fixture, variant, "different actual work or visible output")
            results.append(proofs)
            for row in rows:
                output = dict(fixture=fixture, variant=variant, repetition=repetition, order=order, cpu=cpu, **row)
                if writer is None:
                    writer = csv.DictWriter(sys.stdout, fieldnames=list(output))
                    writer.writeheader()
                writer.writerow(output)
                sys.stdout.flush()
