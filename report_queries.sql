/* Reporting Queries */

/* Report 1: Period - Total Licenses Sold for past 14 months, country-Germany */

SELECT
    dc.yr_mth   Period,
    SUM(fs.qty) TotalLicensesSold
FROM
    fct_sales fs
JOIN
    dim_cust dcust
ON
    fs.cust_id=dcust.cust_id
JOIN
    dim_location dloc
ON
    dloc.loc_id=dcust.loc_id
JOIN
    dim_calendar dc
ON
    dc.calendar_id=fs.calendar_id
WHERE
    dloc.country_code='DE'
AND dc.yr_mth >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 14 MONTH), "%Y%m")
GROUP BY
    1
ORDER BY
    yr_mth DESC;

/* Report 1a: Period - Total Licenses Sold for past 14 months, country-Germany */

select dcust.cust_name OrgName, dc.yr_mth Period, sum(fs.qty) TotalLicensesSold from fct_sales fs
join dim_cust dcust on fs.cust_id=dcust.cust_id
join dim_location dloc on dloc.loc_id=dcust.loc_id
join dim_calendar dc on dc.calendar_id=fs.calendar_id
where dloc.country_code='DE' 
AND dc.yr_mth >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 14 MONTH), "%Y%m")
group by 1,2
order by 1,2 desc;

/* Report 2: 2.	Top 10 customers by Sales Bookings in the past 365 days. Customer Name and Total Sales Bookings */

WITH top_10_sales AS
    (
        SELECT
            cust.cust_id,
            cust.cust_name,
            SUM(total_amount) AS SalesBookings
        FROM
            fct_sales fsales
        JOIN
            dim_calendar cal
        ON
            fsales.calendar_id=cal.calendar_id
        JOIN
            dim_cust cust
        ON
            fsales.cust_id=cust.cust_id
        WHERE
            cal.cal_Date > date_sub(curdate(),interval 365 DAY)
        GROUP BY
            cust_id,
            cust_name
        ORDER BY
            SalesBookings DESC limit 10
    )
SELECT
    cust_name     AS CustomerName,
    salesbookings AS TotalSalesBookings
FROM
    top_10_sales;

/* Report 3: No. of customers who singed up in 2013 but changed products after 2013 */

WITH sales_in_2013 AS
    (
        SELECT DISTINCT
            sales13.cust_id,
            sales13.prod_id
        FROM
            fct_sales sales13
        JOIN
            dim_calendar cal
        ON
            sales13.calendar_id=cal.calendar_id
        WHERE
            cal.cal_year = 2013
    )
    ,
    sales_aft_2013 AS
    (
        SELECT DISTINCT
            sales_aft13.cust_id,
            sales_aft13.prod_id
        FROM
            fct_sales sales_aft13
        JOIN
            dim_calendar cal
        ON
            sales_aft13.calendar_id=cal.calendar_id
        WHERE
            cal.cal_year > 2013
    )
SELECT
    COUNT(DISTINCT a.cust_id ) AS TotalCustomerWhoChangedProducts
FROM
    sales_in_2013 a
JOIN
    sales_aft_2013 b
ON
    a.cust_id=b.cust_id
WHERE 
    ( b.cust_id,b.prod_id ) NOT IN
                                    ( SELECT DISTINCT
                                          a.cust_id,
                                          a.prod_id
                                      FROM
                                          sales_in_2013 a
                                      WHERE
                                          a.cust_id=b.cust_id )

/* Report 3a: No. of customers who singed up in 2013 but changed products after 2013 with Customer Name and New Products signed up */

with sales_in_2013 as ( select distinct sales13.cust_id , sales13.prod_id   from fct_sales sales13
join dim_calendar cal
on sales13.calendar_id=cal.calendar_id
where cal.cal_year = 2013 
),
sales_aft_2013 as (
select distinct sales_aft13.cust_id, sales_aft13.prod_id  from fct_sales sales_aft13
join dim_calendar cal
on sales_aft13.calendar_id=cal.calendar_id
where cal.cal_year > 2013 
)
select distinct b.cust_id, dc.cust_name, b.prod_id from sales_in_2013 a
join sales_aft_2013 b on a.cust_id=b.cust_id
join dim_cust dc on dc.cust_id=b.cust_id
where (b.cust_id,b.prod_id ) not in (select distinct a.cust_id, a.prod_id from sales_in_2013 a where a.cust_id=b.cust_id )
order by 1,2,3
