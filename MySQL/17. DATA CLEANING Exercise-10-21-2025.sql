-- Data Cleaning

SELECT *
FROM layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns



CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;



SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


SELECT *
FROM layoffs_staging
WHERE company = 'Casper';




WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;



CREATE TABLE `layoffs_staging5` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging5;


INSERT INTO layoffs_staging5
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging5
WHERE row_num > 1;

SELECT *
FROM layoffs_staging5;

DELETE
FROM layoffs_staging5
WHERE row_num > 1;

SELECT *
FROM layoffs_staging5;

-- Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging5;

UPDATE layoffs_staging5
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging5;


UPDATE layoffs_staging5
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging5
ORDER BY 1;

UPDATE layoffs_staging5
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';



SELECT `date`
FROM layoffs_staging5;


UPDATE layoffs_staging5
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');


ALTER TABLE layoffs_staging5
MODIFY COLUMN `date` DATE;


SELECT *
FROM layoffs_staging5
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging5
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging5
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging5
WHERE company LIKE 'Bally%';

SELECT t1.industry, t2.industry
FROM layoffs_staging5 t1
JOIN layoffs_staging5 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;  

UPDATE layoffs_staging5 t1 
JOIN layoffs_staging5 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry    
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL; 

SELECT *
FROM layoffs_staging5;


SELECT *
FROM layoffs_staging5
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;




DELETE
FROM layoffs_staging5
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging5;

ALTER TABLE layoffs_staging5
DROP COLUMN row_num;
