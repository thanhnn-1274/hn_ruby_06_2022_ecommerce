require "rake"
namespace :daily_namespace do
  desc "task description"
  task send_mail_daily: :environment do
    DailyOrderWorker.perform_async
  end
end
