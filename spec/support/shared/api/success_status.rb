shared_examples_for 'API successable' do
  it 'return 200 status' do
    expect(response).to be_success
  end
end