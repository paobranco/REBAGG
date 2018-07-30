## Data

This folder contains all the data sets used in the experiences of the paper.

To load the datas sets in R issue the following command:

```r
source("All20DataSets.RData")
```

A brief description of the main characteristics of data sets used is presented in the following table.

| Data Set   | N    | tpred | p.nom | p.num | nRare | % Rare |
|------------|------|-------|-------|-------|-------|--------|
| servo      | 167  | 4     | 2     | 2     | 34    | 20.4  |
| a6         | 198  | 11    | 3     | 8     | 33    | 16.7  |
| Abalone    | 4177 | 8     | 1     | 7     | 679   | 16.3  |
| machCpu    | 209  | 6     | 0     | 6     | 34    | 16.3  |
| a3         | 198  | 11    | 3     | 8     | 32    | 16.2  |
| a4         | 198  | 11    | 3     | 8     | 31    | 15.7  |
| a1         | 198  | 11    | 3     | 8     | 28    | 14.1  |
| a7         | 198  | 11    | 3     | 8     | 27    | 13.6  |
| boston     | 506  | 13    | 0     | 13    | 65    | 12.8  |
| a2         | 198  | 11    | 3     | 8     | 22    | 11.1  |
| a5         | 198  | 11    | 3     | 8     | 21    | 10.6  |
| fuelCons   | 1764 | 38    | 12    | 26    | 164   | 9.3  |
| availPwr   | 1802 | 16    | 7     | 9     | 157   |  8.7 |
| cpuSm      | 8192 | 13    | 0     | 13    | 713   | 8.7  |
| maxTorq    | 1802 | 33    | 13    | 20    | 129   | 7.2  |
| dAiler     | 7129 | 5     | 0     | 5     | 450   | 6.3  |
| bank8FM    | 4499 | 9     | 0     | 9     | 288   | 6.4  |
|ConcrStr    | 1030 | 8     | 0     | 8     | 55    | 5.3  |
| Accel      | 1732 | 15    | 3     | 12    | 89    | 5.1  |
| airfoild   | 1503 | 5     | 0     | 5     | 62    | 4.1  |

$N$: Nr of cases; 

$tpred$: Nr of predictors;

$p.nom$: Nr of nominal predictors; 

$p.num$: Nr numeric predictors;

$nRare$: nr. cases with $\phi (Y) > 0.8$;

\%$Rare$: $100 \times nRare/N$