With subtasks 
As 
(
	select task_id, 1 as subtask_id, subtasks_count
	from Tasks 
	union all
	select task_id, subtask_id + 1 as subtask_id, subtasks_count
	from subtasks 
	where subtask_id < subtasks_count
)
select subtasks.task_id, subtasks.subtask_id
from subtasks
left join executed on subtasks.task_id = executed.task_id 
                       and subtasks.subtask_id = executed.subtask_id
where executed.task_id is null 
order by subtasks.task_id, subtasks.subtask_id