use portfolio_project;
select * from coviddeaths;
select * from covidvaccinations;
-------------------------------------------------------------------------------------------
-- BASIC QUERIES OF JOINING DATA
-- 1. Retrieving basic information from both tables for a specific country
select 
	d.continent, d.location, d.date, d.population, d.total_cases, d.total_deaths, 
    v.total_vaccinations, v.people_vaccinated
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date;

-- 2. Showing total deaths and vaccination data for the top 5 countries with the highest total deaths
select 
	d.location, d.total_deaths, 
    v.total_vaccinations, v.people_fully_vaccinated
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date
order by d.total_deaths desc limit 5;

-- 3. Listing the countries where the total cases per million is high, but the vaccination rate is low
select 
	d.location, d.total_cases_per_million, 
    v.people_vaccinated_per_hundred 
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date
order by d.total_cases_per_million desc, v.people_vaccinated_per_hundred asc;
-------------------------------------------------------------------------------------------
-- AGGREGATIONS
-- 4. Finding the total vaccinations and deaths for each continent
select 
	d.continent, sum(d.total_deaths) 'Total Deaths',
    sum(v.total_vaccinations) 'Total Vaccinations'
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date
group by d.continent;

-- 5. Calculating the average new cases and new vaccinations per day for each continent
select 
	d.continent, round(avg(d.new_cases),2) 'Avg New Cases',
    round(avg(v.new_vaccinations),2) 'Avg New Vaccinations'
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date
group by d.continent;

-- 6. Ranking countries by the percentage of people fully vaccinated compared to the total deaths
select 
	d.location, 
    round((sum(v.people_fully_vaccinated) * 100)/ sum(d.population),2) 'Percent of population fully vaccinated',
    round(sum(d.total_deaths),2) 'Total Deaths',
    rank() over(order by round((sum(v.people_fully_vaccinated) * 100)/ sum(d.population),2) desc) as 'Rank'
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date
group by d.location;
-------------------------------------------------------------------------------------------
-- TREND ANALYSIS
-- 7. Analyzing the daily trend of new cases and vaccinations for a specific country
select 
	d.location, d.date, d.new_cases, 
    v.total_vaccinations, v.people_fully_vaccinated
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date
where d.location = 'Azerbaijan';

-- 8. Identifying the global daily totals for new cases and vaccinations
select 
	d.location, d.date, d.new_cases, 
    v.total_vaccinations, v.people_fully_vaccinated
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date;
-------------------------------------------------------------------------------------------
-- COMPARISONS
-- 9. Comparing total population vs. vaccinations.
select 
	d.location, d.population, d.date,
    v.new_vaccinations 
from coviddeaths d 
join covidvaccinations v 
on d.location = v.location and d.date = v.date;

-- 10. Finding the vaccination rates compared to deaths.
select 
	d.location, d.date, d.total_deaths, 
    v.total_vaccinations, v.people_fully_vaccinated
from coviddeaths d 
join covidvaccinations v 
on d.location = v.location and d.date = v.date;

-- 11. Comparing hospital beds per thousand with the vaccination rates for countries
select 
	d.location, d.date, d.hosp_patients, 
    v.people_vaccinated_per_hundred
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date;

-- 12. Identifying countries with a high diabetes prevalence and low vaccination rates
select 
	d.location, 
    v.diabetes_prevalence, v.people_vaccinated_per_hundred
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date
order by v.diabetes_prevalence desc, v.people_vaccinated_per_hundred;

-- 13. Finding countries with high stringency index and low vaccination rates
select 
	d.location, 
    v.stringency_index, v.people_vaccinated_per_hundred
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date
order by v.stringency_index desc, v.people_vaccinated_per_hundred;
-------------------------------------------------------------------------------------------
-- ADVANCED ANALYSIS
-- 14. Calculating the percentage of the population vaccinated for countries with extreme poverty
select 
	d.location, 
    round((sum(v.people_fully_vaccinated) * 100)/ sum(d.population),2) 'Percent of population vaccinated', 
    round(sum(v.extreme_poverty),2) 'Extreme poverty'
from coviddeaths d 
join covidvaccinations v
on d.location = v.location and d.date = v.date
group by d.location;