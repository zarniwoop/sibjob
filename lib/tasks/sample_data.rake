require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Sibling.create!(:email => "nate@bajink.com",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    2.times do |n|
      email = "nate+#{n+1}@bajink.com"
      password  = "password"
      Sibling.create!(:email => email,
                   :password => password,
                   :password_confirmation => password)
    end

    Sibling.all.each do |sibling|
      5.times do
        sibling.job.create!(:summary => Faker::Lorem.sentence(5),
                    :description => Faker::Lorem.paragraph(5),
                    :pointvalue => 1 + rand(4)) do |j|
          j.interval = "daily"
        end
      end
    end

    10.times do |n|
      Job.create!(:summary => Faker::Lorem.sentence(5),
                  :description => Faker::Lorem.paragraph(5),
                  :pointvalue => 1 + rand(4))  do |j|
          j.interval = "weekly"
      end
    end
  end
end