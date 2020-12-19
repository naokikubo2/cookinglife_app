require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { build(:user)  }

  #validation(nameカラムのみ)
  #正常系
  it "is valid with adequet name, email and password" do
    expect(user).to be_valid
  end

  #異常系
  it 'is invalid without a name' do
    user.name = ""
    user.valid?
    expect(user.errors.messages[:name]).to include("を入力してください")
  end

  #境界値分析
  it 'is valid with 20文字のname' do
    user.name  = "a" * 20
    expect(user).to be_valid
  end

  it 'is invalid with 21文字のname' do
    user.name  = "a" * 21
    user.valid?
    expect(user.errors.messages[:name]).to include("は20文字以内で入力してください")
  end

end