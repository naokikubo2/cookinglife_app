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
end
