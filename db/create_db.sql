set role excalibur_group;

drop view monthly_report;
drop table transactions;

create table
   transactions (id uuid primary key,
                 date date not null,
                 vendor varchar not null,
                 amount money not null);



create view
   monthly_report
as
   select
      extract(month from date) as month,
      trim(to_char(date, 'Month')) as month_name,
      vendor,
      sum(amount)
   from
      transactions
   group by
      month,
      month_name,
      vendor;
