## Table Scripts

CREATE TABLE
    dim_calendar
    (
        calendar_id INT NOT NULL,
        cal_date DATE NOT NULL,
        cal_week INT,
        cal_month INT,
        month_name VARCHAR(10),
        qtr VARCHAR(2),
        cal_year INT,
        day_of_week INT,
        day_of_month INT,
        day_of_year INT,
        cre_id VARCHAR(50),
        cre_ts TIMESTAMP NULL,
        yr_mth INT,
        PRIMARY KEY (calendar_id)
    );
    
CREATE TABLE
    dim_cust
    (
        cust_id INT NOT NULL,
        cust_name VARCHAR(100),
        cust_type VARCHAR(50),
        address VARCHAR(100),
        loc_id INT,
        is_active VARCHAR(1),
        start_dt DATE NOT NULL,
        end_dt DATE,
        cre_id VARCHAR(10),
        upd_id VARCHAR(10),
        cre_ts TIMESTAMP(6),
        upd_ts TIMESTAMP(6),
        PRIMARY KEY (cust_id, start_dt),
        CONSTRAINT fk_loc_id FOREIGN KEY (loc_id) REFERENCES `dim_location` (`loc_id`),
        INDEX fk_loc_id (loc_id)
    );
CREATE TABLE
    dim_location
    (
        loc_id INT NOT NULL,
        city_code VARCHAR(3),
        city_name VARCHAR(50),
        state_code VARCHAR(3),
        state_name VARCHAR(50),
        country_code VARCHAR(3),
        country VARCHAR(50),
        region VARCHAR(5),
        cre_id VARCHAR(10),
        upd_id VARCHAR(10),
        cre_ts TIMESTAMP(6),
        upd_ts TIMESTAMP(6),
        PRIMARY KEY (loc_id)
    );
CREATE TABLE
    dim_product
    (
        prod_id INT NOT NULL,
        prod_name VARCHAR(50),
        prod_type VARCHAR(50),
        prod_desc VARCHAR(100),
        is_active VARCHAR(1),
        cre_id VARCHAR(20),
        upd_id VARCHAR(20),
        cre_ts TIMESTAMP(6),
        upd_ts TIMESTAMP(6),
        PRIMARY KEY (prod_id)
    );
CREATE TABLE
    fct_sales
    (
        sales_txn_id INT NOT NULL,
        prod_id INT NOT NULL,
        calendar_id INT NOT NULL,
        cust_id INT NOT NULL,
        price FLOAT NOT NULL,
        qty INT NOT NULL,
        discount DECIMAL(2,2),
        total_amount FLOAT,
        cre_id VARCHAR(10),
        upd_id VARCHAR(10),
        cre_ts TIMESTAMP(6),
        upd_ts TIMESTAMP(6),
        PRIMARY KEY (sales_txn_id),
        CONSTRAINT fk_cal_id FOREIGN KEY (calendar_id) REFERENCES `dim_calendar` (`calendar_id`) ,
        CONSTRAINT fk_cust_id01 FOREIGN KEY (cust_id) REFERENCES `dim_cust` (`cust_id`) ,
        CONSTRAINT fk_prod_id FOREIGN KEY (prod_id) REFERENCES `dim_product` (`prod_id`),
        INDEX fk_prod_id (prod_id),
        INDEX fk_cal_id (calendar_id),
        INDEX fk_cust_id01 (cust_id)
    );
