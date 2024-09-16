require 'spec_helper'

describe JobOffer do
  describe 'valid?' do
    it 'should be invalid when title is blank' do
      check_validation(:title, "Title can't be blank") do
        described_class.new(location: 'a location')
      end
    end

    it 'should be valid when title is not blank' do
      job_offer = described_class.new(title: 'a title')
      expect(job_offer).to be_valid
    end
  end

  describe 'required experience valid:' do
    it 'required experience is 5' do
      job_offer = described_class.new(title: 'Programer analyst', required_experience: 5)
      expect(job_offer).to be_valid
    end

    it 'string as required experience is invalid' do
      check_validation(:required_experience, 'Required experience is not a number') do
        described_class.new(title: 'The best Offer', required_experience: '15 years')
      end
    end

    it 'required experience has to be integer' do
      check_validation(:required_experience, 'Required experience must be an integer') do
        described_class.new(title: 'The best Offer', required_experience: 5.4)
      end
    end

    it 'required experience has to be positive' do
      check_validation(:required_experience, 'Required experience must be greater than or equal to 0') do
        described_class.new(title: 'The best Offer', required_experience: -5)
      end
    end

    it 'required experience can be 0' do
      job_offer = described_class.new(title: 'Programer analyst', required_experience: 0)
      expect(job_offer).to be_valid
    end

    it 'required experience not specified, is 0' do
      job_offer = described_class.new(title: 'Programer analyst')
      job_offer.required_experience == 0
    end
  end
end
