# Replication Package: *Second Generation Effects of an Experimental Conditional Cash Transfer Program on Early Childhood Human Capital in Nicaragua*

Authors:
 Tania Barham, Oscar M. Díaz-Botía, Karen Macours, John A. Maluccio, Julieta Vera Rueda

## Instructions for Replication

### 1. Setting Up

- Update the folder path in `dofiles/Master - RP- Globals Nicaragua Project.do` (line 20).
- Activate *globals* and *functions* by running `dofiles/Master - RP- Globals Nicaragua Project.do`.

### 2. Running the Replication

- Execute 

  ```
  "dofiles/Run all do files - RP - Nicaragua project"
  ```

   to:

  - Clean the raw data and construct the final datasets.
  - Run the final analysis.

### 3. Tables and Output

- Final tables are generated in `dofiles/tables - RP.do`.
- This file includes all tables from the paper, arranged in order of appearance in the main text.
- Tables from the appendix are also included, sometimes appearing under the main tables as robustness checks.
- Tables will be saved in `outputs/tables/paper/`

### 4. Data Files

- The replication package uses two final datasets:
  - Household-level dataset: `Data2010_IntergenParentSample.dta`
  - Individual-level dataset: `indi_2020_below7_indexes`
