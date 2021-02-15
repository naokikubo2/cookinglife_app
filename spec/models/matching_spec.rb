require 'rails_helper'

RSpec.describe Matching, type: :model do
  let(:matching) { create(:matching) }

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

    # FoodRecordとの関連付けをチェックしたい場合
    context 'FoodRecord' do
      # targetは :user に設定
      let(:target) { :food_share }

      # macro メソッドで関連づけを返します
      it { expect(association.macro).to eq :belongs_to }

      # class_name で関連づいたクラス名を返します
      it { expect(association.class_name).to eq 'FoodShare' }
    end
  end

  describe '正常系' do
    it 'is valid with adequet params' do
      expect(matching).to be_valid
    end
  end

  describe '異常系' do
    it 'is invalid with 募集人数を超えたお裾分け希望' do
      matching.food_share.limit_number = 2
      user2 = create(:user)
      user3 = create(:user)
      matching.food_share.take(user2.id)
      matching2 = create(:matching, food_share: matching.food_share, user: user3)
      matching2.valid?
      expect(matching2.errors.messages[:food_share_id]).to include("は募集人数を超過しています")
    end

    it 'is invalid without status' do
      matching.status = ""
      matching.valid?
      expect(matching.errors.messages[:status]).to include("を入力してください")
    end
  end
end
