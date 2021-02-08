require 'rails_helper'

RSpec.describe FoodRecord, type: :model do
  let(:user) { create(:user) }
  let(:food_record) { create(:food_record) }
  let(:food_record_other) { build(:food_record_other) }
  let(:food_record_noimage) { build(:food_record_noimage) }

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
  end

  describe 'レコメンド機能' do
    context '昨日の料理が麺料理ではない場合' do
      it '麺料理がレコメンドされる可能性がある' do
        create(:food_record, food_name: "food1", healthy_score: 4, workload_score: 4, food_date: Time.zone.yesterday, user_id: user.id)
        create(:food_record, food_name: "food2", healthy_score: -4, workload_score: -4, food_date: Time.zone.today - 3, user_id: user.id)
        create(:food_record, food_name: "food3", healthy_score: -4, workload_score: -4, food_date: Time.zone.today - 12, tag_list: ["麺"], user_id: user.id)
        create(:food_record, food_name: "food4", healthy_score: -3, workload_score: -3, food_date: Time.zone.today - 12, user_id: user.id)
        food_recommend = FoodRecord.food_recommend(user)
        expect(food_recommend.food_name).to eq 'food3'
      end
    end

    context '昨日の料理が麺料理だった場合' do
      it '麺料理以外がレコメンドされる' do
        create(:food_record, food_name: "food1", healthy_score: 4, workload_score: 4, food_date: Time.zone.yesterday, tag_list: ["麺"], user_id: user.id)
        create(:food_record, food_name: "food2", healthy_score: -4, workload_score: -4, food_date: Time.zone.today - 3, user_id: user.id)
        create(:food_record, food_name: "food3", healthy_score: -4, workload_score: -4, food_date: Time.zone.today - 12, tag_list: ["麺"], user_id: user.id)
        create(:food_record, food_name: "food4", healthy_score: -3, workload_score: -3, food_date: Time.zone.today - 12, user_id: user.id)
        food_recommend = FoodRecord.food_recommend(user)
        expect(food_recommend.food_name).to eq 'food4'
      end
    end

    context '昨日の料理が登録されていない場合' do
      it 'レコメンド料理は表示されない' do
        create(:food_record, food_name: "food2", healthy_score: -4, workload_score: -4, food_date: Time.zone.today - 3, user_id: user.id)
        create(:food_record, food_name: "food3", healthy_score: -4, workload_score: -4, food_date: Time.zone.today - 12, tag_list: ["麺"], user_id: user.id)
        create(:food_record, food_name: "food4", healthy_score: -3, workload_score: -3, food_date: Time.zone.today - 12, user_id: user.id)
        food_recommend = FoodRecord.food_recommend(user)
        expect(food_recommend).to eq nil
      end
    end

    context '料理記録が昨日分の1件のみの場合' do
      it 'レコメンド料理は表示されない' do
        create(:food_record, food_name: "food1", healthy_score: 4, workload_score: 4, food_date: Time.zone.yesterday, tag_list: ["麺"], user_id: user.id)
        food_recommend = FoodRecord.food_recommend(user)
        expect(food_recommend).to eq nil
      end
    end
  end

  describe '正常系' do
    it 'is valid with adequet params' do
      expect(food_record).to be_valid
    end
  end

  describe '異常系' do
    it 'is invalid without a image' do
      food_record_noimage.valid?
      expect(food_record_noimage.errors.messages[:image]).to include("を入力してください")
    end

    it 'is invalid with wrong food_timing' do
      food_record.food_timing = "あ"
      food_record.valid?
      expect(food_record.errors.messages[:food_timing]).to include("は一覧にありません")
    end

    it 'is invalid without food_date' do
      food_record.food_date = ""
      food_record.valid?
      expect(food_record.errors.messages[:food_date]).to include("を入力してください")
    end

    it 'is invalid with food_date is after today' do
      food_record.food_date = Time.zone.today + 1
      food_record.valid?
      expect(food_record.errors.messages[:food_date]).to include("は、今日を含む過去の日付を入力して下さい")
    end
  end

  describe '境界値分析' do
    context 'food_name' do
      it 'is invalid with 26' do
        food_record.food_name = "a" * 26
        food_record.valid?
        expect(food_record.errors.messages[:food_name]).to include("は25文字以内で入力してください")
      end

      it 'is valid with 25' do
        food_record.food_name = "a" * 25
        expect(food_record).to be_valid
      end
    end

    context 'memo' do
      it 'is invalid with 26' do
        food_record.memo = "a" * 251
        food_record.valid?
        expect(food_record.errors.messages[:memo]).to include("は250文字以内で入力してください")
      end

      it 'is valid with 250' do
        food_record.memo = "a" * 250
        expect(food_record).to be_valid
      end
    end

    context 'total_score' do
      it 'is invalid with 6' do
        food_record.total_score = 6
        food_record.valid?
        expect(food_record.errors.messages[:total_score]).to include("は6より小さい値にしてください")
      end

      it 'is valid with 5' do
        food_record.total_score = 5
        expect(food_record).to be_valid
      end

      it 'is valid with 1' do
        food_record.total_score = 1
        expect(food_record).to be_valid
      end

      it 'is invalid with 0' do
        food_record.total_score = 0
        food_record.valid?
        expect(food_record.errors.messages[:total_score]).to include("は0より大きい値にしてください")
      end
    end

    context 'healthy_score' do
      it 'is invalid with 5' do
        food_record.healthy_score = 5
        food_record.valid?
        expect(food_record.errors.messages[:healthy_score]).to include("は5より小さい値にしてください")
      end

      it 'is valid with 4' do
        food_record.healthy_score = 4
        expect(food_record).to be_valid
      end

      it 'is valid with -4' do
        food_record.healthy_score = -4
        expect(food_record).to be_valid
      end

      it 'is invalid with -5' do
        food_record.healthy_score = -5
        food_record.valid?
        expect(food_record.errors.messages[:healthy_score]).to include("は-5より大きい値にしてください")
      end
    end

    context 'workload_score' do
      it 'is invalid with 5' do
        food_record.workload_score = 5
        food_record.valid?
        expect(food_record.errors.messages[:workload_score]).to include("は5より小さい値にしてください")
      end

      it 'is valid with 5' do
        food_record.workload_score = 4
        expect(food_record).to be_valid
      end

      it 'is valid with 1' do
        food_record.workload_score = -4
        expect(food_record).to be_valid
      end

      it 'is invalid with 0' do
        food_record.workload_score = -5
        food_record.valid?
        expect(food_record.errors.messages[:workload_score]).to include("は-5より大きい値にしてください")
      end
    end
  end
end
