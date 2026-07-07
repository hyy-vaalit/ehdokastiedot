require 'spec_helper'

describe Vaalit::Config do
  describe ".fake_auth_enabled?" do
    it "is enabled in the test env (development stage + flag)" do
      expect(Vaalit::Config.fake_auth_enabled?).to eq true
    end

    it "is disabled when STAGE=production even with FAKE_AUTH_ENABLED=yes" do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("STAGE", nil).and_return("production")
      allow(ENV).to receive(:fetch).with("FAKE_AUTH_ENABLED", "no").and_return("yes")

      expect(Vaalit::Config.fake_auth_enabled?).to eq false
    end
  end
end
