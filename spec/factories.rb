Factory.define :sibling do |sibling|
  sibling.email                 "bigbrother@example.com"
  sibling.password              "foobar"
  sibling.password_confirmation "foobar"
end

Factory.define :job do |job|
  job.summary                   "Sweep kitchen floor"
  job.description               "The kitchen floor and the adjoining coat room should be thoroughly swept"
  job.pointvalue                3
end

Factory.sequence :email do |n|
  "person-#{n}@bajink.com"
end
