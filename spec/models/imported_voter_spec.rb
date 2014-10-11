require 'spec_helper'

describe 'Imported Voter', :focus do

  describe "Poro Aaltio" do
    before(:each) do
      data = "200583080H012617061Aaltio Poro J J               20101     H55"
      @imported = ImportedVoter.new :data => data
    end

    it 'parses name' do
      @imported.name.should == "Aaltio Poro J J"
    end

    # Dump data doesn't include separator
    it 'parses ssn' do
      @imported.ssn.should == "200583-080H"
    end

    it 'parses student number' do
      @imported.student_number.should == "012617061"
    end

    it 'parses start year' do
      @imported.start_year.should == "2010"
    end

    it 'parses extent' do
      @imported.extent.should == "1"
    end

    it 'parses faculty' do
      @imported.faculty.should == "55"
    end
  end

  describe "Reino Repo" do
    before(:each) do
      data = "010288123A013074751Repo Reino E                  20052     H50"

      @imported = ImportedVoter.new :data => data
    end

    it 'parses name' do
      @imported.name.should == "Repo Reino E"
    end

    # Dump data doesn't include separator
    it 'parses ssn' do
      @imported.ssn.should == "010288-123A"
    end

    it 'parses student number' do
      @imported.student_number.should == "013074751"
    end

    it 'parses start year' do
      @imported.start_year.should == "2005"
    end

    it 'parses extent' do
      @imported.extent.should == "2"
    end

    it 'parses faculty' do
      @imported.faculty.should == "50"
    end
  end
end
