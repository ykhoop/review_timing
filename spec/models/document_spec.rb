require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'バリデーション' do
    it 'コード、説明、内容がある場合、登録できる' do
      document = FactoryBot.build(:document)
      expect(document).to be_valid
    end

    it 'コードがない場合、登録できない' do
      document = FactoryBot.build(:document, code: nil)
      expect(document).to be_invalid
      document = FactoryBot.build(:document, code: '')
      expect(document).to be_invalid
    end

    it '説明がない場合、登録できない' do
      document = FactoryBot.build(:document, description: nil)
      expect(document).to be_invalid
      document = FactoryBot.build(:document, description: '')
      expect(document).to be_invalid
    end

    it '内容がない場合、登録できない' do
      document = FactoryBot.build(:document, content: nil)
      expect(document).to be_invalid
      document = FactoryBot.build(:document, content: '')
      expect(document).to be_invalid
    end
  end

  describe 'メソッド' do
    describe 'contact_url' do
      FactoryBot.create(:document_with_additional_documents)
      document = Document.find_by(code: 'contact')
      it 'お問い合わせの内容を返す' do
        expect(Document.contact_url).to eq document.content
      end
    end
  end
end
