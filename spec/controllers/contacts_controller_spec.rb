require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { contact: { email: 'test@example.com', message: 'Hello, world!' } } }

      it 'creates a new contact' do
        expect {
          post :create, params: valid_params
        }.to change(Contact, :count).by(1)
      end

      it 'creates a new contact and assigns it to @contact' do
        post :create, params: valid_params
        expect(assigns(:contact)).to be_a(Contact)
        expect(assigns(:contact)).to be_persisted
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { contact: { email: 'invalid_email', message: '' } } }

      it 'does not create a new contact' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Contact, :count)
      end

      it 'does not save the invalid contact' do
        post :create, params: invalid_params
        expect(assigns(:contact)).to be_a_new(Contact)
        expect(assigns(:contact)).not_to be_persisted
      end

      it 'renders the new template with unprocessable_entity status' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end