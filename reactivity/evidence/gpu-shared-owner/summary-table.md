| Case | Windows | Rust requests | Net heap + owner | Peak heap + owner |
| --- | ---: | ---: | ---: | ---: |
| baseline same device | 1 | 9,763 | 462,262 B | 822,096 B |
| baseline per device | 1 | 9,764 | 462,266 B | 822,100 B |
| final owned same device | 1 | 9,763 | 462,286 B | 822,120 B |
| final owned per device | 1 | 9,764 | 462,290 B | 822,124 B |
| final shared | 1 | 9,763 | 462,286 B | 822,120 B |
| baseline same device | 2 | 17,850 | 838,351 B | 1,193,723 B |
| baseline per device | 2 | 19,513 | 923,832 B | 1,274,486 B |
| final owned same device | 2 | 17,850 | 838,399 B | 1,193,771 B |
| final owned per device | 2 | 19,513 | 923,880 B | 1,274,534 B |
| final shared | 2 | 10,030 | 475,297 B | 823,128 B |
| baseline same device | 8 | 66,315 | 3,081,493 B | 3,415,593 B |
| baseline per device | 8 | 78,006 | 3,709,844 B | 3,987,810 B |
| final owned same device | 8 | 66,315 | 3,081,685 B | 3,415,785 B |
| final owned per device | 8 | 78,006 | 3,710,036 B | 3,988,002 B |
| final shared | 8 | 11,571 | 539,735 B | 829,176 B |
