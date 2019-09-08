# frozen_string_literal: true

require 'rails_helper'
require 'user_email'

describe UserEmail do
  context "validation" do
    it "allows only one primary email" do
      user = Fabricate(:user)
      expect {
        Fabricate(:secondary_email, user: user, primary: true)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "allows multiple secondary emails" do
      user = Fabricate(:user)
      Fabricate(:secondary_email, user: user, primary: false)
      Fabricate(:secondary_email, user: user, primary: false)
      expect(user.user_emails.count).to eq 3
    end
  end

  context "indexes" do
    it "allows only one primary email" do
      user = Fabricate(:user)
      expect {
        Fabricate.build(:secondary_email, user: user, primary: true).save(validate: false)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "allows multiple secondary emails" do
      user = Fabricate(:user)
      Fabricate.build(:secondary_email, user: user, primary: false).save(validate: false)
      Fabricate.build(:secondary_email, user: user, primary: false).save(validate: false)
      expect(user.user_emails.count).to eq 3
    end
  end
end
