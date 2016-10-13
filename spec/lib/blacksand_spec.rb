require 'rails_helper'

describe Blacksand do
  it '' do
    expect(Blacksand.site_id).to eq 'dark'
    expect(Blacksand.site_name).to eq 'test name'
    expect(Blacksand.root_path).to eq 'root path'
    expect(Blacksand.carrierwave_storage).to eq :file
  end
end