# Fixed campaign result: unadopted

All 22 legs exited 0. Correctness passed; regression and speed gates failed.
No retries, changed gates, dropped workloads, quiet breaches or watchdog failures.

| Cell (case/HDR/motion) | Host ratio | Host pass | Total ratio | Total pass |
|---|---:|:---:|---:|:---:|
| flat/false/false | 1.055977 | False | 0.985538 | False |
| flat/false/true | 1.051832 | False | 0.902708 | False |
| text/false/false | 1.024906 | False | 0.812095 | True |
| text/false/true | 1.034230 | False | 0.800815 | True |
| text-bg/false/false | 0.988056 | False | 0.608495 | True |
| text-bg/false/true | 0.941551 | False | 0.611583 | True |
| layers8/false/false | 2.380413 | False | 0.026847 | True |
| layers8/false/true | 2.419532 | False | 0.027020 | True |
| layers8-text/false/false | 2.003526 | False | 0.633179 | True |
| layers8-text/false/true | 2.055439 | False | 0.666695 | True |
| image-text/false/false | 1.071639 | False | 0.906094 | True |
| image-text/false/true | 1.056643 | False | 0.877371 | True |
| rounded/false/false | 0.991608 | False | 0.863626 | True |
| rounded/false/true | 0.922021 | False | 0.801894 | True |
| runs32k/false/false | 1.119819 | False | 1.094277 | False |
| runs32k/false/true | 1.072507 | False | 1.044610 | False |
| singletons32k/false/false | 1.004298 | False | 0.970713 | False |
| singletons32k/false/true | 1.018905 | False | 0.988368 | False |
| layers8/true/false | 2.399346 | False | 0.028568 | True |
| layers8/true/true | 2.287670 | False | 0.026861 | True |
| layers8-text/true/false | 2.022902 | False | 0.640891 | True |
| layers8-text/true/true | 2.328149 | False | 0.674976 | True |
| image-text/true/false | 1.173510 | False | 0.909754 | True |
| image-text/true/true | 1.139874 | False | 0.889848 | True |
| rounded/true/false | 0.994582 | False | 0.871031 | True |
| rounded/true/true | 0.915335 | False | 0.799100 | True |

Ratios are candidate/shipping medians of paired process medians. Every raw clock remains in nanoseconds.
Exact ninth-order ratios, slower counts and maximum-frame failures are in per-cell-gate-ledger.csv.
Full original Stats/ImageStats and exact row paths for every worst frame are in worst-frame-rows.json.
llvmpipe software Vulkan only; device polling is synchronization wall time, not a GPU timestamp.
