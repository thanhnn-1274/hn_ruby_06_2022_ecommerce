require "rake"
namespace :monthly_namespace do
  desc "task description"
  task send_mail_monthly: :environment do
    MonthlyOrderWorker.perform_async
  end
end
