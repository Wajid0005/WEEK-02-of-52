# honestly I use Chat GPT but totally I asked for question number - 8,9,14,15


create schema market_data;
#created a schema for storing all 4 stock data

#Imported all 4 stock data

select * from market_data.stock_aapl;
select * from market_data.stock_goog;
select * from market_data.stock_amzn;
select * from market_data.stock_msft;

#making a more professional table
create table market_data.stock_aapl_clean(
	date DATE,
    open DOUBLE,
    high DOUBLE,
    low DOUBLE,
    close DOUBLE,
    volume BIGINT,
    symbol VARCHAR(10)
);

create table market_data.stock_amzn_clean(
	date DATE,
    open DOUBLE,
    high DOUBLE,
    low DOUBLE,
    close DOUBLE,
    volume BIGINT,
    symbol VARCHAR(10)
);

create table market_data.stock_goog_clean(
	date DATE,
    open DOUBLE,
    high DOUBLE,
    low DOUBLE,
    close DOUBLE,
    volume BIGINT,
    symbol VARCHAR(10)
);

create table market_data.stock_msft_clean(
	date DATE,
    open DOUBLE,
    high DOUBLE,
    low DOUBLE,
    close DOUBLE,
    volume BIGINT,
    symbol VARCHAR(10)
);


DESCRIBE market_data.stock_amzn;
SHOW COLUMNS FROM market_data.stock_amzn;

# transforming the table to be more better

insert into market_data.stock_amzn_clean(date, open, high, low, close, volume, symbol)
	select
		str_to_date(Price, '%Y-%m-%d'),
        cast(Open as double),
        cast(High as double),
        cast(Low as double),
        cast( Close as double),
        cast(Volume as UNSIGNED),
        'AMZN'
	from market_data.stock_amzn
    where Price Not in ('Date', 'Ticker');


select * from market_data.stock_amzn_clean;

insert into market_data.stock_aapl_clean(date, open, high, low, close, volume, symbol)
	select
		str_to_date(Price, '%Y-%m-%d'),
        cast(Open as double),
        cast(High as double),
        cast(Low as double),
        cast( Close as double),
        cast(Volume as UNSIGNED),
        'AAPL'
	from market_data.stock_aapl
    where Price Not in ('Date', 'Ticker');


select count(*) from market_data.stock_aapl_clean;



insert into market_data.stock_goog_clean(date, open, high, low, close, volume, symbol)
	select
		str_to_date(Price, '%Y-%m-%d'),
        cast(Open as double),
        cast(High as double),
        cast(Low as double),
        cast( Close as double),
        cast(Volume as UNSIGNED),
        'GOOG'
	from market_data.stock_goog
    where Price Not in ('Date', 'Ticker');


select * from market_data.stock_goog_clean;


insert into market_data.stock_msft_clean(date, open, high, low, close, volume, symbol)
	select
		str_to_date(Price, '%Y-%m-%d'),
        cast(Open as double),
        cast(High as double),
        cast(Low as double),
        cast( Close as double),
        cast(Volume as UNSIGNED),
        'MSFT'
	from market_data.stock_msft
    where Price Not in ('Date', 'Ticker');


select * from market_data.stock_msft_clean;

#Creating a unified table to keep record of each stocks in one table

create table market_data.market_prices (
	date DATE,
    open DOUBLE,
    high DOUBLE,
    low DOUBLE,
    close DOUBLE,
    volume bigint,
    symbol varchar(10)
);

insert into market_data.market_prices
select * from market_data.stock_aapl_clean;

insert into market_data.market_prices
select * from market_data.stock_amzn_clean;

insert into market_data.market_prices
select * from market_data.stock_goog_clean;

insert into market_data.market_prices
select * from market_data.stock_msft_clean;

select * from market_data.market_prices;

select symbol from market_data.market_prices
group by symbol;

SELECT COUNT(*) FROM market_data.market_prices;


#QUestIons to SOLVE

# 1. How many trading days of data do we have for each stock?

Select 
	symbol as SYMBOL,
    count(*) as NUMBER_of_Trading_Days
from market_data.market_prices
group by symbol;

# 2. What is the earliest and latest date available for each stock?

select 
	max(date) as DATE,
    symbol as STOCK
from market_data.market_prices
group by symbol;

# 3. On how many days was each stock traded?
select
	symbol,
    count(*) as traded_days
from market_data.market_prices
group by symbol;

# 4. Which stock has the highest average daily trading volume?
select
	symbol as STOCK,
	avg(volume) as AVG_VOLUME
from market_data.market_prices
group by symbol
order by avg(volume) desc;

# 5. What is the highest price each stock has ever reached?
 select * from market_data.market_prices;
select 
	symbol STOCKS,
    max(high) HIGEST_PRICE
from market_data.market_prices
group by symbol
order by HIGEST_PRICE desc;

