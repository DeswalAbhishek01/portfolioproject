select * 
from portfolioproject.dbo.indiacovid$;


--Looking at state wise Total active cases
select region , sum(Active_cases) as TotalActiveCases
from portfolioproject.dbo.indiacovid$
where Region not in ('India','World','State assignment pending')
group by Region
order by TotalActiveCases desc 

-- Looking at active cases and confirmed cases
select region , sum(Active_cases) as TotalActiveCases ,sum(Confirmed_cases) as TotalConfirmedCases 
from portfolioproject.dbo.indiacovid$
where Region not in ('India','World','State assignment pending')
group by Region
order by TotalActiveCases desc 


--looking at death percentage
--select region , sum(Active_cases) as TotalActiveCases , sum(Death) as TotalDeaths ,(sum(Death)/sum(Active_cases))*100 as DeathPercentage
--from portfolioproject.dbo.indiacovid$
--where Region not in ('India','World')
--group by Region
--order by DeathPercentage desc 

-- Looking at highest death in Country
select region , sum(Death) as TotalDeaths
from portfolioproject.dbo.indiacovid$
where Region not in ('India','World','State assignment pending')
group by Region
order by TotalDeaths desc 

-- Looking at Confirmed cases vs recovery rate ,
select region , sum(Confirmed_Cases) as TotalConfrimedCases , sum([Cured/Discharged]) as Recovered , (sum([Cured/Discharged])/sum(Confirmed_Cases))*100 as RecoveryRate
from portfolioproject.dbo.indiacovid$
where Region not in ('India','World','State assignment pending')
group by Region
order by RecoveryRate desc 

--Looking at Deaths vs Recovered
select region , sum(Death) as TotalDeaths , sum([Cured/Discharged]) as Recovered 
from portfolioproject.dbo.indiacovid$
where Region not in ('India','World','State assignment pending')
group by Region
order by Recovered desc 

-- Looking at cases over time
select Date,Region , sum(Confirmed_Cases) as TotalConfirmedCases 
from portfolioproject.dbo.indiacovid$
where Region not in ('India','World','State assignment pending')
group by Date, Region
--order by Recovered desc 

-- Looking at recovered  over time
select cast(Date as date) as Date,Region , sum(Confirmed_Cases) as TotalConfirmedCases , sum([Cured/Discharged]) as Recovered
from portfolioproject.dbo.indiacovid$
where Region not in ('India','World','State assignment pending')
group by Date, Region
order by Recovered 

