require "rails_helper"

RSpec.describe "food_shares", type: :system do
  let(:user) { create(:user) }
  let(:login_user) { user }
  let(:user_other) { create(:user) }
  let!(:food_share) { create(:food_share, user: user) }
  let!(:food_share_other) { create(:food_share, user: user_other) }

  before do
    log_in(login_user, type: :system)
    WebMock.enable! # webmockを有効化
    set_distance_response
  end

  after { WebMock.disable! }

  describe 'comment' do
    before do
      visit food_share_path(food_share)
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
        create(:fs_comment, food_share: food_share, user: create(:user))
        # page reload
        visit current_path
        wait_until do
          all("#comments div").last.present?
        end
        expect(all("#comments div").last.all("a")).to be_empty
      end
    end
  end

  describe 'FoodShare_complete' do
    before do
      timestamp!
      login_user.follow(user_other.id)
      user_other.follow(login_user.id)
      create(:matching, food_share: food_share_other, user_id: user.id)
      food_share_other.limit_time = Time.zone.now - 10000
      food_share_other.save(validate: false)
      visit food_share_path(food_share_other)
    end
    context "when click complete button" do
      it 'not_achieve to complete' do
        click_link 'お裾分け完了'
        visit food_share_path(food_share_other)
        wait_until(5) do
          expect(page).to have_content 'お裾分け済み'
        end
      end
    end
  end
end
