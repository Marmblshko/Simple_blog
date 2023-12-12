require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:fake_post) { create(:post) }

  before { sign_in user }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new like for the post' do
        post :create, params: { post_id: fake_post.id }
        expect(response).to redirect_to(fake_post)
        expect(flash[:notice]).to eq('Like added!')
      end

      it 'creates a new like for the comment' do
        comment = create(:comment)
        post :create, params: { comment_id: comment.id }
        expect(response).to redirect_to(comment)
        expect(flash[:notice]).to eq('Like added!')
      end
    end

    context 'with invalid params' do
      it 'does not create a new like' do
        allow_any_instance_of(Like).to receive(:save).and_return(false)
        post :create, params: { post_id: fake_post.id }
        expect(response).to redirect_to(fake_post)
        expect(flash[:notice]).to eq('Failed to add like')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:like) { create(:like, user: user, likeable: fake_post) }

    it 'destroys the like for the post' do
      delete :destroy, params: { post_id: fake_post.id, id: like.id }
      expect(response).to redirect_to(fake_post)
      expect(flash[:notice]).to eq('Like removed!')
    end

    it 'destroys the like for the comment' do
      comment = create(:comment)
      like = create(:like, user: user, likeable: comment)
      delete :destroy, params: { comment_id: comment.id, id: like.id }
      expect(response).to redirect_to(comment)
      expect(flash[:notice]).to eq('Like removed!')
    end
  end

  context 'when user is not signed in' do
    before { sign_out user }

    it 'redirects to sign in page for create action' do
      post :create, params: { post_id: fake_post.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in page for destroy action' do
      like = create(:like, user: user, likeable: fake_post)
      delete :destroy, params: { post_id: fake_post.id, id: like.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
