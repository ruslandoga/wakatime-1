defmodule W1.Repo.Migrations.AddDurations do
  use Ecto.Migration

  # based on https://stackoverflow.com/questions/19089746/calculating-the-longest-binge-viewing-streak-using-sql
  # and https://stackoverflow.com/questions/62919157/trying-to-get-start-and-end-time-in-hours-from-a-set-of-30-minute-time-intervals
  def change do
    execute """
            create or replace view durations as
              with start_grp as (
                select time, project, entity, type, branch,language,
                  case
                    -- heartbeats within 5 min of each other prolong current 'duration'
                    when time - lag(time,1) over (order by time) > interval '0 day 00:05:00' then 1
                    else 0
                  end grp_start
                from heartbeats
              ), assign_grp as (
                select time, project, entity, type, branch,language, sum(grp_start) over (order by time) duration_id
                from start_grp
              )
              select * from assign_grp;
            """,
            "drop view durations"
  end
end
