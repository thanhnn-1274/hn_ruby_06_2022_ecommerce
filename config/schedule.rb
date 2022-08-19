# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, "development"
set :output, "log/cron_log.log"
env :PATH, ENV['PATH']

# send mail every end of the day
every "56 13 * * *" do
  rake "daily_namespace:send_mail_daily", :environment => "development"
end


# send mail every end of the day
every "55 23 * * *" do
  rake "daily_namespace:send_mail_daily", :environment => "development"
end

# send mail every last day of the month
every "55 23 30 4,6,9,11 *" do
  rake "monthly_namespace:send_mail_monthly", :environment => "development"
end

every "55 23 31 1,3,5,7,8,10,12 *" do
  rake "monthly_namespace:send_mail_monthly", :environment => "development"
end

every "55 23 28 2 *" do
  rake "monthly_namespace:send_mail_monthly", :environment => "development"
end
