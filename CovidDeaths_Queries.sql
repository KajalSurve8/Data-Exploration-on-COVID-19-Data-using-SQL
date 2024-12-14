use portfolio_project;
select count(*) from coviddeaths; -- 11133 Total entries
-------------------------------------------------------------------------------------------
-- BASIC QUERIES
-- 1. Selecting everything from the table
select * from coviddeaths;

-- 2. Retrieving all data for a specific country.
select * from coviddeaths where location = 'Bulgaria';

-- 3. Getting the distinct list of continents present in the dataset.
select distinct(continent) as 'Continents' from coviddeaths;

-- 4. Retrieving data for a specific date.
select * from coviddeaths where date = '3/26/2020';

-- 5. Retrieving the first 20 rows of the dataset to explore the data.
select * from coviddeaths limit 20;

-- 6. Looking for the data for the year 2021.
select * from coviddeaths where date like '%2021%';
-------------------------------------------------------------------------------------------
-- AGGREGATION, SUMMARIES, AND GROUP BY
-- 7. Calculating the total number of deaths globally.
select sum(total_deaths) as 'Total Deaths Globally' from coviddeaths;

-- 8. Finding the average number of new cases per country.
select location, round(avg(new_cases),2) as 'Avg New Cases' from coviddeaths group by location;

-- 9. Calculating the total population of all countries combined.
select sum(population) as 'Total Population' from coviddeaths;

-- 10. Finding the total number of cases and deaths by continent.
select continent, sum(total_cases) as 'Total Cases', sum(total_deaths) 'Total Deaths' from coviddeaths group by continent;

-- 11. Calculating the average reproduction rate for each continent.
select continent, round(avg(reproduction_rate),2) from coviddeaths group by continent;
-------------------------------------------------------------------------------------------
-- FILTERING AND CONDITIONS
-- 12. Listing all countries with more than 1 mn total cases.
select distinct(location) from coviddeaths where total_cases >= 1000000;

-- 13. Retrieving data for countries in the Europe continent with more than 10,000 total deaths.
select * from coviddeaths where continent = 'Europe' and total_deaths >= 10000;

-- 14. Finding all entries where the reproduction_rate is above 1.5.
select * from coviddeaths where reproduction_rate > 1.5;

-- 15. Looking for the countries where the reproduction rate dropped below 1 after June 2021.
select location, date, reproduction_rate from coviddeaths where reproduction_rate < 1 and date > '06/01/2021';

-- 16. Comparing the number of cases and deaths for countries with a population greater than 100 million.
select location, date, population, total_cases, total_deaths from coviddeaths where population > 100000000;

-- 17. Finding the daily increase in cases for a specific country in October 2020.
select 
	continent, location, date, population, total_cases, new_cases 
from coviddeaths 
where location = 'Brazil' and date between '10/01/2020' and '10/31/2020';

-- 18. Displaying the weekly total hospital admissions for all countries.
select location, weekly_hosp_admissions from coviddeaths;
-------------------------------------------------------------------------------------------
-- SORTING AND LIMITING
-- 19. Listing the top 10 countries with the highest total deaths.
select 
	location as 'Top 10 Countries', 
	sum(total_deaths) as 'Highest Total Deaths' 
from coviddeaths 
group by location 
order by sum(total_deaths) desc limit 10;

-- 20. Retrieving the first 5 entries for the country Belarus, sorted by date.
select * from coviddeaths where location='Belarus' order by date limit 5;
-------------------------------------------------------------------------------------------
-- ADVANCED QUERIES
-- 21. Calculating the mortality rate for each country and sorting it by the highest rate.
select 
	location, 
    round((sum(total_deaths) / sum(total_cases)) * 100,2) as 'Mortality Rate' 
from coviddeaths 
group by location 
order by ((sum(total_deaths) / sum(total_cases)) * 100) desc;

-- 22. Finding the date with the highest number of new deaths globally.
select date, new_deaths as 'Highest New Deaths' from coviddeaths where new_deaths = (select max(new_deaths) from coviddeaths);

-- 23. Identifying the country with the highest new_cases_per_million on a specific date. 
select 
	location, date, new_cases_per_million 
from coviddeaths 
where date = '10/31/2020' 
order by new_cases_per_million desc 
limit 1;

-- 24. Using a subquery to list all countries where the total deaths are greater than the global average.
-- Global Avg = 77938766.5427
select 
	location, 
    sum(total_deaths) as 'Total Deaths'
from coviddeaths 
group by location
having sum(total_deaths) > (select avg(population) from coviddeaths); 

-- 25. Ranking countries by the total number of cases per million.
select location, total_cases_per_million, rank() over(order by total_cases_per_million desc) as 'Rank' from coviddeaths;

-- 26. Calculating the 7-day moving average of new cases for a specific country.
select 
	location, date, avg(new_cases) 
over(order by date rows between 6 preceding and current row) as 'Moving Avg' 
from coviddeaths where location = 'Brazil';


