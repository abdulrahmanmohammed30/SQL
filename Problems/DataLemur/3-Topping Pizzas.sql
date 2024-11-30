
select distinct CONCAT(pt1.topping_name,',', pt2.topping_name,',', pt3.topping_name),  
                (pt1.ingredient_cost + pt2.ingredient_cost + pt3.ingredient_cost) as total_cost
from pizza_toppings pt1
join pizza_toppings pt2 on greatest(pt1.topping_name , pt2.topping_name) = pt2.topping_name
join pizza_toppings pt3 on greatest(pt2.topping_name, pt3.topping_name)=pt3.topping_name
where pt1.topping_name <> pt2.topping_name and pt2.topping_name <> pt3.topping_name
order by (pt1.ingredient_cost + pt2.ingredient_cost + pt3.ingredient_cost) desc, 
         CONCAT(pt1.topping_name,',', pt2.topping_name,',', pt3.topping_name)