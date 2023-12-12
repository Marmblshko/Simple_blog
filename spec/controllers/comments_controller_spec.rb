require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:fake_post) { create(:post) }

      before { sign_in user }

      it 'creates a new comment' do
        expect do
          post :create, params: { post_id: fake_post, comment: attributes_for(:comment) }
        end.to change(Comment, :count).by(1)

        expect(response).to redirect_to(fake_post)
        expect(flash[:notice]).to eq('Comment added!')
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign-in page and does not create a comment' do
        post :create, params: { post_id: 1, comment: attributes_for(:comment) }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to match(/You need to sign in or sign up before continuing./)
        expect(Comment.count).to eq(0)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }
    let(:comment) { create(:comment, post: post, author: user.username) }

    before { sign_in user }

    it 'deletes the comment' do
      delete :destroy, params: { post_id: post.id, id: comment.id }

      expect(Comment.exists?(comment.id)).to be_falsy
      expect(response).to redirect_to(post)
      expect(flash[:notice]).to eq('Comment deleted!')
    end

    it 'does not allow deleting comments by other users' do
      other_user = create(:user)
      sign_in(other_user)

      delete :destroy, params: { post_id: post.id, id: comment.id }

      expect(response).to redirect_to(post)
      expect(flash[:notice]).to eq("You can`t delete this comment.")
    end

    context 'when trying to delete another user\'s comment' do
      let(:user) { create(:user) }
      let(:post) { create(:post, user: user) }
      let(:other_user) { create(:user) }
      let(:comment) { create(:comment, post: post, author: other_user.username) }

      before { sign_in user }

      it 'redirects to the post page' do
        delete :destroy, params: { post_id: post.id, id: comment.id }

        expect(response).to redirect_to(post)
        expect(flash[:notice]).to match(/You can`t delete this comment./)
      end

      it 'does not delete the comment' do
        other_user = create(:user)
        sign_in(other_user)
        comment = create(:comment, author: user.username)

        expect do
          delete :destroy, params: { post_id: comment.post_id, id: comment.id }
        end.not_to change(Comment, :count)

        expect(response).to redirect_to(comment.post)
        expect(flash[:notice]).to match(/You can`t delete this comment./)
      end
    end

    context 'when the user is not authenticated' do
      before { sign_out user }

      it 'redirects to sign-in page and does not delete a comment' do
        comment = create(:comment)
        delete :destroy, params: { post_id: comment.post_id, id: comment.id }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to match(/You need to sign in or sign up before continuing./)
        expect(Comment.exists?(comment.id)).to be_truthy
      end
    end
  end
end


