alter table records rename to records_old;

create table records
(like records_old including defaults)
partition by hash (repo);

alter sequence records_id_seq owned by records.id;

do $$
begin
for i in 0..15 loop
   execute 'create table records_' || i || ' partition of records for values with (modulus 16, remainder ' || i || ') partition by hash (collection)';
for j in 0..15 loop
   execute 'create table records_' || i || '_' || j || ' partition of records_' || i || ' for values with (modulus 16, remainder ' || j || ')';
end loop;
end loop;
end $$;

with moved_rows as (
        delete from records_old r
        returning r.*
)
insert into records select * from moved_rows;
drop table records_old;
