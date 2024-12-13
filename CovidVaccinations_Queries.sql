use portfolio_project;
select count(*) from covidvaccinations; -- 12351 Total entries
select * from covidvaccinations;
-------------------------------------------------------------------------------------------
-- BASIC QUERIES
-- 1. Displaying the first 15 rows of the dataset
select * from covidvaccinations limit 15;

-- 2. Retrieving data for a specific country
select * from covidvaccinations where location = 'India';

-- 3. Listing all records where the total vaccinations exceed 1 million
select * from covidvaccinations where total_vaccinations > 1000000;
-------------------------------------------------------------------------------------------
-- AGGREGATION AND GROUP BY
-- 4. Calculating the total number of vaccinations administered globally
select sum(total_vaccinations) as 'Total Vaccinations Globally' from covidvaccinations;

-- 5. Finding the total vaccinations by continent
select continent, sum(total_vaccinations) as 'Total Vaccinations' from covidvaccinations group by continent;

-- 6. Calculating the average number of people fully vaccinated per hundred for each continent 
select 
	continent, round(avg(people_vaccinated_per_hundred),2) as 'Avg People Vaccinated per Hundred' 
from covidvaccinations 
group by continent;
-------------------------------------------------------------------------------------------
-- COMPARISONS
-- 7. Identifying the countries with the highest total vaccinations per hundred
select location, max(total_vaccinations_per_hundred) from covidvaccinations group by location;

-- 8. Comparing the vaccination rates between countries with a population density above 500
select 
	location, population_density, total_vaccinations_per_hundred 
from covidvaccinations where population_density > 500;
-------------------------------------------------------------------------------------------
-- TREND ANALYSIS
-- 9. Showing the daily number of new vaccinations for a specific country in January 2020
select new_vaccinations from covidvaccinations where location = 'India' and date between 01/01/2020 and 01/31/2020;

-- 10. Analyzing the 7-day smoothed trend of new vaccinations globally
select date, sum(new_vaccinations) as 'New Vaccinations Globally' from covidvaccinations group by date order by date;
-------------------------------------------------------------------------------------------
-- FILTERING AND CONDITIONS
-- 11. Listing countries where the stringency index is above 70 and vaccination rate (people vaccinated per hundred) is less than 20
select 
	location, stringency_index, people_vaccinated_per_hundred 
from covidvaccinations 
where stringency_index > 70 and people_vaccinated_per_hundred < 20;

-- 12. Finding the countries with life expectancy below 65 and high extreme poverty rates
select location, life_expectancy, extreme_poverty from covidvaccinations where life_expectancy < 65 order by extreme_poverty desc;
-------------------------------------------------------------------------------------------
-- ADVANCED QUERIES
-- 13. Ranking the countries by the percentage of people fully vaccinated
select 
	location, date, ((people_fully_vaccinated * 100) / total_vaccinations) as 'Percent of People Fully Vaccinated', 
rank() over(order by ((people_fully_vaccinated * 100) / total_vaccinations) desc) as 'Ranking' 
from covidvaccinations; 

-- 14. Identifying the relationship between hospital beds per thousand and vaccination rates
select 
	location, date, hospital_beds_per_thousand, people_vaccinated_per_hundred 
from covidvaccinations 
where people_vaccinated_per_hundred != '';

-- 15. Calculating the percentage of the population vaccinated for countries with high GDP per capita
select 
	location, ((people_fully_vaccinated * 100) / total_vaccinations) as 'Percent of People Fully Vaccinated'
from covidvaccinations 
where location = (select location from covidvaccinations order by gdp_per_capita desc limit 1);