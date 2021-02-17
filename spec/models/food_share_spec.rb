require 'rails_helper'

RSpec.describe FoodShare, type: :model do
  let(:user){ create(:user) }
  let(:user_other) { create(:user) }
  let(:user_other2) { create(:user) }
  let(:current_user) { create(:user) }
  let!(:food_share) { create(:food_share, user_id: user.id) }
  let!(:matching) { create(:matching, food_share: food_share, user_id: user_other.id) }
  let!(:matching2) { create(:matching, food_share: food_share, user_id: user_other2.id) }

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

  describe 'model method' do
    context 'complete?' do
      it 'is true' do
        matching.status = "complete"
        matching.save
        expect(food_share.complete?(user_other)).to eq true
      end

      it 'is false' do
        expect(food_share.complete?(user_other)).to eq false
      end
    end

    context 'any_uncomplete?' do
      it 'is false' do
        matching.status = "complete"
        matching.save
        matching2.status = "complete"
        matching2.save
        expect(food_share.any_uncomplete?).to eq false
      end

      it 'is true' do
        matching.status = "not_achieved"
        matching.save
        matching2.status = "not_achieved"
        matching2.save
        expect(food_share.any_uncomplete?).to eq true
      end
    end

    context 'time_judgment' do
      it 'is before' do
        expect(food_share.time_judgment).to eq "before"
      end

      it 'is active' do
        food_share.limit_time = Time.zone.now - 10000
        expect(food_share.time_judgment).to eq "active"
      end

      it 'is after' do
        food_share.limit_time = Time.zone.now - 200000
        food_share.give_time = Time.zone.now - 10000
        expect(food_share.time_judgment).to eq "after"
      end
    end

    context 'mine_sorting' do
      it 'is valid with before mathcning' do
        expect(FoodShare.mine_sorting(user)).to eq [[food_share], [], []]
      end

      it 'is valid with undone mathcning' do
        food_share.update(limit_time: Time.zone.now - 200000)
        expect(FoodShare.mine_sorting(user)).to eq [[], [food_share],[]]
      end

      it 'is valid with done mathcning' do
        food_share.update(limit_time: Time.zone.now - 200000)
        matching.update(status: "complete")
        matching2.update(status: "complete")
        expect(FoodShare.mine_sorting(user)).to eq [[], [],[food_share]]
      end
    end

    context 'friend_sorting' do
      before do
        user.follow(user_other.id)
        user_other.follow(user.id)
      end
      it 'is valid with before mathcning' do
        matching.destroy
        food_share_friend = user_other.food_shares_friends
        expect(food_share_friend.friend_sorting(user_other)).to eq [[food_share], [], []]
      end

      it 'is valid with undone mathcning' do
        food_share_friend = user_other.food_shares_friends
        food_share.update(limit_time: Time.zone.now - 200000)
        expect(food_share_friend.friend_sorting(user_other)).to eq [[], [food_share],[]]
      end

      it 'is valid with done mathcning' do
        food_share.update(limit_time: Time.zone.now - 200000)
        matching.update(status: "complete")
        food_share_friend = user_other.food_shares_friends
        expect(food_share_friend.friend_sorting(user_other)).to eq [[], [],[food_share]]
      end
    end
  end
end
