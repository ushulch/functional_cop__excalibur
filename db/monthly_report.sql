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
      vendor
