




SELECT *

FROM [Portfolio Project]..CovidDeaths
Where continent is not null
Order By 3,4


--SELECT *

--FROM [Portfolio Project]..CovidVacinations

--Order By 3,4


-- Select Data that we are going to be using


SELECT location, date, total_cases, new_cases, total_deaths, population

FROM [Portfolio Project]..CovidDeaths
Where continent is not null
Order By 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid-19 in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%South Africa%' and continent is not null
Order By 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentOfPopulationInfected
FROM [Portfolio Project]..CovidDeaths
WHERE location like '%South Africa%'
Order By 1,2


--Looking at Counrtries with Highest Infection Rate compared to Population


SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentOfPopulationInfected
FROM [Portfolio Project]..CovidDeaths
Group by location,population
Order By 4 desc

--Showing Countries with Highests Death Count per Population

SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
Where continent is not null
Group by location
Order By 2 desc


--Let`s break things down by Continent


SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
Where continent is not null
Group by continent
Order By 2 desc

-- Showing continents with the highest death count per population

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
Where continent is not null
Group by continent
Order By 2 desc

--Showing global numbers

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentageGlobal
From [Portfolio Project].dbo.CovidDeaths
WHERE continent is not null
Group By date
order by 1,2


--Looking at Total Population vs Vaccinations
--Use CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS
(
Select Distinct dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations))
OVER (Partition by dea.location Order by dea.location, dea.Date) AS RollingPeopleVaccinated

From [Portfolio Project]..CovidDeaths as dea
JOIN [Portfolio Project]..CovidVacinations as vac 
	ON  dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--order by 2, 3
)

Select *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac



--Use Temp table

DROP Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
Select Distinct dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations))
OVER (Partition by dea.location Order by dea.location, dea.Date) AS RollingPeopleVaccinated

From [Portfolio Project]..CovidDeaths as dea
JOIN [Portfolio Project]..CovidVacinations as vac 
	ON  dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--order by 2, 3


Select *, (RollingPeopleVaccinated/Population)*100
FROM PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as

Select Distinct dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations))
OVER (Partition by dea.location Order by dea.location, dea.Date) AS RollingPeopleVaccinated

From [Portfolio Project]..CovidDeaths as dea
JOIN [Portfolio Project]..CovidVacinations as vac 
	ON  dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--Order by 2, 3