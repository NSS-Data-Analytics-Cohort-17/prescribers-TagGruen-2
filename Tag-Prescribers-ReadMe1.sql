--Q1
--Part A
select npi as name, sum(total_claim_count) as total_claim_count
from prescription 
group by name
order by total_claim_count desc;
-- 1881634483 has the highest total claim count at 99707.

--Part B
select npi, nppes_provider_first_name || ' ' || nppes_provider_last_org_name as name, specialty_description, sum(total_claim_count) as total_claim_count
from prescription left join prescriber using(npi)
group by npi, name, specialty_description
order by name;

--Q2
--Part A
select specialty_description, sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi)
group by specialty_description
order by total_claims desc;
--Family Practice has the most total claims with 9752347

--Part B
select specialty_description, sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi) left join drug using(drug_name)
where opioid_drug_flag = 'Y'
group by specialty_description
order by total_claims desc;
--Nurse Practitioner has the most Opioid claims with 900845

--Part C
select specialty_description 
from prescriber
except
select specialty_description
from prescription left join prescriber using(npi);

--Part D
select specialty_description,
	   count(*) as opioid,
	   round((count(*) * 100 / sum(count(*)) over()), 5) || '%' as percentage
from prescription left join prescriber using(npi) left join drug using(drug_name)
where opioid_drug_flag = 'Y'
group by specialty_description
order by specialty_description;
--I did some googling and I think this is correct. 

--Q3
--Part A
select generic_name, sum(total_drug_cost) as total_cost
from prescription left join drug using(drug_name)
group by generic_name
order by total_cost desc;
--INSULIN GLARGINE,HUM.REC.ANLOG has the highest total drug cost 104264066.35

--Part B with Bonus
select generic_name, sum(total_day_supply) as total_day_supply, sum(total_drug_cost) as total_drug_cost, round(sum(total_drug_cost)/sum(total_day_supply),2) as total_cost_per_day 
from prescription left join drug using(drug_name)
group by generic_name
order by total_cost_per_day desc;
--C1 ESTERASE INHIBITOR has the highest cost per day with 3495.22

--Q4
--Part A
select generic_name,
	   case when opioid_drug_flag = 'Y' then 'Opioid'
	        when antibiotic_drug_flag = 'Y' then 'Antibiotic'
			else 'Neither'end as drug_type
from drug;

--Part B
select case when opioid_drug_flag = 'Y' then 'Opioid'
	        when antibiotic_drug_flag = 'Y' then 'Antibiotic'
			else 'Neither' end as drug_type, 
	   sum(total_drug_cost) as MONEY
from prescription left join drug using(drug_name)
group by drug_type;
--Oioids and by a chunk. 105 million vs antibiotic's 38 million

--Q5
--Part A
select count(*) 
from cbsa 
where cbsaname ilike'%tn%';
--58 cbsas if you are looking for ones listed in tn. However, there are some with different fips codes in here
-- OR
select count(*)
from cbsa 
where fipscounty ilike'47%';
--Only 42 cbsas with fipscounty codes pertaining to TN

--Part B
select *
from population left join cbsa using(fipscounty)
order by population desc limit 1;
-- cbsa 32820 in Memphis TN has the highest population of 937847
select *
from population left join cbsa using(fipscounty)
where cbsa is not null
order by population asc limit 1;
--The smallest cbsa is cbsa 34980 in Nashvill/Murfreesboro/Franklin with a pop of 34980

--Part C
select *
from population left join cbsa using(fipscounty) left join fips_county using(fipscounty)
where cbsa is null
order by population desc;
--The largest county without a cbsa is Sevier County TN

--Q6
--Part A
select drug_name, total_claim_count
from prescription
where total_claim_count >= 3000;

--Part B
select drug_name, total_claim_count, opioid_drug_flag
from prescription left join drug using(drug_name)
where total_claim_count >= 3000;
--I just added the already made opioid_drug_flag column from the drug table

--Part C
select drug_name, total_claim_count, opioid_drug_flag, nppes_provider_first_name || ' ' || nppes_provider_last_org_name as name_of_provider
from prescription left join drug using(drug_name) left join prescriber using(npi)
where total_claim_count >= 3000;

--Q7
select prescriber.npi, nppes_provider_first_name, drug.drug_name, coalesce(sum(total_claim_count), 0)
from prescriber cross join drug left join prescription on drug.drug_name = prescription.drug_name
where specialty_description = 'Pain Management' and  nppes_provider_city = 'NASHVILLE' and opioid_drug_flag = 'Y'
group by prescriber.npi, drug.drug_name, nppes_provider_first_name;