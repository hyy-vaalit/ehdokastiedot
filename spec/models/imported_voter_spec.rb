require 'spec_helper'

describe 'Imported Voter' do
  describe "Poro Aaltio" do
    before(:each) do
      data = "200583080H012617061Aaltio Poro J J               20101     H55"
      @imported = ImportedVoter.build_from data
    end

    it 'parses name' do
      expect(@imported.name).to eq "Aaltio Poro J J"
    end

    # Dump data doesn't include separator
    it 'parses ssn' do
      expect(@imported.ssn).to eq "200583-080H"
    end

    it 'parses student number' do
      expect(@imported.student_number).to eq "012617061"
    end

    it 'parses start year' do
      expect(@imported.start_year).to eq "2010"
    end

    it 'parses extent_of_studies' do
      expect(@imported.extent_of_studies).to eq "1"
    end

    it 'parses faculty' do
      expect(@imported.faculty).to eq "55"
    end
  end

  describe "Reino Repo" do
    before(:each) do
      data = "010288123A013074751Repo Reino E                  20052     H50"

      @imported = ImportedVoter.build_from data
    end

    it 'parses name' do
      expect(@imported.name).to eq "Repo Reino E"
    end

    # Dump data doesn't include separator
    it 'parses ssn' do
      expect(@imported.ssn).to eq "010288-123A"
    end

    it 'parses student number' do
      expect(@imported.student_number).to eq "013074751"
    end

    it 'parses start year' do
      expect(@imported.start_year).to eq "2005"
    end

    it 'parses extent_of_studies' do
      expect(@imported.extent_of_studies).to eq "2"
    end

    it 'parses faculty' do
      expect(@imported.faculty).to eq "50"
    end
  end

  describe "Empty voter" do
    it 'fails with empty data' do
      expect do
        ImportedVoter.build_from("")
      end.to raise_error(ArgumentError, "Cannot build from empty data.")
    end
  end
end
