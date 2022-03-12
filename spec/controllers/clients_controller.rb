require 'rails_helper'  
include Devise::Test::IntegrationHelpers

RSpec.describe Api::V1::ClientsController, type: :controller do
  setup do
    @admin_user    = create(:user, role: 'admin')
    @manager_user  = create(:user, role: 'manager')
    @employee_user = create(:user, role: 'employee')
  end

  describe 'actions' do
    let!(:clients) { create_list(:client, 10) }
    let(:client_id) { clients.first.id }
    context 'with admin user' do
      sign_in @admin_user
      describe 'GET /clients' do
        before { get '/api/v1/clients' }
        it 'should return 10 clients' do
          byebug
          expect(1).to eq(1)
        end
      end
    end

    context 'with_manager_user' do
      sign_in @manager_user
    end

    context 'with_employee_user' do
      sign_in @employee_user
    end
  end
end
