--"Create a Stored Procedure to inseert records into the EmployeePayHistory Table"

C r e a t e   P R O C E D U R E   InsertSP
 @RateChangeDate,
@Rate,
@Payfrequency,
@ModifiedDate
 
 
 A S 
 
 B E G I N 
 
         
INSERT INTO ADVENTUREWORKS. H u m a n R e s o u r c e s . E m p l o y e e P a y H i s t o r y  (RateChangeDate, Rate, Payfrequency, ModifiedDate)
VALUES (@RateChangeDate, @Rate, @Payfrequency, @ModifiedDate)
 
 E N D 


--"Create a Stored Procedure to read records from this table using  Ra t e C h a n g e D a t e   O R   P a y F r e q u e n c y as parameters"
  
  
 C r e a t e   P R O C E D U R E   [ d b o ] . [ R e a d o p t S P ]  
 @ R a t e C h a n g e D a t e   d a t e t i m e ,  
 @ P a y F r e q u e n c y   t i n y i n t  
  
          
 A S  
 B E G I N  
          
         S E T   N O C O U N T   O N ;  
  
         s e l e c t   *   f r o m   H u m a n R e s o u r c e s . E m p l o y e e P a y H i s t o r y   w h e r e   R a t e C h a n g e D a t e   =   ' 2 0 0 9 - 0 1 - 0 4 '   O R   P a y F r e q u e n c y   =   1  
  
 E N D  
 --��e x e c   R e a d o p t S P   @ R a t e C h a n g e D a t e =   ' 2 0 0 9 - 0 1 - 0 4 ' ,   @ P a y F r e q u e n c y   =   ' 1 ' 
 


--SQL query that retrieves all the currently running queries on the DB

SELECT TOP 10
    total_worker_time AS CPU_Time
        ,execution_count
        ,total_elapsed_time AS Run_Time
        ,(SELECT
              SUBSTRING(text,statement_start_offset/2,(CASE
                                                           WHEN statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), text)) * 2
                                                           ELSE statement_end_offset
                                                       END -statement_start_offset)/2
                       ) FROM sys.dm_exec_sql_text(sql_handle)
         ) AS query_text
FROM sys.dm_exec_query_stats
ORDER BY Run_Time DESC



--SQL query that returns all the all queries taking the most time to execute on the DB

SELECT   SPID       = er.session_id
    ,STATUS         = ses.STATUS
    ,[Login]        = ses.login_name
    ,Host           = ses.host_name
    ,BlkBy          = er.blocking_session_id
    ,DBName         = DB_Name(er.database_id)
    ,CommandType    = er.command
    ,ObjectName     = OBJECT_NAME(st.objectid)
    ,CPUTime        = er.cpu_time
    ,StartTime      = er.start_time
    ,TimeElapsed    = CAST(GETDATE() - er.start_time AS TIME)
    ,SQLStatement   = st.text
FROM    sys.dm_exec_requests er
    OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) st
    LEFT JOIN sys.dm_exec_sessions ses
    ON ses.session_id = er.session_id
LEFT JOIN sys.dm_exec_connections con
    ON con.session_id = ses.session_id
WHERE   st.text IS NOT NULL

-----KILL [session_id]
