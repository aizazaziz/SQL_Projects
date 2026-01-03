-- 🧹 SQL Data Cleaning Pipeline
-- Create a working copy (never clean raw data)
CREATE TABLE layoff_clean
LIKE layoffs;

INSERT INTO layoff_clean
SELECT *
FROM layoffs;

-- Remove duplicates

SELECT company, location, industry, total_laid_off, percentage_laid_off,
       `date`, stage, country, funds_raised_millions,
       COUNT(*) AS cnt
FROM layoff_clean
GROUP BY company, location, industry, total_laid_off, percentage_laid_off,
         `date`, stage, country, funds_raised_millions
HAVING cnt > 1;

-- Delete duplicates

ALTER TABLE layoff_clean
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

DELETE FROM layoff_clean
WHERE id NOT IN (
    SELECT id FROM (
        SELECT MIN(id) AS id
        FROM layoff_clean
        GROUP BY company, location, industry, total_laid_off,
                 percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) t
);


-- Standardize the data

-- Trim space

UPDATE layoff_clean
SET company = TRIM(company),
    industry = TRIM(industry),
    country = TRIM(country);

-- Fix inconsistent values

-- Example: Crypto variations
UPDATE layoff_clean
SET industry = 'Crypto'
WHERE industry IN ('Crypto ', 'crypto', 'CRYPTO');

-- Example: United States
UPDATE layoff_clean
SET country = 'United States'
WHERE country LIKE 'United States%';

-- Convert date column properly

UPDATE layoff_clean
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoff_clean
MODIFY COLUMN `date` DATE;

-- Remving null
-- convert blanks to null first


UPDATE layoff_clean
SET industry = NULL
WHERE industry = '';

-- Fill missing industry using same company

UPDATE layoff_clean t1
JOIN layoff_clean t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;


-- Removing unusable rows

DELETE FROM layoff_clean
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


ALTER TABLE layoff_clean
DROP COLUMN funds_raised_millions;

SELECT *
FROM layoff_clean
LIMIT 10;











