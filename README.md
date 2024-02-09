### PROJECT USING SQL AND TABLEAU AS ANALYSIS AND VISUALIZATION TOOLS

## CORONAVIRUS (COVID-19) DEATHS – ANALYSIS

### Project Overview

This project aims to analyze the global and regional figures emanating from the Covid-19 pandemic. Efforts were made to display the trends across different countries as well as making predictive analysis. A dynamic dashboard was also built to tell the stories with a simple glance.

### Data Sources

The data for this analysis was primarily downloaded from ‘Our World in Data’ using the [Link](https://ourworldindata.org/covid-deaths)

### Tools

* Excel - Data download and reformatting
* Microsoft SQL - Uploading excel sheets to SQL database, performing analysis and creating tables for visualizations
* Tableau Public - For creating interactive visuals and dashboards. [Link](https://public.tableau.com/app/profile/chukwuemeka.mbakwe/viz/CovidDashboard_17073594821610/Dashboard1)

### Data Preparation

1. Downloaded data from our world in data was reformatted in excel sheets and saved as two separate sheets.

   a. Covid-deaths ( containing information on the number of deaths)

   b. Covid-vaccinations ( containing informations on vaccination status)

   Note: These steps limit my usage of the JOIN syntax in my queries.
   
3. I created a portfolio database in microsoft SQL and uploaded my excel sheets to the DB.

### Data Analysis

The new tables were then queried to answer some exploratory questions.

Below are some of the questions and the corresponding queries used to answer them:

a. What is the total number of deaths expressed as a percentage of the total cases in Canada?

```sql
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProjectCovid19..CovidDeaths
Where location = 'Canada'
order by 1,2;
```

b. Countries with the highest infection rate compared to population.

```sql 	
Select Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
Where continent is not null
Group by Location, population
order by PercentPopulationInfected Desc;
```

Other Exploratory data questions reviewed were:
1. Global death toll

  ```sql
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
where continent is not null
--Group by date
order by 1,2;
```

![Screenshot 2024-02-09 144807](https://github.com/mbakweich/PortfolioProjects/assets/147742980/10286679-4515-4179-9bc6-c5335bfb9c3e)


2. Total deaths per Continent

```sql
Select location, SUM(cast(new_deaths as int)) AS TotalDeathCount
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
Where continent is null
and location not in ('world', 'European Union', 'International')
Group by location
order by TotalDeathCount Desc;
```

![Screenshot 2024-02-09 144906](https://github.com/mbakweich/PortfolioProjects/assets/147742980/78fb6cee-ff04-4e46-85fc-389133b80761)


3. Percentage population infected per country

```sql
Select Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
--Where continent is not null
Group by Location, population
order by PercentPopulationInfected Desc;
```

![Screenshot 2024-02-09 144942](https://github.com/mbakweich/PortfolioProjects/assets/147742980/5a9a5b21-6cbc-4367-9d5f-530dbfabc586)


4. Average infection trends

```sql
Select Location, population, date, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
--Where continent is not null
Group by Location, population, date
order by PercentPopulationInfected Desc;
```

![Screenshot 2024-02-09 145007](https://github.com/mbakweich/PortfolioProjects/assets/147742980/3f78bab5-57bc-4a1e-88d9-29dfd1a72784)


Results were saved as excel files and afterwards imported to tableau public for interactive visualizations.

Below are the visuals created using Tableau public – link to interactive dashboard is given.

![Covid Tableau Dashboard](https://github.com/mbakweich/PortfolioProjects/assets/147742980/adc16a09-7b7c-4554-9697-71a2aeba5b7c)


Link to Dashboard – [Tableau Dashboard](https://public.tableau.com/app/profile/chukwuemeka.mbakwe/viz/CovidDashboard_17073594821610/Dashboard1)


### References

- Our World in Data. (nd). https://ourworldindata.org/covid-deaths
- Alex The Analyst, (2022) Data Analyst Portfolio Project | SQL Data Exploration. https://www.youtube.com/watch?v=qfyynHBFOsM 



