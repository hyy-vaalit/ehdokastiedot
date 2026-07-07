require 'spec_helper'

describe HakaUser do
  def user_with(student_number_attr)
    HakaUser.new(attrs: { student_number: student_number_attr })
  end

  key = Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY

  it "parses the student number from a multivalue attribute" do
    user = user_with(["urn:other:key:123", "#{key}:014735886"])
    expect(user.student_number).to eq "014735886"
  end

  it "parses the student number from a string attribute" do
    expect(user_with("#{key}:014735886").student_number).to eq "014735886"
  end

  it "preserves a leading zero" do
    expect(user_with("#{key}:01234").student_number).to eq "01234"
  end

  it "raises when the key does not match" do
    expect { user_with("urn:other:key:123") }.to raise_error(HakaAuthError)
  end

  it "raises when the attribute is missing" do
    expect { user_with(nil) }.to raise_error(HakaAuthError, "Student number missing")
  end

  it "raises on a non-string type (would lose the leading zero)" do
    expect { user_with(14735886) }.to raise_error(HakaAuthError, /String/)
  end
end
