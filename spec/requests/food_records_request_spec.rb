require 'rails_helper'
RSpec.describe "FoodRecords", type: :request do
  before do
    timestamp!
    log_in
  end

  #index
  describe "GET /food_records" do
    context 'when not loged in' do
      it "redirect to sign in" do
        log_out
        get food_records_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  #show
  describe "GET /food_records/:id" do
    context 'other users food_record page' do
      it "render to show page" do
        food_record = create(:food_record, food_name: "food #{timestamp}")
        get food_record_path(food_record)
        expect(response).to redirect_to(root_path)
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
        post food_records_path, params: { food_record: { user_id: current_user.id, image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/image1.png')) } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'invalid params' do
      it "render to new page" do
        post food_records_path, params: { food_record: { user_id: current_user.id, image: "" } }
        expect(response.status).to eq(200)
        expect(response.body).to include("画像を入力してください")
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
