require 'spec_helper'

describe Email do
  describe "#enqueue!" do
    it "enqueues a delayed job and stamps enqueued_at" do
      email = Email.create!(subject: "Tiedote", content: "Sisältö")

      expect { email.enqueue! }.to change { Delayed::Job.count }.by(1)
      expect(email.enqueued_at).to be_present
    end

    it "refuses to enqueue an already sent email again" do
      email = Email.create!(subject: "Tiedote", content: "Sisältö")
      email.enqueue!

      expect {
        expect(email.enqueue!).to eq false
      }.not_to change { Delayed::Job.count }
    end
  end
end
