# frozen_string_literal: true

RSpec.describe KType do
  it 'has a version number' do
    expect(KType::VERSION).not_to be nil
  end

  it 'has a standard error' do
    expect { raise KType::Error, 'some message' }
      .to raise_error('some message')
  end
end
