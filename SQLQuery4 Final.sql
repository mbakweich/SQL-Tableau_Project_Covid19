select *
from PortfolioProjectCovid19..CovidDeaths
Where continent is not null
order by 3,4

--select *
--from PortfolioProjectCovid19..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjectCovid19..CovidDeaths
order by 1,2


--- Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProjectCovid19..CovidDeaths
Where location like '%state%'
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProjectCovid19..CovidDeaths
Where location = 'Canada'
order by 1,2

--Looking at the Total Cases vs Population
--shows what percentage of population got Covid

Select Location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
Where continent is not null
order by 1,2

--looking at Countries with Highest infection rate compared to population

Select Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
Where continent is not null
Group by Location, population
order by PercentPopulationInfected Desc

--Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
Where continent is not null
Group by Location
order by TotalDeathCount Desc


--Lets Break things down by Continent

Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
Where continent is not null
Group by continent
order by TotalDeathCount Desc

--Select location, MAX(cast(total_deaths as int)) AS TotalDeathCount
--From PortfolioProjectCovid19..CovidDeaths
----Where location like '%state%'
--Where continent is null
--Group by location
--order by TotalDeathCount Desc


---Showing the Continent with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
Where continent is not null
Group by continent
order by TotalDeathCount Desc

--Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
where continent is not null
Group by date
order by 1,2


--Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date)
From PortfolioProjectCovid19..CovidDeaths dea
Join PortfolioProjectCovid19..CovidVaccinations vac
 ON dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
Order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectCovid19..CovidDeaths dea
Join PortfolioProjectCovid19..CovidVaccinations vac
 ON dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
Order by 2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectCovid19..CovidDeaths dea
Join PortfolioProjectCovid19..CovidVaccinations vac
 ON dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


---USING A TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table  #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectCovid19..CovidDeaths dea
Join PortfolioProjectCovid19..CovidVaccinations vac
 ON dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



---Note Cast(....as int) or you can use Convert(int,....)


--Creating View to store Data for Later Visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectCovid19..CovidDeaths dea
Join PortfolioProjectCovid19..CovidVaccinations vac
 ON dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
--Order by 2,3


select *
from PercentPopulationVaccinated


--- for Visualization in Tabeau, we copy and save tables to excel files. This is because Tabeau public gives limited assess

---1

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
where continent is not null
--Group by date
order by 1,2


---2
-- We take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) AS TotalDeathCount
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
Where continent is null
and location not in ('world', 'European Union', 'International')
Group by location
order by TotalDeathCount Desc


---3

Select Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
--Where continent is not null
Group by Location, population
order by PercentPopulationInfected Desc


---4

Select Location, population, date, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
From PortfolioProjectCovid19..CovidDeaths
--Where location like '%state%'
--Where continent is not null
Group by Location, population, date
order by PercentPopulationInfected Desc

