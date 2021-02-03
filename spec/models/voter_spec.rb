require 'spec_helper'

describe 'Voter' do

  describe "from an Imported Voter" do

    before(:each) do
      faculty_numeric_code = 55

      @imported = ImportedVoter.new(
          :name              => "Purhonen Pekka J P",
          :ssn               => "010283-1234",
          :student_number    => "0123456789",
          :extent_of_studies => 2,
          :faculty           => faculty_numeric_code
      )

      faculty = FactoryBot.build(:faculty, :numeric_code => faculty_numeric_code)

      allow(Faculty).to receive(:find_by_numeric_code!).with(faculty_numeric_code).and_return faculty
    end

    it 'creates a voter' do
      voter = Voter.create_from! @imported
      expect(voter.name).to eq "Purhonen Pekka J P"
      expect(voter.ssn).to eq "010283-1234"
      expect(voter.student_number).to eq "0123456789"
      expect(voter.extent_of_studies).to eq 2
      expect(voter.faculty.numeric_code).to eq 55
    end

  end
end
