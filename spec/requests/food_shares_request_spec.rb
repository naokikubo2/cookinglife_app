require 'rails_helper'
RSpec.describe "FoodShares", type: :request do
  before do
    set_geocoder
    WebMock.enable! # webmockを有効化
    set_distance_response
    timestamp!
    log_in
  end


  after { WebMock.disable! }

  # index
  describe "GET /food_shares" do
    context 'when not loged in' do
      it "redirect to sign in" do
        log_out
        get food_shares_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # show
  describe "GET /food_shares/:id" do
    context 'own food_share page' do
      it "render to show page" do
        food_share = create(:food_share, user: current_user, memo: "food #{timestamp}")
        get food_share_path(food_share)
        expect(response.status).to eq(200)
        expect(response.body).to include("food #{timestamp}")
      end
    end

    context 'other food_share page' do
      it "render to show page" do
        food_share = create(:food_share, memo: "food #{timestamp}")
        get food_share_path(food_share)
        expect(response.status).to eq(200)
        expect(response.body).to include("food #{timestamp}")
        expect(response.body).to include("あなたの自宅から徒歩 20 mins ,距離は1.3 kmです。")
      end
    end
  end

  # new
  describe "GET /food_shares/new" do
    it "render to new page" do
      get new_food_share_path
      expect(response.status).to eq(200)
    end
  end

  # create
  describe "POST /food_shares/:id/create" do
    context 'valid params' do
      it "redirect to root page" do
        food_record = create(:food_record, user: current_user)
        post food_shares_path, params: { food_share: { user_id: current_user.id, food_record_id: food_record.id, limit_number: 3,
                                                       limit_time: Time.zone.now + 24 * 3600, give_time: Time.zone.now + 48 * 3600, memo: "memo", latitude: 35.7090259, longitude: 139.7319925 } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'invalid params' do
      it "render to new page" do
        food_record = create(:food_record, user: current_user)
        post food_shares_path, params: { food_share: { user_id: current_user.id, food_record_id: food_record.id,
                                                       limit_time: Time.zone.now + 24 * 3600, give_time: Time.zone.now + 48 * 3600, memo: "memo", latitude: 35.7090259, longitude: 139.7319925 } }
        expect(response.status).to eq(200)
        expect(response.body).to include("募集人数を入力してください")
      end
    end
  end

  # edit
  describe "GET /food_shares/:id/edit" do
    context 'other users food_shares page' do
      it "redirect to root page" do
        food_share = create(:food_share)
        get edit_food_share_path(food_share)
        expect(response).to redirect_to(root_url)
      end
    end
    context 'own food_shares page' do
      it "render to edit page" do
        food_share = create(:food_share, user: current_user)
        get edit_food_share_path(food_share)
        expect(response.status).to eq(200)
      end
    end
  end

  # update
  describe "PUT /food_shares/:id" do
    let(:food_share) { create(:food_share, user: current_user) }
    context 'valid params' do
      it "redirect to show page" do
        put food_share_path(food_share), params: { food_share: { user_id: current_user.id, memo: "food #{timestamp}" } }
        expect(response).to redirect_to(food_share_path(food_share))
        follow_redirect!
        expect(response.body).to include("登録に成功しました")
        expect(response.body).to include("food #{timestamp}")
      end
    end

    context 'invalid params' do
      it "render to edit page" do
        put food_share_path(food_share), params: { food_share: { user_id: current_user.id, limit_number: 6 } }
        expect(response.status).to eq(200)
        expect(response.body).to include("募集人数は6より小さい値にしてください")
      end
    end

    context 'try to update other users other_food_share' do
      it "redirect to root page" do
        other_food_share = create(:food_share_other)
        put food_share_path(other_food_share), params: { other_food_share: { user_id: current_user.id, memo: "food #{timestamp}" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # matching
  describe "POST /food_shares/:id/matching" do
    let(:other_user) { create(:user) }
    let(:food_share) { create(:food_share, user: other_user) }

    context "not taken" do
      it "take" do
        current_user.follow(other_user.id)
        other_user.follow(current_user.id)
        expect do
          post food_share_matching_path(food_share.id), xhr: true
        end.to change { Matching.count }.by(1)
        expect(food_share.takes?(current_user)).to eq(true)
      end
    end

    context "taken" do
      it "untake" do
        current_user.follow(other_user.id)
        other_user.follow(current_user.id)
        food_share.take(current_user.id)
        expect do
          post food_share_matching_path(food_share.id), xhr: true
        end.to change { Matching.count }.by(-1)
      end
    end
  end
end
