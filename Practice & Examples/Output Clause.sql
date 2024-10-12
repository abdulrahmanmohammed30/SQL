-- Create product_inventory table
CREATE TABLE product_inventory (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INT,
    last_updated DATE
);
GO

-- Create inventory_updates table
CREATE TABLE inventory_updates (
    product_id INT,
    quantity_change INT
);
GO

-- Insert sample data
INSERT INTO product_inventory VALUES
(101, 'Laptop', 50, '2023-01-01'),
(102, 'Smartphone', 100, '2023-01-01'),
(103, 'Tablet', 30, '2023-01-01'),
(104, 'Headphones', 200, '2023-01-01'),
(105, 'Mouse', 150, '2023-01-01');
GO

INSERT INTO inventory_updates VALUES
(101, -5),
(102, 20),
(103, -10),
(106, 50);
GO

/*
  Question 2: Use the MERGE statement to update the product_inventory table with data from inventory_updates. 
  For existing products, update their quantity and last_updated date. For new products, insert them with the quantity
  from inventory_updates and today's date as last_updated. Ensure that quantities don't go below zero.
*/
merge into product_inventory
using inventory_updates
on product_inventory.product_id = inventory_updates.product_id

when matched then 
   update set 
        quantity=iif (quantity + inventory_updates.quantity_change < 0,
		              0, 
		              quantity + inventory_updates.quantity_change
		             ), 
		last_updated=getdate()
when not matched then 
insert (product_id, quantity, last_updated) 
values (inventory_updates.product_id, iif(quantity_change < 0, 0, quantity_change), getdate());
GO


-- Create loyalty_members table
CREATE TABLE loyalty_members (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    points INT,
    status VARCHAR(20)
);
GO 

-- Create new_transactions table
CREATE TABLE new_transactions (
    customer_id INT,
    transaction_amount DECIMAL(10, 2)
);
GO 

-- Insert sample data
INSERT INTO loyalty_members VALUES
(1, 'Alice Johnson', 500, 'Silver'),
(2, 'Bob Smith', 1200, 'Gold'),
(3, 'Charlie Brown', 300, 'Bronze'),
(4, 'Diana Miller', 800, 'Silver'),
(5, 'Edward Davis', 1500, 'Gold');

INSERT INTO new_transactions VALUES
(1, 200),
(2, 350),
(3, 100),
(6, 500),
(7, 150);

/*
  Question 3: Use the MERGE statement to update the loyalty_members table based on new_transactions. 
  For existing members, add points (1 point per $1 spent) and update their status based 
  on the new total (Bronze: 0-500, Silver: 501-1000, Gold: 1001+). For new customers, 
  insert them with the appropriate points and status. After the MERGE, 
  output the number of updated, inserted, and unchanged records.
*/

merge into loyalty_members t 
using new_transactions s
on t.customer_id = s.customer_id

when matched then
  update set 
    t.points = t.points + Convert (INT, s.transaction_amount), 
	t.status = case

				   when t.points + Convert (INT, s.transaction_amount) between 0 and 500 then 'Bronze'
				   when t.points + Convert (INT, s.transaction_amount) between 501 and 1000 then 'Silver'
				   when t.points + Convert (INT, s.transaction_amount) > 1001 then 'Gold'
	           end 
when not matched then 
  insert (customer_id , points, status) 
  values (s.customer_id, Convert (INT, s.transaction_amount), 
                 case 
                   when Convert (INT, s.transaction_amount) between 0 and 500 then 'Bronze'
				   when Convert (INT, s.transaction_amount) between 501 and 1000 then 'Silver'
				   when Convert (INT, s.transaction_amount) > 1001 then 'Gold' 
				   end 
  )
  OUTPUT 
  $action AS [Action],
  INSERTED.customer_id,
  INSERTED.points,
  INSERTED.status;
