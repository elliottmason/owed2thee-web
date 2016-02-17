require 'rails_helper'

RSpec.describe LoanRequest do
  let(:loan_request) { build(:loan_request) }

  it 'is valid' do
    expect(loan_request).to be_valid
  end

  context 'without creator' do
    before do
      loan_request.creator = nil
    end

    it 'is invalid' do
      expect(loan_request).to be_invalid
    end
  end

  context 'disbursal deadline is less than a day from now' do
    before do
      loan_request.disbursal_deadline = Time.zone.today
    end

    it 'is invalid' do
      expect(loan_request).to be_invalid
    end
  end

  context 'repayment deadline is less than the disbursal deadline' do
    before do
      loan_request.disbursal_deadline = Time.zone.tomorrow
      loan_request.repayment_deadline = Time.zone.today
    end

    it 'is invalid' do
      expect(loan_request).to be_invalid
    end
  end

  context 'repayment deadline is in the past' do
    before do
      loan_request.repayment_deadline = Time.zone.today
    end

    it 'is invalid' do
      expect(loan_request).to be_invalid
    end
  end
end
