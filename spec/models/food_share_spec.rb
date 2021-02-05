require 'rails_helper'

RSpec.describe FoodShare, type: :model do
  let(:food_share) { create(:food_share) }

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

    # FoodRecordとの関連付けをチェックしたい場合
    context 'FoodRecord' do
      # targetは :user に設定
      let(:target) { :food_record }

      # macro メソッドで関連づけを返します
      it { expect(association.macro).to eq :belongs_to }

      # class_name で関連づいたクラス名を返します
      it { expect(association.class_name).to eq 'FoodRecord' }
    end
  end

  describe '正常系' do
    it 'is valid with adequet params' do
      expect(food_share).to be_valid
    end
  end

  describe '異常系' do
    it 'is invalid without food_name' do
      food_share.food_name = ""
      food_share.valid?
      expect(food_share.errors.messages[:food_name]).to include("を入力してください")
    end

    it 'is invalid without limit_number' do
      food_share.limit_number = ""
      food_share.valid?
      expect(food_share.errors.messages[:limit_number]).to include("を入力してください")
    end

    it 'is invalid without give_time' do
      food_share.give_time = nil
      food_share.valid?
      expect(food_share.errors.messages[:give_time]).to include("を入力してください")
    end

    it 'is invalid without limit_time' do
      food_share.limit_time = nil
      food_share.valid?
      expect(food_share.errors.messages[:limit_time]).to include("を入力してください")
    end

    it 'is invalid without latitude' do
      food_share.latitude = nil
      food_share.valid?
      expect(food_share.errors.messages[:latitude]).to include("を入力してください")
    end

    it 'is invalid without longitude' do
      food_share.longitude = nil
      food_share.valid?
      expect(food_share.errors.messages[:longitude]).to include("を入力してください")
    end
  end

  describe '境界値分析' do
    context 'food_name' do
      it 'is invalid with 26' do
        food_share.food_name = "a" * 26
        food_share.valid?
        expect(food_share.errors.messages[:food_name]).to include("は25文字以内で入力してください")
      end

      it 'is valid with 25' do
        food_share.food_name = "a" * 25
        expect(food_share).to be_valid
      end
    end

    context 'memo' do
      it 'is invalid with 251' do
        food_share.memo = "a" * 251
        food_share.valid?
        expect(food_share.errors.messages[:memo]).to include("は250文字以内で入力してください")
      end

      it 'is valid with 250' do
        food_share.memo = "a" * 250
        expect(food_share).to be_valid
      end
    end

    context 'limit_number' do
      it 'is invalid with 6' do
        food_share.limit_number = 6
        food_share.valid?
        expect(food_share.errors.messages[:limit_number]).to include("は6より小さい値にしてください")
      end

      it 'is valid with 5' do
        food_share.limit_number = 5
        expect(food_share).to be_valid
      end

      it 'is valid with 1' do
        food_share.limit_number = 1
        expect(food_share).to be_valid
      end

      it 'is invalid with 0' do
        food_share.limit_number = 0
        food_share.valid?
        expect(food_share.errors.messages[:limit_number]).to include("は0より大きい値にしてください")
      end
    end

    context 'give_time' do
      it 'is invalid with 現在+24時間-1秒' do
        food_share.give_time = Time.zone.now + 24 * 3600
        food_share.limit_time = Time.zone.now + 10 * 3600
        food_share.valid?
        expect(food_share.errors.messages[:give_time]).to include("は、現在より24時間以上先の日時を入力して下さい")
      end

      it 'is valid with 現在+24時間' do
        food_share.give_time = Time.zone.now + 24 * 3600 + 1
        food_share.limit_time = Time.zone.now + 10 * 3600
        expect(food_share).to be_valid
      end
    end

    context 'limit_time' do
      it 'is valid with give_time-12時間-1秒' do
        food_share.give_time = Time.zone.now + 24 * 3600 + 1
        food_share.limit_time = Time.zone.now + 12 * 3600
        expect(food_share).to be_valid
      end

      it 'is invalid with give_time-12時間' do
        food_share.give_time = Time.zone.now + 24 * 3600 + 1
        food_share.limit_time = Time.zone.now + 12 * 3600 + 1
        food_share.valid?
        expect(food_share.errors.messages[:limit_time]).to include("は、お裾分け時間より12時間以上前の日時を入力して下さい")
      end
    end
  end
end
