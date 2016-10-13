require 'rails_helper'

RSpec.describe "pages route", :type => :routing do
  routes { Blacksand::Engine.routes }

  it 'default' do
    expect(:get => "/").to route_to( :controller => "blacksand/dashboard/pages",
                                     :action => "default" )
  end

  it 'index' do
    expect(:get => '/pages').to route_to( :controller => 'blacksand/dashboard/pages',
                                          :action => 'index' )
  end
end