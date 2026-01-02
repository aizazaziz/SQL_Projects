

select *
from layoffs; 

-- remove duplicates
-- standardise the data
-- remove null or blanks
-- remove any columns

create table layoff
like layoffs;

select *
from layoff;

insert layoff
select *
from layoffs;


select *,
row_number() over(
partition by company, industry, total_laid_off,
percentage_laid_off, 'date') as row_num
from layoffs;

with duplicate_cte as 
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off,
percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs
)
delete 
from duplicate_cte
where row_num > 1;

CREATE TABLE `layoff2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



select *
from layoff2
where row_num > 1 ;

insert into layoff2

select *,
row_number() over(
partition by company, location, industry, total_laid_off,
percentage_laid_off, 'date', stage, 
country, funds_raised_millions) as row_num
from layoffs;


delete 
from layoff2
where row_num > 1 ;


select *
from layoff2
;
-- standard 

select company, trim(company)
from layoff2;
 
 update layoff2
 set company = trim(company);

select distinct industry
from layoff2
where industry is not null
order by 1;

DELETE FROM layoff2
WHERE industry IS NULL;

select distinct industry
from layoff2
where industry is not null
order by 1;
