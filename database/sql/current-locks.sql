-- Run in another session to see the locks:
select
	TL1.resource_type
	,DB_NAME(TL1.resource_database_id) as [DB Name]
	,CASE TL1.resource_type
		WHEN 'OBJECT' THEN OBJECT_NAME(TL1.resource_associated_entity_id, TL1.resource_database_id)
		WHEN 'DATABASE' THEN 'DB'
		ELSE
			CASE
				WHEN TL1.resource_database_id = DB_ID()
				THEN
					(
						select OBJECT_NAME(object_id, TL1.resource_database_id)
						from sys.partitions
						where hobt_id = TL1.resource_associated_entity_id
					)
				ELSE
					'(Run under DB context)'
			END
	END as ObjectName
	,TL1.resource_description
	,TL1.request_session_id
	,TL1.request_mode
	,TL1.request_status
	,WT.wait_duration_ms as [Wait Duration (ms)]
	,(
		select
			SUBSTRING(
				S.Text,
				(ER.statement_start_offset / 2) + 1,
				((
					CASE
						ER.statement_end_offset
					WHEN -1
						THEN DATALENGTH(S.text)
						ELSE ER.statement_end_offset
					END - ER.statement_start_offset) / 2) + 1)
		from
			sys.dm_exec_requests ER
				cross apply sys.dm_exec_sql_text(ER.sql_handle) S
		where
			TL1.request_session_id = ER.session_id
	 ) as [Query]
from
	sys.dm_tran_locks as TL1 left outer join sys.dm_os_waiting_tasks WT on
		TL1.lock_owner_address = WT.resource_address and TL1.request_status = 'WAIT'
where
	TL1.request_session_id <> @@SPID and
	TL1.resource_type <> 'DATABASE'
order by
	TL1.request_session_id
