SELECT *
FROM PortfolioDB..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PortfolioDB..CovidVaccinations$
--ORDER BY 3,4

-- Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioDB..CovidDeaths$
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract Covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioDB..CovidDeaths$
WHERE location like '%states%'
ORDER BY 1,2


--Looking at Total Cases vs Popluation
-- Shows percentage of population got Covid
SELECT location, date, total_cases, population, (total_cases/population)*100 AS DeathPercentage
FROM PortfolioDB..CovidDeaths$
WHERE location like '%states%'
ORDER BY 1,2


-- Looking at countires with highest infection rate compared to populatiopn
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioDB..CovidDeaths$
--WHERE location like '%south%'
GROUP BY location, population
ORDER BY PercentPopulationInfected desc



-- Showing Countries with Highest Death Count per Population
SELECT location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioDB..CovidDeaths$
--WHERE location like '%south%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc

-- By Contient




-- Showing contients with the highest death count per population

SELECT continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioDB..CovidDeaths$
--WHERE location like '%south%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc




-- Global Numbers

SELECT SUM(new_cases) AS total_cases,SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioDB..CovidDeaths$
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

-- Looking at Total Population vs Vaccinations

--USE CTE
WITH PopvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated) 
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
RollingPeopleVaccinated 
--(RollingPeopleVaccinated/population)*100
FROM PortfolioDB..CovidDeaths$ dea
JOIN PortfolioDB..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac


--Temp Table
DROP TABLE  IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

INSERT INTO #PercentPopulationVaccianted
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
RollingPeopleVaccinated 
--(RollingPeopleVaccinated/population)*100
FROM PortfolioDB..CovidDeaths$ dea
JOIN PortfolioDB..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--Creating views to store data for later visualization

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
RollingPeopleVaccinated 
--(RollingPeopleVaccinated/population)*100
FROM PortfolioDB..CovidDeaths$ dea
JOIN PortfolioDB..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

--Asia
CREATE VIEW PercentPopulationVaccinatedAsia AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
RollingPeopleVaccinated 
--(RollingPeopleVaccinated/population)*100
FROM PortfolioDB..CovidDeaths$ dea
JOIN PortfolioDB..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent LIKE '%asia%'

-- North America
CREATE VIEW PercentPopulationVaccinatedNA AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
RollingPeopleVaccinated 
--(RollingPeopleVaccinated/population)*100
FROM PortfolioDB..CovidDeaths$ dea
JOIN PortfolioDB..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent LIKE '%north america%'

-- South America

CREATE VIEW PercentPopulationVaccinatedSA AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
RollingPeopleVaccinated 
--(RollingPeopleVaccinated/population)*100
FROM PortfolioDB..CovidDeaths$ dea
JOIN PortfolioDB..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent LIKE '%south america%'

--Europe

CREATE VIEW PercentPopulationVaccinatedEuro AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
RollingPeopleVaccinated 
--(RollingPeopleVaccinated/population)*100
FROM PortfolioDB..CovidDeaths$ dea
JOIN PortfolioDB..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent LIKE '%europe%'


--Africa
CREATE VIEW PercentPopulationVaccinatedAfrica AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS
RollingPeopleVaccinated 
--(RollingPeopleVaccinated/population)*100
FROM PortfolioDB..CovidDeaths$ dea
JOIN PortfolioDB..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent LIKE '%africa%'

SELECT *
FROM PercentPopulationVaccinatedAfrica