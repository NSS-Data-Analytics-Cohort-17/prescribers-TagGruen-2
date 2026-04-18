--Q1
select count(*)
from (select npi from prescriber except select npi from prescription);
--there are 4458 npi numbers that do not appear in the prescription table

--Q2
--Part A
select drug_name, count(drug_name) as number_of_prescriptions
from prescription left join prescriber using(npi)
where specialty_description = 'Family Practice'
group by drug_name
order by number_of_prescriptions desc limit 5;

--Part B
select drug_name, count(drug_name) as number_of_prescriptions
from prescription left join prescriber using(npi)
where specialty_description = 'Cardiology'
group by drug_name
order by number_of_prescriptions desc limit 5;

--Part C
select drug_name from(select drug_name, count(drug_name) as number_of_prescriptions
from prescription left join prescriber using(npi)
where specialty_description = 'Family Practice'
group by drug_name
order by number_of_prescriptions desc limit 5)
intersect
select drug_name from(select drug_name, count(drug_name) as number_of_prescriptions
from prescription left join prescriber using(npi)
where specialty_description = 'Cardiology'
group by drug_name
order by number_of_prescriptions desc limit 5);

--Q3
--Part A
select npi, sum(total_claim_count) as total_claims, nppes_provider_city
from prescription left join prescriber using(npi)
where nppes_provider_city = 'NASHVILLE'
group by npi, nppes_provider_city
order by total_claims desc limit 5;

--Part B
select npi, sum(total_claim_count) as total_claims, nppes_provider_city
from prescription left join prescriber using(npi)
where nppes_provider_city = 'MEMPHIS'
group by npi, nppes_provider_city
order by total_claims desc limit 5;

--Part C
(select npi, sum(total_claim_count) as total_claims, nppes_provider_city
from prescription left join prescriber using(npi)
where nppes_provider_city = 'NASHVILLE'
group by npi, nppes_provider_city
order by total_claims desc limit 5)
union
(select npi, sum(total_claim_count) as total_claims, nppes_provider_city
from prescription left join prescriber using(npi)
where nppes_provider_city = 'MEMPHIS'
group by npi, nppes_provider_city
order by total_claims desc limit 5)
union
(select npi, sum(total_claim_count) as total_claims, nppes_provider_city
from prescription left join prescriber using(npi)
where nppes_provider_city = 'KNOXVILLE'
group by npi, nppes_provider_city
order by total_claims desc limit 5)
union
(select npi, sum(total_claim_count) as total_claims, nppes_provider_city
from prescription left join prescriber using(npi)
where nppes_provider_city = 'CHATTANOOGA'
group by npi, nppes_provider_city
order by total_claims desc limit 5);

--Q4
select county, overdose_deaths
from fips_county left join overdose_deaths on cast(fips_county.fipscounty as integer) = overdose_deaths.fipscounty
where overdose_deaths > (select avg(overdose_deaths) from overdose_deaths);

--Q5
--part A
select sum(population) 
from population
where fipscounty ilike'47%';

--Part B
select county, population, (sum(population)/(select sum(population) 
							from population
							where fipscounty ilike'47%') * 100) as percent_of_total
from population left join fips_county using(fipscounty)
group by county, population
order by percent_of_total desc;