# frozen_string_literal: true

describe LabwareCreators::CustomPooledTubes::CsvFile, with: :uploader do
  context 'A valid file' do
    let(:file) { fixture_file_upload('spec/fixtures/files/pooling_file.csv', 'sequencescape/qc_file') }

    describe '#valid?' do
      subject { described_class.new(file).valid? }

      it { is_expected.to be true }
    end

    describe '#pools' do
      subject { described_class.new(file).pools }
      let(:expected_pools) do
        {
          '1' => { 'wells' => %w[A1 B1 D1 E1 F1 G1 H1 A2 B2] },
          '2' => { 'wells' => %w[C1 C2 D2 E2 F2 G2] }
        }
      end
      it { is_expected.to eq expected_pools }
    end
  end

  context 'An invalid file' do
    let(:file) { fixture_file_upload('spec/fixtures/files/test_file.txt', 'sequencescape/qc_file') }

    describe '#valid?' do
      subject { described_class.new(file).valid? }

      it { is_expected.to be false }

      it 'reports the errors' do
        thing = described_class.new(file)
        thing.valid?
        expect(thing.errors.full_messages).to include('Source column could not be found in header row: This is an example file')
      end
    end
  end
end
