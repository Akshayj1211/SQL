## AKSHAY_JADHAV B12 SQL PROJECT

use fda;

## TASK1 
## Q1.1 - etermine the number of drugs approved each year and provide insights into the yearly trends.

select year(actiondate) as Yearly_Approvedata, count(applno) as Approved_application from regactiondate where actiontype = "AP"
group by year(actiondate);

##Insight - In 2002, the U.S. Food and Drug Administration (FDA) carried out its enforcement activities with renewed awareness, commitment, and determination to protect the American public from the new threat of bioterrorism. 


## Q1.2   

select year(actiondate) as Yearly_Approvedata, count(applno) as Approved_application from regactiondate where actiontype = "AP"
group by year(actiondate)
order by count(applno) desc
limit 3;

select year(actiondate) as Yearly_Approvedata, count(applno) as Approved_application from regactiondate where actiontype = "AP"
group by year(actiondate)
order by count(applno)
limit 3;


##Q1.3

select year (rg.actiondate) Yearly_Date, count(ap.applno) as Application_count, count(distinct(ap.sponsorapplicant)) as Sponsor_count,round(count(ap.applno)/count(distinct(ap.sponsorapplicant))) as Approval_Per_Sponsor
from application as ap inner join regactiondate as rg
on ap.applno = rg.applno
where ap.actiontype = "AP"
group by year(rg.actiondate)
order by year(rg.actiondate);

select year (rg.actiondate) Yearly_Date, count(ap.applno) as Application_count, count(distinct(ap.sponsorapplicant)) as Sponsor_count,round(count(ap.applno)/count(distinct(ap.sponsorapplicant))) as Approval_Per_Sponsor
from application as ap inner join regactiondate as rg
on ap.applno = rg.applno
where ap.actiontype = "AP"
group by year(rg.actiondate)
order by year(rg.actiondate)


##Q1.4

select year(rg.actiondate), ap.sponsorapplicant, rank() over(partition by ap.sponsorapplicant order by year(rg.actiondate) desc) as Sponser_rank
from application as ap inner join regactiondate as rg
on ap.applno = rg.applno
where ap.actiontype = "AP" AND year(rg.actiondate) in ("1939","1940","1941","1942","1943","1944","1945","1946","1947","1948","1950","1951","1952","1953","1954","1955","1956","1957","1958","1959","1960")


##Q1.4

DENSE_RANK() OVER(PARTITION BY (SELECT YEAR(rg.actiondate) FROM regactiondate) ORDER BY (select count(ap.applno))

select ap.sponsorapplicant, count(ap.applno) as No_Approvals, Dense_rank() over(order by count(ap.applno) desc) as Sponser_rank
from application as ap inner join regactiondate as rg
on ap.applno = rg.applno
where ap.actiontype = "AP" AND year(rg.actiondate) in ("1939","1940","1941","1942","1943","1944","1945","1946","1947","1948","1950","1951","1952","1953","1954","1955","1956","1957","1958","1959","1960")
group by ap.sponsorapplicant


##TASK2 
##Q2.1
## MKTSTATUS 1 --> Marketed, 2 --> Withdrawn, 3 --> Pending, 4 --> Pre-Market

select * from product
select * from application

select p.productno, count(a.Applno)
from application as a inner join product as p inner join regactiondate as rg
on a.applno = p.applno AND a.applno = rg.applno
where rg.actiontype = "AP" AND p.productmktstatus = "2"
group by p.productno
order by count(applno) desc

select productmktstatus as Product_MKT_Status, count(distinct(productno)) as Product_categories, count(applno) as Total_Application
from product group by productmktstatus

select drugname DRUG_NAME, count(drugname) as No_of_Applications from product where productmktstatus = "1"
group by drugname order by count(drugname) desc
limit 5

select drugname, count(drugname) from product where productmktstatus = "4"
group by drugname order by count(drugname) desc
limit 5

##Q2.2

Type ---------> 1

select p.productmktstatus, count(p.applno) as Total_Application
from product as p inner join application as a inner join regactiondate as rg
on a.applno = rg.applno AND a.applno = p.applno
where year(rg.actiondate) > "2011"
group by p.productmktstatus
Union 
select p.productmktstatus, count(p.applno) as Total_Application
from product as p inner join application as a inner join regactiondate as rg
on a.applno = rg.applno AND a.applno = p.applno
where year(rg.actiondate) > "2012"
group by p.productmktstatus
union
select p.productmktstatus, count(p.applno) as Total_Application
from product as p inner join application as a inner join regactiondate as rg
on a.applno = rg.applno AND a.applno = p.applno
where year(rg.actiondate) > "2013"
group by p.productmktstatus
 
# Type 2  --------->

select distinct(year(rg1.actiondate)) as yearly_value1, count(p1.applno) as total1
from product as p1 inner join application as a1 inner join regactiondate as rg1
on a1.applno = p1.applno AND a1.applno = rg1.applno
where year(rg1.actiondate) > "2010" AND p1.productmktstatus = "1"
group by year(rg1.actiondate)
order by year(rg1.actiondate)
Union
select distinct(year(rg2.actiondate)) as yearly_value2, count(p2.applno) as total2
from product as p2 inner join application as a2 inner join regactiondate as rg2
on a2.applno = p2.applno AND a2.applno = rg2.applno
where year(rg2.actiondate) > "2010" AND p2.productmktstatus = "2"
group by year(rg2.actiondate)
order by year(rg2.actiondate)


##Q2.3
select distinct(year(rg1.actiondate)) as FY_Year, count(p1.applno) as Total_application, dense_rank() over (order by count(p1.applno) desc) RANK_HIGH_LOW_COUNT
from product as p1 inner join application as a1 inner join regactiondate as rg1
on a1.applno = p1.applno AND a1.applno = rg1.applno
where p1.productmktstatus = 
(select productmktstatus from product group by productmktstatus order by count(applno) desc limit 1)
group by year(rg1.actiondate)

##TASK3
##Q3.1 -->  Categorize Products by dosage form and analyze their distribution

select form, dosage, count(ProductNo) as ProductCount
from product
group by dosage, form
order by ProductCount desc

##Q3.2 -->  Calculate the total number of approvals for each dosage form and identify the most successful forms.

select p.FORM, p.DOSAGE, count(p.applno) TOTAL_APPROVAL
from product as p inner join application as a
on p.applno=a.applno
where actiontype = "AP"
group by p.form, p.dosage
order by count(p.applno) desc

##Q3.3 --> Investigate yearly trends related to successful forms

select * from product
select * from regactiondate

select year(rg.actiondate) as "approval_year",p.productno, p.form, count(rg.applno) as "total_approvalno"
from product as p inner join regactiondate as rg 
on p.applno = rg.applno 
group by p.form, p.productno, year(rg.actiondate)
order by  Total_Approvalno desc;

##Q4.1 --> Analyze drug approvals based on therapeutic evaluation code

SELECT p.tecode, COUNT(a.ApplNo) AS "DrugApprovals"
FROM product AS p INNER JOIN application AS a 
ON p.ApplNo = a.ApplNo  WHERE ActionType = "AP"
GROUP BY p.tecode ORDER BY DrugApprovals DESC;

##Q4.2 --> Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.

select year(r.actiondate), p.tecode, count(a.applno) as "Total_approval"
from regactiondate as r inner join application as a inner join product as p
on a.applno = r.applno AND a.applno = p.applno
where a.actiontype = "AP"
group by year(r.actiondate), p.tecode
order by Total_approval desc

select * from product_tecode
select * from product
select * from regactiondate


from product_tecode as PT inner join regactiondate as r