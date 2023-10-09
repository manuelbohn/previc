## PREVIC: An adaptive parent report measure of expressive vocabulary in children between 3 and 8 years of age

------------------------------------------------------------------------

> Data and analysis scripts associated with the following paper

------------------------------------------------------------------------

-   Bohn, M., Prein, J., Engicht, J., Haun, D. B. M., Gagarina, N., & Koch, T. (2023). [PREVIC: An adaptive parent report measure of expressive vocabulary in children between 3 and 8 years of age](https://psyarxiv.com/4z86w). *PsyArXiv*.

### Usage

Link to task (in German): [PREVIC](https://ccp-odc.eva.mpg.de/previc-demo/)

### Structure

```         
.
├── scripts
    ├── analysis.Rmd          <-- all analysis code, including item selection and validity study
    ├── val_adaptive.Rmd      <-- guide for how to reproduce the validation study of the ML estimator used for the adaptive test
    ├── validate_ML_est       <-- files needed for validation
    └── visuals.Rmd           <-- reproduce figures in paper
├── data                      <-- data files
    └── final_item_list.csv   <-- list of items in the PREVIC
├── graphs                    <-- figures in paper
├── paper                     <-- reproducible manuscript file
└── saves                     <-- saved model outputs
```
