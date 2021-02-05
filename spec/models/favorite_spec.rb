require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:favorite) { create(:favorite) }

  before do
    set_geocoder
  end

  # 関連付けのテスト
  describe 'Association' do
    let(:association) do
      # reflect_on_associationで対象のクラスと引数で指定するクラスの
      # 関連を返します
      described_class.reflect_on_association(target)
    end

    # userとの関連付けをチェックしたい場合
    context 'User' do
      # targetは :user に設定
      let(:target) { :user }

      # macro メソッドで関連づけを返します
      it { expect(association.macro).to eq :belongs_to }

      # class_name で関連づいたクラス名を返します
      it { expect(association.class_name).to eq 'User' }
    end

    # food_recordとの関連付けをチェックしたい場合
    context 'FoodRecord' do
      # targetは :food_share に設定
      let(:target) { :food_record }

      # macro メソッドで関連づけを返します
      it { expect(association.macro).to eq :belongs_to }

      # class_name で関連づいたクラス名を返します
      it { expect(association.class_name).to eq 'FoodRecord' }
    end
  end

  describe '正常系' do
    it 'is valid with adequet params' do
      expect(favorite).to be_valid
    end
  end

  describe '異常系' do
    it 'is invalid with same user 2 times' do
      favorite2 = build(:favorite, food_record: favorite.food_record, user: favorite.user)
      favorite2.valid?
      expect(favorite2.errors.messages[:user_id]).to include("はすでに存在します")
    end
  end
end
