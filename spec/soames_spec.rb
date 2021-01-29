require 'spec_helper'

RSpec.describe Soames do
  it "has a version number" do
    expect(Soames::VERSION).not_to be nil
  end

  it 'responds to configure' do
    expect(described_class).to respond_to(:configure)
  end

  it 'responds to configuration' do
    expect(described_class).to respond_to(:configuration)
  end

  it 'responds to logger' do
    expect(described_class).to respond_to(:logger)
  end

  it 'responds to client methods' do
    expect(described_class).to respond_to(:check_fraud)
  end
end
