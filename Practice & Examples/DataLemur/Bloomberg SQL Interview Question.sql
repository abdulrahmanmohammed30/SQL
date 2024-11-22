
with cte as 
(
  select ticker, max(open) as highest_open, min(open) as lowest_open
  from stock_prices 
  group by ticker 
)


select cte.ticker,
       TO_CHAR(min(sp1.date), 'Mon-YYYY') AS highest_mth, 
       highest_open,
       TO_CHAR(min(sp2.date), 'Mon-YYYY') AS lowest_mth,
       lowest_open
from cte
join stock_prices sp1 on cte.ticker = sp1.ticker AND cte.highest_open = sp1.open
join stock_prices sp2 on cte.ticker = sp2.ticker AND cte.lowest_open = sp2.open
group by cte.ticker, highest_open, lowest_open
order by cte.ticker;
