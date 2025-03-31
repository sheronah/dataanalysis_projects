SELECT*FROM layoffs_backup;

WITH duplicate_cte AS (
    SELECT 
        company, 
        location, 
        industry, 
        total_laid_off, 
        percentage_laid_off, 
        `date`, 
        stage, 
        country, 
        funds_raised_millions, 
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, 
                         percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM layoffs_backup
)
SELECT * FROM duplicate_cte WHERE row_num > 1;  -- This filters out only duplicate rows
SELECT * FROM layoffs_backup
WHERE company = 'Autobooks';

CREATE TABLE `layoffs_backup2` (
  `company` varchar(29) DEFAULT NULL,
  `location` varchar(16) DEFAULT NULL,
  `industry` varchar(15) DEFAULT NULL,
  `total_laid_off` varchar(14) DEFAULT NULL,
  `percentage_laid_off` varchar(19) DEFAULT NULL,
  `date` varchar(10) DEFAULT NULL,
  `stage` varchar(14) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `funds_raised_millions` varchar(21) DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
SELECT*FROM layoffs_backup2;

INSERT INTO layoffs_backup2
 SELECT 
        company, 
        location, 
        industry, 
        total_laid_off, 
        percentage_laid_off, 
        `date`, 
        stage, 
        country, 
        funds_raised_millions, 
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, 
                         percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM layoffs_backup;
    
    
    SELECT * FROM layoffs_backup2 
    WHERE row_num > 1;
    
    
    DELETE FROM layoffs_backup2
    WHERE row_num > 1;
    
    
SELECT*FROM layoffs_backup2;

-- standardizing data trim removes extra white space
SELECT company,TRIM(company)  
FROM   layoffs_backup2;
-- after selecting, always update for changes to be appliied 
UPDATE layoffs_backup2
SET company = TRIM(company);


SELECT *  
FROM   layoffs_backup2
where industry LIKE 'crypto%';

-- updating companies with cryptocurrency name to crypto cz its the same 

UPDATE layoffs_backup2
SET industry = 'crypto'
where industry LIKE 'crypto%';

-- removing a . on united states
SELECT  distinct country, trim(TRAILING '.'FROM country)
FROM   layoffs_backup2
where country LIKE 'United States%'
order by 1;
-- updating the country
UPDATE layoffs_backup2
set country = TRIM(TRAILING '.'FROM country)
WHERE country LIKE 'United States%';

-- changing date to right data type
SELECT `date`, 
       STR_TO_DATE(`date`, '%m/%d/%Y') 
FROM layoffs_backup2;

-- changing the date to the correct formatt
UPDATE layoffs_backup2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` LIKE '%/%/%'; -- Filters out YYYY-MM-DD values



alter table layoffs_backup2
modify column `date` date;
    
    
    select*
    from layoffs_backup2;
-- step3 removing nulls 
-- setting all where industry is empty to Null
UPDATE layoffs_backup2
SET industry = null
where industry = '';

-- checking for both null and empty befor setting everything to null
SELECT *
FROM layoffs_backup2
where industry IS NULL
OR industry = '';

-- select query for trial
SELECT t1.industry,t2.industry 
FROM layoffs_backup2 t1
JOIN layoffs_backup2 t2
 on t1.company = t2.company
where (t1.industry IS NULL or t1.industry = '')
and t2.industry IS NOT NULL ;
-- updating to apply changes   

UPDATE layoffs_backup2 t1
JOIN layoffs_backup2 t2
   on t1.company = t2.company
SET t1.industry = t2.industry
where t1.industry IS NULL 
and t2.industry IS NOT NULL ;

select*
from layoffs_backup2
where company = 'Airbnb';

select*
from layoffs_backup2;

-- restoring my dates back after running a query removing null values in total laid offs which didnt work
UPDATE layoffs_backup2
SET `date` = CURRENT_DATE
WHERE `date` IS NULL;
-- when i run this query it returns blank fields 
select*
from layoffs_backup2
where total_laid_off = ''
and percentage_laid_off = '';


select*
from layoffs_backup2


