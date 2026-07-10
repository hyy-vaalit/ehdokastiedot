require 'spec_helper'

# The delayed_job stack (YAML serialization of AR objects on psych 4 +
# aws-actionmailer-ses) has churned recently: prove that an enqueued Email
# deserializes and performs against the test mailer. A manual run against
# the SES sandbox in QA is still part of the pre-election checklist.
describe "Email pipeline" do
  it "delivers enqueued candidate emails through delayed_job" do
    create_list(:candidate, 2)
    email = Email.create!(subject: "Tiedote", content: "Sisältö")

    expect { email.enqueue! }.to change { Delayed::Job.count }.by(1)

    # Performing the fan-out job enqueues one mailer job per candidate.
    fan_out = Delayed::Job.last
    fan_out.invoke_job

    mailer_jobs = Delayed::Job.where.not(id: fan_out.id)
    expect(mailer_jobs.count).to eq 2

    expect {
      mailer_jobs.each(&:invoke_job)
    }.to change { ActionMailer::Base.deliveries.count }.by(2)

    delivered = ActionMailer::Base.deliveries.last(2)
    expect(delivered.map(&:subject)).to all(eq "Tiedote")
  end
end
