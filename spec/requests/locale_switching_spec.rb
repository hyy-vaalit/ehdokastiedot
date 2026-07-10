require "spec_helper"

describe "Locale switching" do
  before { create(:global_configuration) }

  it "serves Finnish by default" do
    get "/"

    expect(response.body).to include('lang="fi"')
    expect(response.body).to include("Tervetuloa")
  end

  it "serves Swedish at /sv and remembers the choice on unprefixed URLs" do
    get "/sv"
    expect(response.body).to include('lang="sv"')
    expect(response.body).to include("Välkommen")

    # Session keeps the language through unscoped URLs (e.g. Haka login flow).
    get "/"
    expect(response.body).to include('lang="sv"')
    expect(response.body).to include("Välkommen")
  end

  it "returns to Finnish via the explicit locale param" do
    get "/en"
    get "/", params: { locale: "fi" }

    expect(response.body).to include('lang="fi"')
  end

  it "falls back to the default locale on an unknown locale param" do
    get "/", params: { locale: "hax" }

    expect(response.body).to include('lang="fi"')
  end
end
