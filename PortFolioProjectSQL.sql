-- FirstPortFolioProject made by watching tutorials of ALEX THE ANALYST do check out his youtube channel
--Here is the visualization
https://public.tableau.com/views/PortFolioProjectCovidData/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link


select * 
from portfolioproject.dbo.coviddeath$
order by 3,4 ;


select * 
from portfolioproject.dbo.covidvaccination$
order by 3,4



/*selecting the data that we are going to use*/


SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    portfolioproject.dbo.coviddeath$
order by 1,2	;
    
    
/* Looking at   total deaths vs total cases*/    
SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    portfolioproject.dbo.coviddeath$
order by 1,2;



/*Looking at total cases vs population*/
SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    (total_cases / population) * 100 AS InfectedPercentage
FROM
    portfolioproject.dbo.coviddeath$
order by 1,2	;
  

/*Looking at counteries with highest infection rate compared to population */
SELECT 
    location,
    population,
    MAX(total_cases) AS Highest_Infection_Count,
    MAX((total_cases / population)) * 100 AS MaxInfectedPercentage
FROM
    portfolioproject.dbo.coviddeath$
GROUP BY location , population
ORDER BY MaxInfectedPercentage DESC;


/*Showing countries with the highest death counts */
SELECT 
    location,
    max( CAST( total_deaths as int)) AS TotalDeathCount
FROM
    portfolioproject.dbo.coviddeath$
WHERE
    continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


/*Breaking down by continents*/

--showing continents by highest death counts
SELECT 
    continent,

    MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM
    portfolioproject.dbo.coviddeath$
WHERE
    continent IS NOT NULL
   
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS

select date , sum(new_cases) as TotalNewCases  , sum(cast(new_deaths as int)) as TotalNewDeaths,
(sum(cast(new_deaths as int))/ sum(new_cases))*100 as DeathPercentage
from  portfolioproject.dbo.coviddeath$
where continent is not null
group by date
order by 1,2 ;

-- Joining two tables 

select *
from portfolioproject.dbo.coviddeath$ as dea
join portfolioproject.dbo.covidvaccination$ as vac
	on dea.location = vac.location
	and  dea.date = vac.date

-- want to see total population vs total vaccinations

select dea.continent, dea.location ,dea.date , dea.population , vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioproject.dbo.coviddeath$ as dea
join portfolioproject.dbo.covidvaccination$ as vac
	on dea.location = vac.location
	and  dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- USING CTE

with PopVsVac ( Continent,Location,Date,Population,New_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location ,dea.date , dea.population , vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioproject.dbo.coviddeath$ as dea
join portfolioproject.dbo.covidvaccination$ as vac
	on dea.location = vac.location
	and  dea.date = vac.date
where dea.continent is not null 
)
select * ,(RollingPeopleVaccinated/Population)*100 as PercentageOFPeopleVaccinated
from PopVsVac ;


-- Temp Table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255) ,
Location nvarchar(255),
Date datetime ,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated 
select dea.continent, dea.location ,dea.date , dea.population , vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioproject.dbo.coviddeath$ as dea
join portfolioproject.dbo.covidvaccination$ as vac
	on dea.location = vac.location
	and  dea.date = vac.date
where dea.continent is not null 

select * ,(RollingPeopleVaccinated/Population)*100 as PercentageOFPeopleVaccinated
from #PercentPopulationVaccinated ;

--Creating view for later visualizations

create view PercentPopulationVaccinated as 
select dea.continent, dea.location ,dea.date , dea.population , vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioproject.dbo.coviddeath$ as dea
join portfolioproject.dbo.covidvaccination$ as vac
	on dea.location = vac.location
	and  dea.date = vac.date
where dea.continent is not null ;

-- another view 

--showing continents by highest death counts


create view  ContinentsWithHighestCount as 
SELECT 
    continent,

    MAX(cast (total_deaths as int)) AS TotalDeathCount
FROM
    portfolioproject.dbo.coviddeath$
WHERE
    continent IS NOT NULL
   
GROUP BY continent


