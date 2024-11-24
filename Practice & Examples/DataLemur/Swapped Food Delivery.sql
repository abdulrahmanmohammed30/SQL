select o1.order_id as corrected_order_id, COALESCE(o2.item, o1.item) as item
from orders o1
    left join orders o2
    on 
case 
  when o1.order_id % 2 <> 0 then o1.order_id + 1= o2.order_id
else o1.order_id - 1= o2.order_id
end

