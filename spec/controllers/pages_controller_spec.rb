require "rails_helper"

RSpec.describe BlacksandFront::PagesController, :type => :controller do
  routes { Rails.application.routes }

  it '#get' do
    template = Blacksand::Template.create(name: 'test', path: 'templates/index')
    p = Blacksand::Page.create(title: 'test', template: template)

    get :show, params: { id: p.id }

    expect(response).to be_success
    expect(response).to have_http_status(200)
  end
end