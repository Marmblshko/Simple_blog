require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end

    it "assigns all posts to @posts" do
      post = create(:post)
      get :index
      expect(assigns(:posts)).to eq([post])
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      post = create(:post)
      get :show, params: { id: post.id }
      expect(response).to render_template :show
    end

    it "renders the show template" do
      post = create(:post)
      get :show, params: { id: post.id }
      expect(response).to render_template :show
    end

    context "when user is logged in" do
      it "renders the show template" do
        user = create(:user)
        sign_in user
        post = create(:post)
        get :show, params: { id: post.id }
        expect(response).to render_template :show
      end
    end

    context "when user is not logged in" do
      it "renders the show template" do
        post = create(:post)
        get :show, params: { id: post.id }
        expect(response).to render_template :show
      end
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      user = create(:user)
      sign_in user
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new post" do
        user = create(:user)
        sign_in user
        expect {
          post :create, params: { post: attributes_for(:post) }
        }.to change(Post, :count).by(1)
      end

      it "redirects to the created post" do
        user = create(:user)
        sign_in user
        post :create, params: { post: attributes_for(:post) }
        expect(response).to redirect_to(Post.last)
      end
    end

    context "with invalid attributes" do
      it "does not create a new post" do
        expect {
          post :create, params: { post: attributes_for(:post, title: nil) }
        }.not_to change(Post, :count)
      end

      it "re-renders the new template" do
        user = create(:user)
        sign_in user
        post :create, params: { post: attributes_for(:post, title: nil) }
        expect(response).to render_template :new
      end

      it "assigns errors to @post" do
        user = create(:user)
        sign_in user
        post :create, params: { post: attributes_for(:post, title: nil) }
        expect(assigns(:post).errors).not_to be_empty
      end
    end

    context "when user is not logged in" do
      it "does not create a new post" do
        expect {
          post :create, params: { post: attributes_for(:post) }
        }.not_to change(Post, :count)
      end

      it "redirects to the sign-in page" do
        post :create, params: { post: attributes_for(:post) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      user = create(:user)
      post = create(:post, user: user)
      sign_in user
      get :edit, params: { id: post.id }
      expect(response).to render_template :edit
    end

    context "when user is not the owner" do
      it "redirects to posts_path" do
        user = create(:user)
        post = create(:post)
        sign_in user
        get :edit, params: { id: post.id }
        expect(response).to redirect_to(posts_path)
      end
    end

    context "when user is not logged in" do
      it "redirects to the sign-in page" do
        post = create(:post)
        get :edit, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "updates the post" do
        user = create(:user)
        post = create(:post, user: user)
        sign_in user
        put :update, params: { id: post.id, post: { title: "Updated Title" } }
        post.reload
        expect(post.title).to eq("Updated Title")
      end

      it "redirects to the updated post" do
        user = create(:user)
        sign_in user
        post = create(:post, user: user)
        put :update, params: { id: post.id, post: { title: "Updated Title" } }
        expect(response).to redirect_to(post)
      end
    end

    context "with invalid attributes" do
      it "does not update the post" do
        post = create(:post)
        put :update, params: { id: post.id, post: { title: nil } }
        post.reload
        expect(post.title).not_to be_nil
      end

      it "re-renders the edit template" do
        user = create(:user)
        sign_in user
        post = create(:post, user: user)
        put :update, params: { id: post.id, post: { title: nil } }
        expect(response).to render_template :edit
      end
    end

    context "when user is not the owner" do
      it "does not update the post" do
        post = create(:post)
        put :update, params: { id: post.id, post: { title: "Updated Title" } }
        post.reload
        expect(post.title).not_to eq("Updated Title")
      end
    end

    it "assigns errors to @post" do
      user = create(:user)
      sign_in user
      post = create(:post, user: user)
      put :update, params: { id: post.id, post: { title: nil } }
      expect(assigns(:post).errors).not_to be_empty
    end

    context "when user is not logged in" do
      it "does not update the post" do
        post = create(:post)
        put :update, params: { id: post.id, post: { title: "Updated Title" } }
        post.reload
        expect(post.title).not_to eq("Updated Title")
      end

      it "redirects to the sign-in page" do
        post = create(:post)
        put :update, params: { id: post.id, post: { title: "Updated Title" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is logged in" do
      it "deletes the post" do
        user = create(:user)
        post = create(:post, user: user)
        sign_in user
        expect {
          delete :destroy, params: { id: post.id }
        }.to change(Post, :count).by(-1)
      end
    end

    context "when user is not the owner" do
      it "does not delete the post" do
        user = create(:user)
        sign_in user
        post = create(:post)
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(posts_path)
      end
    end

    context "when user is not logged in" do
      it "does not delete the post" do
        post = create(:post)
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "check_owner" do
    context "when the current user is the owner" do
      it "does not redirect" do
        user = create(:user)
        post = create(:post, user: user)
        sign_in user
        get :edit, params: { id: post.id }
        expect(response).not_to redirect_to(posts_path)
      end
    end

    context "when the current user is not the owner" do
      it "redirects to posts_path" do
        user = create(:user)
        sign_in user
        post = create(:post)
        get :edit, params: { id: post.id }
        expect(response).to redirect_to(posts_path)
      end
    end
  end
end