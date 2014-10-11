require 'spec_helper'

describe 'Voter', :focus do

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

      faculty = FactoryGirl.build(:faculty, :numeric_code => faculty_numeric_code)

      Faculty.stub!(:find_by_numeric_code).and_return faculty
    end

    it 'creates a voter' do
      voter = Voter.create_from! @imported
      voter.name.should == "Purhonen Pekka J P"
      voter.ssn.should == "010283-1234"
      voter.student_number.should == "0123456789"
      voter.extent_of_studies.should == 2
      voter.faculty.numeric_code.should == 55
    end

  end
end
