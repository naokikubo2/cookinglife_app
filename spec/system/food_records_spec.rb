require "rails_helper"
require "google/cloud/vision"

RSpec.describe "food_records", type: :system do
  let(:user) { create(:user) }
  let(:login_user) { user }
  let!(:food_record) { create(:food_record, user: user) }
  let(:image_annotator) do
    Class.new do
      def label_detection(_hash)
        "test"
      end
    end
  end

  before do
    log_in(login_user, type: :system)
    visit food_record_path(food_record)
  end

  describe 'vision api' do
    context "food picture" do
      it 'OK' do
        allow_any_instance_of(FoodRecordsController).to receive(:set_vision).and_return(image_annotator.new)
        allow_any_instance_of(FoodRecordsController).to receive(:get_list).and_return(%w[food noodle])
        visit new_food_record_path
        attach_file "food_img", "spec/fixtures/image1.png"
        wait_until(7) do
          expect(page).to have_content '解析結果：OK'
        end
      end
    end

    context "not food picture" do
      it 'NG' do
        allow_any_instance_of(FoodRecordsController).to receive(:set_vision).and_return(image_annotator.new)
        allow_any_instance_of(FoodRecordsController).to receive(:get_list).and_return(%w[test test2])
        visit new_food_record_path
        attach_file "food_img", "spec/fixtures/image1.png"
        wait_until(7) do
          expect(page).to have_content '解析結果：料理の写真ではありません。写真を変更してください。'
        end
      end
    end
  end

  describe 'comment' do
    before do
      timestamp!
    end
    context "when own comment" do
      it 'post and deletable' do
        first("#comments_content").set("Comment#{timestamp}")

        first('input[value="コメント"]').click

        wait_until(5) do
          all("#comments_body div").last.present?
        end

        expect(all("#comments div").last.text).to eq("Comment#{timestamp}")

        find('a', text: 'Delete').click
        wait_until(7) do
          # check deleted
          all("#comments_body div").last.nil?
        end
      end
    end

    context "when other users comment" do
      it 'non display delete link' do
        create(:fr_comment, food_record: food_record, user: create(:user))
        # page reload
        visit current_path
        wait_until do
          all("#comments div").last.present?
        end
        expect(all("#comments div").last.all("a")).to be_empty
      end
    end
  end

  describe 'favorite' do
    it 'like' do
      page.first(".heart").click
      wait_until(7) do
        expect(all("#favorites span").last.text).to eq("1")
      end
    end
  end
end
