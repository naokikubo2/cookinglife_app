require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  before do
    Geocoder.configure(lookup: :test)
    Geocoder::Lookup::Test.add_stub(
        '東京都港区', [{
        'coordinates'  => [35.7090259, 139.7319925]
    }]
    )
    Geocoder::Lookup::Test.add_stub(
        'ダメなキーワード', []
    )
  end

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

  it 'is invalid without a location_id' do
    user.location_id = ""
    user.valid?
    expect(user.errors.messages[:location_id]).to include("を入力してください")
  end

  it 'is invalid without an address' do
    user.address = ""
    user.valid?
    expect(user.errors.messages[:address]).to include("を入力してください")
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
