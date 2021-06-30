

/*
 skills used: Joins, CTE's. Aggregate Functions, Windows Functions, Converting Data Types
 
 COVID 19 exploration
 */

-- data we are starting with
select location, date, total_cases, new_cases, total_deaths, population
from covid_deaths cd 
where continent is not NULL 
order by 1,2

-- Likelihood of dying if covid contracted in certain country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid_deaths
where location like '%states%'
and continent is not NULL 
order by 1,2;

-- Total cases vs population
-- what percent of population is infected
select location, date, population, total_cases, (total_cases/population)*100 as PercentInfection
from covid_deaths
order by 1,2


-- Hiighest infection rate countries
select location, population, MAX(total_cases), as HighestInfectionCount, MAX((total_cases/population))*100 as PercentInfection
from covid_deaths cd 
group by location, population 
order by PercentInfection desc;

-- countries with highest death count per population
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from covid_deaths
where continent is not NULL 
group by location
order by TotalDeathCount desc;



-- CONTINENT NUMBERS

-- continents with highest death count per population
select continet, MAX(cast(total_deaths as int)) as TotalDeathCount
from covid_deaths
where continent is not NULL
group by continent 
order by TotalDeathCount desc;



-- global numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- where location like '%states%'
where continent is not null 
order by 1,2

select dea.date, dea.continent, dea.location, vac.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rolling 
-- , max(Rolling)/max(vac.population)*100
from Portfolio_Project.covid_deaths dea
join Portfolio_Project.covid_vaccines vac
	on dea.location = vac.location
	and on dea.date = vac.date
where dea.continent is not null
order by 2,3;




-- USE CTE because we want to use Rolling, but we just created it. 
with PopvsVacc (Continent, Date, location, new_vaccinations, Population, Rolling)
as
(
select dea.continent, dea.date, dea.location, vac.new_vaccinations, vac.population
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.Date) as Rolling 
from Portfolio_Project.covid_deaths dea
join Portfolio_Project.covid_vaccines vac
	on dea.location = vac.location
	and on dea.date = vac.date
where dea.continent is not null
)
select*, (Rolling/Population)*100
from PopvsVacc;


