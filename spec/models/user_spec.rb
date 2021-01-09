require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

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
    user.name = "a" * 20
    expect(user).to be_valid
  end

  it 'is invalid with 21文字のname' do
    user.name = "a" * 21
    user.valid?
    expect(user.errors.messages[:name]).to include("は20文字以内で入力してください")
  end

  #フォロー機能
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context "following?" do
    subject { user.following?(other_user) }

    context 'followed' do
      before do
        user.follow(other_user.id)
      end
      it "true" do
        expect(subject).to eq(true)
      end
    end

    context 'not followed' do
      it "false" do
        expect(subject).to eq(false)
      end
    end
  end

  context "follow/unfollow" do
    it "anable to switch follow unfollow" do
      user.follow(other_user.id)
      expect(user.followings.size).to eq(1)
      expect(user.followings.first.id).to eq(other_user.id)

      user.unfollow(other_user.id)
      expect(user.followings.size).to eq(0)
    end

    it "cannnot follow own" do
      user.follow(user.id)
      expect(user.followings.size).to eq(0)
    end
  end

  #お裾分けマッチング機能
end
