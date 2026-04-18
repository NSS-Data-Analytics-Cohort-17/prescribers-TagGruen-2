--1
select specialty_description, sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi)
where specialty_description = 'Interventional Pain Management' or specialty_description = 'Pain Management'
group by specialty_description;

--2
(select ' ', sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi)
where specialty_description = 'Interventional Pain Management' or specialty_description = 'Pain Management')
union
(select specialty_description, sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi)
where specialty_description = 'Interventional Pain Management' or specialty_description = 'Pain Management'
group by specialty_description);

--3
select specialty_description,  sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi)
where specialty_description = 'Interventional Pain Management' or specialty_description = 'Pain Management'
group by grouping sets (specialty_description, ());

--4
select specialty_description, opioid_drug_flag, sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi) left join drug using(drug_name)
where specialty_description = 'Interventional Pain Management' or specialty_description = 'Pain Management'
group by grouping sets (opioid_drug_flag, specialty_description, ());

--5
select specialty_description, opioid_drug_flag, sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi) left join drug using(drug_name)
where specialty_description = 'Interventional Pain Management' or specialty_description = 'Pain Management'
group by rollup(opioid_drug_flag, specialty_description);
--Whereas grouping sets puts all of the opioids and non opioids into the pain management and interventional pain management, 
--rollup keep them separate

--6
select specialty_description, opioid_drug_flag, sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi) left join drug using(drug_name)
where specialty_description = 'Interventional Pain Management' or specialty_description = 'Pain Management'
group by rollup(specialty_description, opioid_drug_flag);

--7
select specialty_description, opioid_drug_flag, sum(total_claim_count) as total_claims
from prescription left join prescriber using(npi) left join drug using(drug_name)
where specialty_description = 'Interventional Pain Management' or specialty_description = 'Pain Management'
group by cube(specialty_description, opioid_drug_flag);

--8
select * from crosstab('select nppes_provider_city, case when generic_name ilike''%codein%'' then ''Codein'' 
		        when generic_name ilike''%fentanyl%'' then ''Fentanyl'' 
				when generic_name ilike''%hydrocodone%'' then ''Hydrocodone''
				when generic_name ilike''%morphine%'' then ''Morphine''
				when generic_name ilike''%oxycodone%'' then ''oxycodone''
				when generic_name ilike''%oxymorphone%'' then ''oxymorphone''
				end as opioid_type,
				sum(total_claim_count)
from prescription left join drug using(drug_name) left join prescriber using(npi)
where nppes_provider_city = ''CHATTANOOGA'' or
	  nppes_provider_city = ''KNOXVILLE'' or
	  nppes_provider_city = ''MEMPHIS'' or
	  nppes_provider_city = ''NASHVILLE''
group by nppes_provider_city, opioid_type
order by nppes_provider_city') as ct(City text,Codein numeric, Fentanyl numeric, hydrocodone numeric, morphine numeric, oxycodone numeric, oxymorphone numeric)