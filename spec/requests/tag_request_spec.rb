require 'rails_helper'
RSpec.describe "FoodRecords", type: :request do
  before do
    timestamp!
    log_in
  end

  # index
  describe "GET /tags" do
    # 自分の料理名が表示できていることを確認
    # 他ユーザの料理名が表示できていることを確認
    context 'when current_user and another user have common tag' do
      it "render to index page" do
        food_record_mine = create(:food_record, user: current_user, food_name: "food #{timestamp}", tag_list: "tag1")
        food_record_other = create(:food_record, food_name: "food #{timestamp}", tag_list: "tag1")
        get tags_path, params: { tag: "tag1" }
        expect(response.status).to eq(200)
        expect(response.body).to include(food_record_mine.food_name, food_record_other.food_name)
      end
    end

    # 料理名が未設定の場合
    context 'when other user have unnamed food' do
      it "render to index page" do
        food_record_mine = create(:food_record, user: current_user, food_name: "food #{timestamp}", tag_list: "tag1")
        food_record_other = create(:food_record, food_name: "", tag_list: "tag1")
        get tags_path, params: { tag: "tag1" }
        expect(response.status).to eq(200)
        expect(response.body).to include("料理名未設定", food_record_mine.food_name)
      end
    end

    context 'when current_user have unnamed food' do
      it "render to index page" do
        food_record_mine = create(:food_record, user: current_user, food_name: "", tag_list: "tag1")
        food_record_other = create(:food_record, food_name: "food #{timestamp}", tag_list: "tag1")
        get tags_path, params: { tag: "tag1" }
        expect(response.status).to eq(200)
        expect(response.body).to include("料理名未設定", food_record_other.food_name)
      end
    end
  end
end
