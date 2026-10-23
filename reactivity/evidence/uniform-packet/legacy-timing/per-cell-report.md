# Frozen legacy299c matched campaign: independent regression gate failed

All 22 legs and 11 exact readback pairs completed. Correctness PASS; speed PASS; independent regression FAIL. No retries or omissions.

| Cell | Host ratio | Host gate | Total ratio | Total gate |
|---|---:|---|---:|---|
| flat/false/false | 0.818554 | frame_tail_above_1.10 | 0.892303 | PASS |
| flat/false/true | 0.737326 | frame_tail_above_1.10 | 0.849455 | frame_tail_above_1.10 |
| text/false/false | 0.935028 | frame_tail_above_1.10 | 0.712104 | PASS |
| text/false/true | 0.935242 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.688808 | PASS |
| text-bg/false/false | 0.824738 | frame_tail_above_1.10 | 0.538953 | PASS |
| text-bg/false/true | 0.837878 | frame_tail_above_1.10 | 0.541009 | PASS |
| layers8/false/false | 0.885836 | PASS | 0.023752 | PASS |
| layers8/false/true | 0.784032 | frame_tail_above_1.10 | 0.023210 | PASS |
| layers8-text/false/false | 1.079171 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.573781 | PASS |
| layers8-text/false/true | 1.026027 | at_least_nine_slower_pairs;ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.614064 | PASS |
| image-text/false/false | 1.119645 | at_least_nine_slower_pairs;ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.839160 | PASS |
| image-text/false/true | 0.969504 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.842123 | PASS |
| rounded/false/false | 1.050685 | at_least_nine_slower_pairs;ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.809339 | PASS |
| rounded/false/true | 0.974355 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.748127 | PASS |
| runs32k/false/false | 0.933590 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.936123 | ninth_ratio_above_1.01;frame_tail_above_1.10 |
| runs32k/false/true | 0.970913 | PASS | 0.966437 | PASS |
| singletons32k/false/false | 0.956207 | ninth_ratio_above_1.01 | 0.962796 | frame_tail_above_1.10 |
| singletons32k/false/true | 0.951667 | frame_tail_above_1.10 | 0.951735 | frame_tail_above_1.10 |
| layers8/true/false | 0.889523 | frame_tail_above_1.10 | 0.024293 | PASS |
| layers8/true/true | 0.799809 | frame_tail_above_1.10 | 0.023540 | PASS |
| layers8-text/true/false | 0.964315 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.577457 | PASS |
| layers8-text/true/true | 1.049217 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.611969 | PASS |
| image-text/true/false | 1.122347 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.847574 | PASS |
| image-text/true/true | 1.028046 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.841737 | PASS |
| rounded/true/false | 1.094577 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.788140 | PASS |
| rounded/true/true | 1.005950 | ninth_ratio_above_1.01;frame_tail_above_1.10 | 0.724322 | PASS |
