/*
Objectives:
Get data of patients that had Flu shots in 2022
1. Get patients' information:
	a. Age
	b. Race
	c. County
	d. Name
	
2. Show whether or not patients received the flu shots in 2022

3. Patient must have been "Active at our hospital"
	a. Visited the hospital at least once in 2022
	b. Not dead 
*/

with active_patient as
(
	select distinct patient
	from encounters as e
	join patients as pat
	on e.patient = pat.id
	where start between '2020-01-01 00:00' and '2022-12-31 23:59'
	and pat.deathdate is null
)

,flu_shot_2022 as
(
select patient, min(date) as earliest_flu_shot_2022
from immunizations
where code = '5302' 
and date between '2022-01-01 00:00:00' and '2022-12-31 23:59:59'
group by patient
)

select 	 birthdate
		,race
		,county
		,"id"
		,"first"
		,"last"
		,flu.patient
		,case when flu.patient is not null then 1
		else 0
		end as flu_shot_2022
from patients pat
left join flu_shot_2022 flu
on pat.id = flu.patient
where pat.id in (select patient from active_patient)
