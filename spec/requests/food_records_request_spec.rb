require 'rails_helper'
require "webmock/rspec"  # webmockをrequire
RSpec.describe "FoodRecords", type: :request do
  before do
    WebMock.enable! # webmockを有効化
    set_response
    timestamp!
    log_in
  end

  after { WebMock.disable! }

  #index
  describe "GET /food_records" do
    context 'when not loged in' do
      it "redirect to sign in" do
        log_out
        get food_records_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when logged in' do
      it "show followings's food_record" do
        make_friend
        food_record_friend = create(:food_record, user: friend_user, food_name: "food_friend")
        get food_records_path
        expect(response.status).to eq(200)
        expect(response.body).to include(food_record_friend.image.url.to_s)
      end
    end
  end

  describe "GET /food_records/:q" do
    context 'when 料理名検索' do
      it "曖昧検索される" do
        food_record_1 = create(:food_record, user: current_user, food_name: "food1")
        food_record_2 = create(:food_record, user: current_user, food_name: "food2")
        @params = {}
        @params[:q] = {}
        @params[:q][:food_name_cont] = 'food1'
        get food_records_path(@params)
        expect(response.status).to eq(200)
        expect(response.body).to include("food1")
        expect(response.body).not_to include("food2")
      end
    end

    context 'when 総合得点検索' do
      it "総合得点のレンジ内の料理が検索される" do
        food_record_1 = create(:food_record, user: current_user, total_score: 3, food_name: "food1")
        food_record_2 = create(:food_record, user: current_user, total_score: 2, food_name: "food2")
        @params = {}
        @params[:q] = {}
        @params[:q][:total_score_gteq] = 3
        get food_records_path(@params)
        expect(response.status).to eq(200)
        expect(response.body).to include(food_record_1.image.url.to_s)
        expect(response.body).not_to include(food_record_2.image.url.to_s)
      end
    end

    context 'when カロリー検索' do
      it "入力されたカロリーの料理が検索される" do
        food_record_1 = create(:food_record, user: current_user, healthy_score: 3, food_name: "food1")
        food_record_2 = create(:food_record, user: current_user, healthy_score: 2, food_name: "food2")
        @params = {}
        @params[:q] = {}
        @params[:q][:healthy_score_eq] = 3
        get food_records_path(@params)
        expect(response.status).to eq(200)
        expect(response.body).to include(food_record_1.image.url.to_s)
        expect(response.body).not_to include(food_record_2.image.url.to_s)
      end
    end

    context 'when 調理の手間検索' do
      it "入力された手間の料理が検索される" do
        food_record_1 = create(:food_record, user: current_user, workload_score: 3, food_name: "food1")
        food_record_2 = create(:food_record, user: current_user, workload_score: 2, food_name: "food2")
        @params = {}
        @params[:q] = {}
        @params[:q][:workload_score_eq] = 3
        get food_records_path(@params)
        expect(response.status).to eq(200)
        expect(response.body).to include(food_record_1.image.url.to_s)
        expect(response.body).not_to include(food_record_2.image.url.to_s)
      end
    end

    context 'when 時間帯検索' do
      it "入力された時間帯の料理が検索される" do
        food_record_1 = create(:food_record, user: current_user, food_timing: "morning", food_name: "food1")
        food_record_2 = create(:food_record, user: current_user, food_timing: "lunch", food_name: "food2")
        @params = {}
        @params[:q] = {}
        @params[:q][:food_timing_eq] = "morning"
        get food_records_path(@params)
        expect(response.status).to eq(200)
        expect(response.body).to include(food_record_1.image.url.to_s)
        expect(response.body).not_to include(food_record_2.image.url.to_s)
      end
    end

    context 'when 日付検索' do
      it "日付のレンジ内の料理が検索される" do
        food_record_1 = create(:food_record, user: current_user, food_date: Time.zone.today - 1, food_name: "food1")
        food_record_2 = create(:food_record, user: current_user, food_date: Time.zone.today - 2, food_name: "food2")
        @params = {}
        @params[:q] = {}
        @params[:q][:food_date_gteq ] = Time.zone.today - 1
        @params[:q][:food_date_lt ] = Time.zone.today
        get food_records_path(@params)
        expect(response.status).to eq(200)
        expect(response.body).to include(food_record_1.image.url.to_s)
        expect(response.body).not_to include(food_record_2.image.url.to_s)
      end
    end

    context 'when 複合検索' do
      it "全ての検索条件に当てはまる料理が検索される" do
        food_record_1 = create(:food_record, user: current_user, total_score: 3, healthy_score: 3, food_name: "food1")
        food_record_2 = create(:food_record, user: current_user, total_score: 3, healthy_score: 1, food_name: "food2")
        food_record_3 = create(:food_record, user: current_user, total_score: 1, healthy_score: 1, food_name: "food3")
        @params = {}
        @params[:q] = {}
        @params[:q][:total_score_gteq ] = 3
        @params[:q][:healthy_score_eq ] = 3
        get food_records_path(@params)
        expect(response.body).to include(food_record_1.image.url.to_s)
        expect(response.body).not_to include(food_record_2.image.url.to_s, food_record_3.image.url.to_s)
      end
    end

    context 'when 料理が十分に記録されている' do
      it "レコメンド料理が表示される" do
        food_record1 = create(:food_record, food_name: "food1", healthy_score: 4, workload_score: 4, food_date: Time.zone.yesterday, tag_list: ["麺"], user: current_user)
        food_record2 = create(:food_record, food_name: "food2", healthy_score: -4, workload_score: -4, food_date: Time.zone.today - 3, user: current_user)
        food_record3 = create(:food_record, food_name: "food3", healthy_score: -4, workload_score: -4, food_date: Time.zone.today - 12, tag_list: ["麺"], user: current_user)
        food_record4 = create(:food_record, food_name: "food4", healthy_score: -3, workload_score: -3, food_date: Time.zone.today - 12, user: current_user)
        get root_path
        expect(response.status).to eq(200)
        expect(response.body).to include(food_record4.image.url.to_s).twice
      end
    end

    context 'when 料理投稿が2件のみ' do
      it "最新の料理が２回表示される" do
        food_record2 = create(:food_record, food_name: "food2", healthy_score: -4, workload_score: -4, food_date: Time.zone.today - 11, user: current_user)
        food_record4 = create(:food_record, food_name: "food4", healthy_score: -3, workload_score: -3, food_date: Time.zone.today - 12, user: current_user)
        get root_path
        expect(response.status).to eq(200)
        expect(response.body).to include(food_record2.image.url.to_s).at_least(:twice)
        expect(response.body).to include(food_record4.image.url.to_s).once
      end
    end
  end

  #show
  describe "GET /food_records/:id" do
    context 'other users food_record page' do
      it "render to show page" do
        food_record = create(:food_record, user: current_user, food_name: "food #{timestamp}")
        get food_record_path(food_record)
        expect(response.status).to eq(200)
        expect(response.body).to include("food #{timestamp}")
      end
    end

    context 'own food_record page' do
      it "render to show page" do
        food_record = create(:food_record, user: current_user, food_name: "food #{timestamp}")
        get food_record_path(food_record)
        expect(response.status).to eq(200)
        expect(response.body).to include("food #{timestamp}")
      end
    end
  end

  #new
  describe "GET /food_records/new" do
    it "render to new page" do
      get new_food_record_path
      expect(response.status).to eq(200)
    end
  end

  #create
  describe "POST /food_records/:id/create" do
    context 'valid params' do
      it "redirect to root page" do
        post food_records_path,
             params: { food_record: { user_id: current_user.id, image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/image1.png')),
                                      tag_list: "tag_test#{timestamp}" } }
        follow_redirect!
        expect(response.status).to eq(200)
        expect(response.body).to include("tag_test#{timestamp}")
      end
    end

    context 'invalid params' do
      it "render to new page" do
        post food_records_path, params: { food_record: { user_id: current_user.id, image: "" } }
        expect(response.status).to eq(200)
        expect(response.body).to include("画像を入力してください")
      end
    end

    context '404 error' do
      it "render new page" do
        set_error_response
        post food_records_path, params: { food_record: { user_id: current_user.id, image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/image1.png')) } }
        follow_redirect!
        expect(response.status).to eq(200)
        expect(response.body).to include("天気情報の取得に失敗しましたが、登録に成功しました")
      end
    end
  end

  #edit
  describe "GET /food_records/:id/edit" do
    context 'other users food_records page' do
      it "redirect to root page" do
        food_record = create(:food_record)
        get edit_food_record_path(food_record)
        expect(response).to redirect_to(root_url)
      end
    end
    context 'own food_records page' do
      it "render to edit page" do
        food_record = create(:food_record, user: current_user)
        get edit_food_record_path(food_record)
        expect(response.status).to eq(200)
      end
    end
  end

  #update
  describe "PUT /food_records/:id" do
    let(:food_record) { create(:food_record, user: current_user) }
    context 'valid params' do
      it "redirect to root page" do
        put food_record_path(food_record), params: { food_record: { user_id: current_user.id, food_name: "food #{timestamp}" } }
        expect(response).to redirect_to(food_record_path(food_record))
        follow_redirect!
        expect(response.body).to include("登録に成功しました")
        expect(response.body).to include("food #{timestamp}")
      end
    end

    context 'invalid params' do
      it "render to edit page" do
        put food_record_path(food_record), params: { food_record: { user_id: current_user.id, total_score: 6 } }
        expect(response.status).to eq(200)
        expect(response.body).to include("総合得点は6より小さい値にしてください")
      end
    end

    context 'try to update other users other_food_record' do
      it "redirect to root page" do
        other_food_record = create(:food_record_other)
        put food_record_path(other_food_record), params: { other_food_record: { user_id: current_user.id, food_name: "food" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
