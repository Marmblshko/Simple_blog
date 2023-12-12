require 'rails_helper'

RSpec.describe Contact, type: :model do
  it "is valid with valid attributes" do
    contact = build(:contact)
    expect(contact).to be_valid
  end

  it "is not valid without an email" do
    contact = build(:contact, email: nil)
    expect(contact).to_not be_valid
  end

  it "is not valid without a message" do
    contact = build(:contact, message: nil)
    expect(contact).to_not be_valid
  end

  it "is valid with valid attributes" do
    contact = build(:contact)
    expect(contact).to be_valid
  end

  it "is not valid without an email" do
    contact = build(:contact, email: nil)
    expect(contact).to_not be_valid
  end

  it "is not valid without a message" do
    contact = build(:contact, message: nil)
    expect(contact).to_not be_valid
  end

  it "is not valid with a blank message" do
    contact = build(:contact, message: " ")
    expect(contact).to_not be_valid
  end

  it "is valid with valid attributes" do
    contact = build(:contact)
    expect(contact).to be_valid
  end

  it "is not valid without an email" do
    contact = build(:contact, email: nil)
    expect(contact).to_not be_valid
    expect(contact.errors[:email]).to include("can't be blank")
  end

  it "is not valid without a message" do
    contact = build(:contact, message: nil)
    expect(contact).to_not be_valid
    expect(contact.errors[:message]).to include("can't be blank")
  end

  it "is valid with a valid email format" do
    contact = build(:contact, email: 'valid@example.com')
    expect(contact).to be_valid
  end
end