# 6. What is the lowest price each stock has ever reached?
select 
	symbol STOCKS,
    min(low) HIGEST_PRICE
from market_data.market_prices
group by symbol
order by HIGEST_PRICE asc;

# 7. What is the average closing price of each stock over the full period?
select
	symbol STOCKS,
    avg(close) as AVG_CLOSING
from market_data.market_prices
group by symbol
order by AVG_CLOSING desc;

# 8. Which stock shows the biggest average daily price movement (high − low)?

select
	symbol STOCKS,
    avg(high - low) as AVG_DAILY_MOVEMENT
from market_data.market_prices
group by symbol
order by AVG_DAILY_MOVEMENT desc;

# 9. Which stock is the most stable based on smallest average daily movement?
select
	symbol STOCKS,
    avg(high - low) as AVG_DAILY_MOVEMENT
from market_data.market_prices
group by symbol
order by AVG_DAILY_MOVEMENT asc;

# 10. How did the average closing price of each stock change year by year?
select 
	symbol as STOCK,
    YEAR(date) as YEAR,
    avg(close) AVG_CLOSING_PRICE
from market_data.market_prices
group by symbol, YEAR(date)
order by symbol, YEAR;    

# 11. Which year was the best year for each stock in terms of average price?
SELECT
    symbol AS STOCK,
    year,
    avg_closing_price
FROM (
    SELECT
        symbol,
        YEAR(date) AS year,
        AVG(close) AS avg_closing_price
    FROM market_data.market_prices
    GROUP BY symbol, YEAR(date)
) yearly_avg
WHERE (symbol, avg_closing_price) IN (
    SELECT
        symbol,
        MAX(avg_closing_price)
    FROM (
        SELECT
            symbol,
            YEAR(date) AS year,
            AVG(close) AS avg_closing_price
        FROM market_data.market_prices
        GROUP BY symbol, YEAR(date)
    ) temp
    GROUP BY symbol
)
ORDER BY symbol;

#Inner query → computes average price per stock per year
#Next layer → finds maximum average price per stock
#Outer query → matches them to get the best year

# 12. Which year was the worst year for each stock?
SELECT
    symbol AS STOCK,
    year,
    avg_closing_price
FROM (
    SELECT
        symbol,
        YEAR(date) AS year,
        AVG(close) AS avg_closing_price
    FROM market_data.market_prices
    GROUP BY symbol, YEAR(date)
) yearly_avg
WHERE (symbol, avg_closing_price) IN (
    SELECT
        symbol,
        min(avg_closing_price)
    FROM (
        SELECT
            symbol,
            YEAR(date) AS year,
            avg(close) AS avg_closing_price
        FROM market_data.market_prices
        GROUP BY symbol, YEAR(date)
    ) temp
    GROUP BY symbol
)
ORDER BY symbol;

# 13. How did trading volume change over the years for each stock?
select 
	symbol as STOCK,
    year(date) YEAR,
    avg(volume) as AVG_YEARLY_VOLUME
from market_data.market_prices
group by symbol, year(date)
order by symbol, year(date);
# 14. On the same trading day, which stock usually closes the highest?

SELECT
    symbol AS STOCK,
    COUNT(*) AS TIMES_CLOSED_HIGHEST
FROM (
    SELECT
        date,
        symbol,
        close,
        RANK() OVER (PARTITION BY date ORDER BY close DESC) AS rnk
    FROM market_data.market_prices
) ranked
WHERE rnk = 1 
GROUP BY symbol
ORDER BY TIMES_CLOSED_HIGHEST DESC;

#PARTITION BY date → compare stocks on the same day
SELECT
        date,
        symbol,
        close,
        RANK() OVER (PARTITION BY date ORDER BY close DESC) AS rnk
    FROM market_data.market_prices
    
#ORDER BY close DESC → highest close first
#RANK() = 1 → stock(s) that closed highest that day
#COUNT(*) → how often each stock wins


# 15. Over the entire period, which stock appears to be the strongest performer overall and why (based on price + volume)
 ;
 
SELECT
    symbol AS STOCK,
    AVG(close) AS AVG_CLOSING_PRICE,
    AVG(volume) AS AVG_TRADING_VOLUME,
    (
        AVG(close) / (SELECT MAX(avg_close) FROM (
            SELECT AVG(close) AS avg_close
            FROM market_data.market_prices
            GROUP BY symbol
        ) c)
        +
        AVG(volume) / (SELECT MAX(avg_vol) FROM (
            SELECT AVG(volume) AS avg_vol
            FROM market_data.market_prices
            GROUP BY symbol
        ) v)
    ) AS OVERALL_STRENGTH_SCORE
FROM market_data.market_prices
GROUP BY symbol
ORDER BY OVERALL_STRENGTH_SCORE DESC;


#AVG(close) → long-term price strength
#AVG(volume) → long-term market participation
#Each is normalized (0–1 range)
#Both are combined into one score
#Highest score = strongest overall performer